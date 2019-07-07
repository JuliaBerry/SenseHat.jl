module LED

import ..ioctl

export led_matrix, RGB565, led_clear, @colorant_str

using Colors, ColorTypes, FixedPointNumbers, Dates, Mmap

function _led_fb_device()
    try
        for devname in readdir("/sys/class/graphics")
            sysfname = joinpath("/sys/class/graphics",devname,"name")
            if startswith(devname, "fb") && isfile(sysfname)
                if startswith(readline(sysfname),"RPi-Sense FB")
                    return joinpath("/dev",devname)
                end
            end
        end
    catch e
        @warn("LED: Sense Hat not found.")
        return nothing
    end
end

const LED_FB_DEVICE_PATH = _led_fb_device()
const LED_FB_DEVICE = Ref{IOStream}()

function __init__()
    if LED_FB_DEVICE_PATH != nothing
        LED_FB_DEVICE[] = open(LED_FB_DEVICE_PATH,"w+")
    end
end

const U5 = Normed{UInt8,5}
const U6 = Normed{UInt8,6}

struct RGB565 <: AbstractRGB{Normed{UInt8, 8}}
    data::UInt16
end

function RGB565(r::U5, g::U6, b::U5)
    RGB565( (UInt16(reinterpret(r)) << 11) |
            (UInt16(reinterpret(g)) << 5) |
            (UInt16(reinterpret(b))) )
end

RGB565(r::Real, g::Real, b::Real) =
    RGB565(convert(U5,r), convert(U6,g), convert(U5,b))
RGB565(c::Union{Color,Colorant}) = RGB565(red(c), green(c), blue(c))

ColorTypes.red(c::RGB565) = U5(c.data >> 11, Val{true})
ColorTypes.green(c::RGB565) = U6((c.data >> 5) & 0x3f, Val{true})
ColorTypes.blue(c::RGB565) = U5(c.data & 0x1f, Val{true})

ColorTypes.ccolor(::Type{RGB565}, ::Type{Csrc}) where {Csrc <: Colorant} = RGB565
ColorTypes.base_color_type(::Type{RGB565}) = RGB565



"""
    led_matrix()

Returns an 8x8 matrix of `RGB565` elements that is memory-mapped to the Sense HAT LED Matrix.

While it is possible to invoke the function multiple times (each returning different
arrays), it is generally preferable to assign it once into a `const` variable so as to
minimise the number of open file handlers.

# Example

```
using SenseHat
using ColorTypes

const LED = led_matrix()

LED[:] = SenseHat.JULIA_LOGO
sleep(3)
LED[:] = RGB(0,0,0)
```

"""
led_matrix() = Mmap.mmap(LED_FB_DEVICE[], Array{RGB565,2}, (8,8); grow=false)




const FBIO_GET_GAMMA = 61696
const FBIO_SET_GAMMA = 61697
const FBIO_RESET_GAMMA = 61698

@enum(GammaScale, GAMMA_DEFAULT, GAMMA_LOW, GAMMA_USER)

"""
    getgamma()

Return the current gamma correction table for the Sense HAT LED matrix, as a vector of 32
`UFixed{UInt8,5}` numbers.

"""
function getgamma()
    buffer = zeros(UInt8, 32)
    ioctl(LED_FB_DEVICE[], FBIO_GET_GAMMA, buffer)
    return buffer
end

"""
    setgamma(v::GammaScale)
    setgamma(table::Vector)

Set the gamma correction for the Sense HAT LED matrix. This can either be one of the
predefined settings (`GAMMA_DEFAULT`, `GAMMA_LOW`, `GAMMA_USER`) or a table of values
between 0 and 1 (the actual values will be converted to `UFixed{UInt8, 5}`).

"""
function setgamma end

function setgamma(v::GammaScale)
    ioctl(LED_FB_DEVICE[], FBIO_RESET_GAMMA, Cint(v))
    return nothing
end

function setgamma(table::Vector{U5})
    length(table) == 32 || error("Table must contain 32 values.")
    ioctl(LED_FB_DEVICE[], FBIO_SET_GAMMA, table)
    return nothing
end
setgamma(table::AbstractVector) = setgamma(convert(Vector{U5}, table))


function led_display(X)
    Base.depwarn("`led_display(X)` has been deprecated, use `led_matrix()[:] = X` instead.", :led_display)
    led_matrix()[:] = X
end

"""
    led_clear()

Sets the SenseHat LED matrix to all black.
"""
function led_clear()
    led_matrix()[:] .= RGB565(0,0,0)
    return
end

end # module
