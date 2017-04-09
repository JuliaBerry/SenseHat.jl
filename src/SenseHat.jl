__precompile__()
module SenseHat

export led_matrix, RGB565,
    Stick, StickEvent, sticktask, readstick

include("led.jl")
using .LED
include("led_extra.jl")

include("stick.jl")
using .Stick

end # module
