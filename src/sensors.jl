module Sensors
export humidity, temperature, pressure


const I2C_DEVICE_PATH = "/dev/i2c-1"
const I2C_DEVICE = Ref{IOStream}()
const I2C_ADDR = Ref{UInt8}(0xff)

function __init__()
    try
        I2C_DEVICE[] = open("/dev/i2c-1","r+")
        HTS221_calibrate()
    catch
        @warn("I2C: Sense Hat not found")
    end
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
include("LPS25H.jl")


"""
    humidity()

The relative humidity (as a percentage between 0 and 100).
"""
humidity()    = HTS221_humidity()

"""
    temperature()

The temperature (in °C).
"""
temperature() = HTS221_temperature()

"""
    pressure()

The atmospheric pressure (in millibars).
"""
pressure()    = LPS25H_pressure()


end # module
