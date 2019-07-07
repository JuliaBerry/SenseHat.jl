# SenseHat.jl

SenseHat.jl is a Julia library for interacting with the Raspberry Pi [Sense HAT](https://www.raspberrypi.org/products/sense-hat/).

SenseHat.jl requires the Raspbian `sense-hat` package:

```bash
sudo apt-get update
sudo apt-get install sense-hat
sudo reboot
```

## LED matrix

The main interface is the `led_matrix()` function, which creates an 8&times;8 array of RGB
values (from [ColorTypes.jl](https://github.com/JuliaGraphics/ColorTypes.jl)) which is
memory-mapped to the frame buffer of the LED matrix. `led_clear()` is a convenience
function for resetting the LED matrix to black.

```julia
using SenseHat
using ColorTypes

const LED = led_matrix()

LED[:] = SenseHat.JULIA_LOGO
sleep(3)
led_clear()
```

## Joystick

In the `Stick` module there is `readstick()` which will block until the joystick is
manipulated, returning a `StickEvent`:

```julia
using SenseHat

e = readstick()
```

For querying within a loop, use a `Channel` to create a buffer of `StickEvent`.

```julia
using SenseHat

c = Channel{StickEvent}(32)

@async while true
    put!(c, readstick())
end
```

## Sensors

`humidity()`, `temperature()` and `pressure()` will read values from the corresponding sensors.

The inertial measurement unit (IMU) is not yet supported, but is coming soon. In the meantime, you can use the [python library](https://pythonhosted.org/sense-hat/) via [PyCall.jl](https://github.com/JuliaPy/PyCall.jl).
