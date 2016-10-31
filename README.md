# SenseHat.jl

SenseHat.jl is a Julia library for interacting with the Raspberry Pi [Sense HAT](https://www.raspberrypi.org/products/sense-hat/).

## LED matrix

The `led_display(X)` function will display an 8&times;8 matrix of colors on the LED matrix (see [ColorTypes.jl](https://github.com/JuliaGraphics/ColorTypes.jl):

    led_display(SenseHat.JULIA_LOGO)
    sleep(1)
    led_clear()
