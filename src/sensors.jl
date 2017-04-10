module Sensors

const I2C_DEVICE_PATH = "/dev/i2c-1"
const I2C_DEVICE = Ref{IOStream}()
const I2C_ADDR = Ref{UInt8}(0xff)

function __init__()
    I2C_DEVICE[] = open("/dev/i2c-1","r+")
    HTS221_calibrate()
end

import ..ioctl
include("smbus.jl")

const LPS25H_ADDRESS = 0x5c # Pressure/temp
const HTS221_ADDRESS = 0x5f # Humidity/temp

function setaddr(addr::UInt8)
    if I2C_ADDR[] != addr
        ioctl(I2C_DEVICE[], I2C_SLAVE, addr)
        I2C_ADDR[] = addr
    end
end

include("HTS221.jl")


end # module
