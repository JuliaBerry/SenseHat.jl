__precompile__()
module SenseHat

export led_display, led_clear,
    Stick, StickEvent, sticktask, readstick

include("led.jl")
include("led_extra.jl")
using .LED

include("stick.jl")
using .Stick

end # module
