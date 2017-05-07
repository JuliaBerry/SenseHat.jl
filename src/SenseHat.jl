__precompile__()
module SenseHat

export led_matrix, RGB565,
    Stick, StickEvent, sticktask, readstick,
    pressure, temperature, humidity


include("utils.jl")

include("led.jl")
using .LED
include("led_extra.jl")

include("stick.jl")
using .Stick

include("sensors.jl")
using .Sensors

end # module
