# SenseHat.jl

SenseHat.jl is a Julia library for interacting with the Raspberry Pi [Sense HAT](https://www.raspberrypi.org/products/sense-hat/).

SenseHat.jl requires the Raspbian `sense-hat` package:

    sudo apt-get update
    sudo apt-get install sense-hat
    sudo reboot

## LED matrix

The `led_display(X)` function will display an 8&times;8 matrix of colors on the LED matrix (see [ColorTypes.jl](https://github.com/JuliaGraphics/ColorTypes.jl)). `led_clear()` will set all the LEDs to black.

    using SenseHat

    led_display(SenseHat.JULIA_LOGO)
    sleep(1)
    led_clear()

## Joystick

In the `Stick` module there is a `StickEventTask` which will produce `StickEvent`s whenever the joystick is manipulated. This will typically be used asynchronously, e.g.

    using SenseHat

    @schedule for e in StickEventTask
        println(e)
    end

will create a new task that prints the events and adds it to the scheduler. See the help for `StickEvent` and `StickEventTask` for more details.

## Sensors

Coming soon: in the meantime, you can use the [python library](https://pythonhosted.org/sense-hat/) via [PyCall.jl](https://github.com/JuliaPy/PyCall.jl).