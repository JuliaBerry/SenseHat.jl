# HTS221 humidity/temperature sensor.
# See http://www.st.com/resource/en/datasheet/hts221.pdf

const HTS221_t_coef  = Ref((NaN,NaN))
const HTS221_h_coef  = Ref((NaN,NaN))

function HTS221_calibrate()
    setaddr(HTS221_ADDRESS)   
    @assert smbus_read(0x0F) == 0xbc

    ## read temp calibration data
    # raw values
    t0_raw = Int16(smbus_read(0x3d))<<8 | smbus_read(0x3c)
    t1_raw = Int16(smbus_read(0x3f))<<8 | smbus_read(0x3e)

    # known °C
    u = smbus_read(0x35)
    t0_C = Float64(Int16(u & 0b0011) << 8 | smbus_read(0x32))/8
    t1_C = Float64(Int16(u & 0b1100) << 6 | smbus_read(0x33))/8
    
    m_t = (t1_C - t0_C)/(Float64(t1_raw) - Float64(t0_raw))
    k_t = t1_C - m_t*t1_raw
    HTS221_t_coef[] = (t_m, t_k)

    ## read humidity calibration data
    h0_raw = Int16(smbus_read(0x37))<<8 | smbus_read(0x36)
    h1_raw = Int16(smbus_read(0x3b))<<8 | smbus_read(0x3a)

    h0_rH = Float64(smbus_read(0x30))/200
    h1_rH = Float64(smbus_read(0x31))/200

    m_h = (h0_rH - h1_rH)/(Float64(h1_raw) - Float64(h0_raw))
    k_h = h1_rH - m_h*h1_raw
    HTS221_h_coef[] = (h_m, h_k)

    return nothing
end

function HTS221_raw_temp()
    setaddr(HTS221_ADDRESS)
    CTRL_REG1 = 0x20
    CTRL_REG2 = 0x21
    
    smbus_write(CTRL_REG1, 0x00) # power down
    smbus_write(CTRL_REG1, 0x84) # power on, block update
    smbus_write(CTRL_REG2, 0x01) # one-shot aquisition

    while true
        sleep(0.025)
        smbus_read(CTRL_REG2) == 0 && break # check if finished
    end
    t_raw = Int16(smbus_read(0x2b))<<8 | smbus_read(0x2a)
    smbus_write(CTRL_REG1, 0x00) # power down
    return t_raw
end

function HTS221_raw_humidity()
    setaddr(HTS221_ADDRESS)
    CTRL_REG1 = 0x20
    CTRL_REG2 = 0x21
    
    smbus_write(CTRL_REG1, 0x00) # power down
    smbus_write(CTRL_REG1, 0x84) # power on, block update
    smbus_write(CTRL_REG2, 0x01) # one-shot aquisition

    while true
        sleep(0.025)
        smbus_read(CTRL_REG2) == 0 && break # check if finished
    end
    h_raw = Int16(smbus_read(0x29))<<8 | smbus_read(0x28)
    smbus_write(CTRL_REG1, 0x00) # power down
    return h_raw
end


function HTS221_temp()
    (m_t, k_t) = HTS221_t_coef[]
    t_raw = HTS221_raw_temp()
    m_t*t_raw + k_t
end
function HTS221_humidity()
    (m_h, k_h) = HTS221_h_coef[]
    h_raw = HTS221_raw_humidity()
    m_h*h_raw + k_h
end
