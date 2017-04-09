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

In the `Stick` module there is `readstick()` which will block until the joystick is manipulated, returning a `StickEvent`:

    using SenseHat

    e = readstick()

For asynchronous use, `sticktask() will create a `Task` for producing `StickEvent`s, e.g.

    using SenseHat

    @schedule for e in sticktask()
        println(e)
    end

will create a new task that prints the event, then and add it to the scheduler. See the help for `StickEvent` and `sticktask` for more details.

## Sensors

Coming soon: in the meantime, you can use the [python library](https://pythonhosted.org/sense-hat/) via [PyCall.jl](https://github.com/JuliaPy/PyCall.jl).