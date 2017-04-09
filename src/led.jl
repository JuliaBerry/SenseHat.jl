module LED
export led_matrix, RGB565

using ColorTypes, FixedPointNumbers

function _led_fb_device()
    try
        for devname in readdir("/sys/class/graphics")
            sysfname = joinpath("/sys/class/graphics",devname,"name")
            if startswith(devname, "fb") && isfile(sysfname)
                if startswith(readstring(sysfname),"RPi-Sense FB")
                    return joinpath("/dev",devname)
                end
            end
        end
    catch e
    end
    error("Sense Hat not found.")
end

const LED_FB_DEVICE = _led_fb_device()


typealias U5 UFixed{UInt8,5}
typealias U6 UFixed{UInt8,6}

immutable RGB565 <: AbstractRGB{U8}
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

ColorTypes.ccolor{Csrc<:Colorant}(::Type{RGB565}, ::Type{Csrc}) = RGB565
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
led_matrix() = Mmap.mmap(LED_FB_DEVICE, Array{RGB565,2}, (8,8); grow=false)




"""
    led_display(X)

Display an image `X` on the SenseHat LED matrix.

`X` should be an 8×8 matrix of colors (see the ColorTypes.jl package).

See also:
* `rotl90`, `rotr90` and `rot180` for rotating the image.
* `flipdim` for reflecting the image.
* `led_clear` for clearing the LED matrix.
"""
function led_display(X)
    Base.depwarn("`led_display(X)` has been deprecated, use `led_matrix()[:] = X` instead.", :led_display)
    size(X) == (8,8) || throw(DimensionMismatch("Can only display 8x8 images"))
    open(LED_FB_DEVICE, "w") do fb
        for j = 1:8
            for i = 1:8
                write(fb, convert(RGB565, X[i,j]).data)
            end
        end
    end
end

"""
    led_clear()

Sets the SenseHat LED matrix to all black.
"""
function led_clear()
    Base.depwarn("`led_clear()` has been deprecated, use `led_matrix()[:] = SenseHat.RGB565(0,0,0)` instead.", :led_display)
    open(LED_FB_DEVICE, "w") do fb
        for j = 1:8
            for i = 1:8
                write(fb, UInt16(0))
            end
        end
    end
end

end # module
