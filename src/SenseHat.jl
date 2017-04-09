__precompile__()
module SenseHat

export led_display, led_clear,
    Stick, StickEvent, sticktask, readstick

include("led.jl")
using .LED
include("led_extra.jl")

include("stick.jl")
using .Stick

end # module
