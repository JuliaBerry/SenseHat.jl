# LPS25H pressure/temperature sensor
# See http://www.st.com/resource/en/datasheet/lps25h.pdf

function LPS25H_pressure()
    setaddr(LPS25H_ADDRESS)
    CTRL_REG1 = 0x20
    CTRL_REG2 = 0x21

    smbus_write(CTRL_REG1, 0x00) # power down
    smbus_write(CTRL_REG1, 0x84) # power on, block update
    smbus_write(CTRL_REG2, 0x01) # one-shot aquisition

    while true
        sleep(0.025)
        smbus_read(CTRL_REG2) == 0 && break # check if finished
    end

    pressure = (Int32(smbus_read(0x2a)) << 16 | Int16(smbus_read(0x29)) << 8 | smbus_read(0x28)) / 4096

    smbus_write(CTRL_REG1, 0x00) # power down
    return pressure
end

function LPS25H_temp()
    setaddr(LPS25H_ADDRESS)
    CTRL_REG1 = 0x20
    CTRL_REG2 = 0x21

    smbus_write(CTRL_REG1, 0x00) # power down
    smbus_write(CTRL_REG1, 0x84) # power on, block update
    smbus_write(CTRL_REG2, 0x01) # one-shot aquisition

    while true
        sleep(0.025)
        smbus_read(CTRL_REG2) == 0 && break # check if finished
    end

    temp = 42.5 + (Int16(smbus_read(0x2c)) << 8 | smbus_read(0x2b)) / 480

    smbus_write(CTRL_REG1, 0x00) # power down
    return temp
end


