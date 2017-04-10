# A basic implementation of the SMBus interface
# Based on the i2c-dev.h (the header only "static inline" version from i2c-tools)

const I2C_SMBUS_READ  = 0x01
const I2C_SMBUS_WRITE = 0x00

const I2C_SMBUS_BYTE       = 0x01
const I2C_SMBUS_BYTE_DATA  = 0x02

const I2C_SLAVE  = 0x0703
const I2C_SMBUS  = 0x0720

immutable SMBusData
    read_write ::UInt8
    command    ::UInt8
    size       ::UInt32
    data       ::Ptr{UInt8}
end

function smbus_read(cmd::UInt8)
    buffer = Ref(UInt8(0))
    data = SMBusData(I2C_SMBUS_READ, cmd, I2C_SMBUS_BYTE_DATA, Base.unsafe_conver(Ptr{UInt8}, buffer))
    ioctl(I2C_DEVICE[], I2C_SMBUS, Ref(data))
    return buffer[]
end
function smbus_write(cmd::UInt8, val::UInt8)
    buffer = Ref(val)
    data = SMBusData(I2C_SMBUS_WRITE, cmd, I2C_SMBUS_BYTE_DATA, Base.unsafe_conver(Ptr{UInt8}, buffer))
    ioctl(I2C_DEVICE[], I2C_SMBUS, Ref(data))
    return 1
end
