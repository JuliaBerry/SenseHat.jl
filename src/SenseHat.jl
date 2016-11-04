module SenseHat

export led_display, led_clear,
    Stick, StickEvent, StickEventTask

include("led.jl")
import .LED: led_display, led_clear, RGB565
include("led_extra.jl")

include("stick.jl")
import .Stick: StickEvent, StickEventTask

end # module
