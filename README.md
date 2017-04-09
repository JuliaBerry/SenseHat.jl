# SenseHat.jl

SenseHat.jl is a Julia library for interacting with the Raspberry Pi [Sense HAT](https://www.raspberrypi.org/products/sense-hat/).

SenseHat.jl requires the Raspbian `sense-hat` package:

    sudo apt-get update
    sudo apt-get install sense-hat
    sudo reboot

## LED matrix

The main interface is the `led_matrix()` function, which creates an 8&times;8 array of RGB values (from [ColorTypes.jl](https://github.com/JuliaGraphics/ColorTypes.jl)) which is memory-mapped to the frame buffer of the LED matrix.

    using SenseHat
    using ColorTypes
    
    const LED = led_matrix()
    
    LED[:] = SenseHat.JULIA_LOGO
    sleep(3)
    LED[:] = RGB(0,0,0)

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