module Text

using ColorTypes, Colors

import SenseHat.LED: RGB565, led_matrix, led_clear
import Colors.@colorant_str

export show_char, show_message

"""
    show_char(c::Char, color::ColorTypes.AbstractRGB = colorant"white")

Display a single character `c` on the `SenseHat` LED Matrix.
"""
function show_char(c::Char, color::ColorTypes.AbstractRGB = colorant"white")
    if haskey(font, c)
        tocolor(b) = b ? RGB565(color) : RGB565(colorant"black")
        L = PermutedDimsArray(led_matrix(), (2, 1))
        L[:] .= colorant"black"
        L[:,2:6] .= tocolor.(font[c])
    else
        error("Character font for $c not available \n")
    end
    return
end

"""
    show_message(s::String, speed::Real = 0.2, color::ColorTypes.AbstractRGB = colorant"white")

Display a scrolling message `s` on the `SenseHat` LED Matrix. `speed` is the time in seconds per frame and `color` is the color of text.

# Example

```
using SenseHat

show_message("Hello, World!", 0.2, colorant"purple")
```
"""
function show_message(s::String, speed::Real = 0.2, color::ColorTypes.AbstractRGB = colorant"white")
    for c in s
        if haskey(font, c) == false
            error("Character font for $c not available \n")
            return
        end
        img = Array{Bool, 2}(undef, 8, 16 + 5*length(s))
        img[:] .= 0
        for i in 1:length(s)
            img[1:8, (4 + 5*i):(8 + 5*i)] = font[s[i]]
        end
        tocolor(b) = b ? RGB565(color) : RGB565(colorant"black")
        for i in 1:(size(img,2) - 7)
            frame = tocolor.(img[1:8, i:(i + 7)])
            led_matrix()[:] = permutedims(frame, (2,1))
            sleep(speed)
        end
    return
    end
end

show_message(s::String, color::ColorTypes.AbstractRGB) = show_message(s, 0.2, color)

font = Dict(
# English
' ' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'+' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 1 1 1 1 1 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; ]),
'-' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'*' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 1 0 0 ; 1 0 1 0 1 ; 0 1 1 1 0 ; 1 0 1 0 1 ; 0 0 1 0 0 ; 0 0 0 0 0 ; ]),
'/' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 1 0 0 0 0 ; 0 0 0 0 0 ; ]),
'!' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 0 1 0 0 ; ]),
'"' => Bool.([0 0 0 0 0 ; 0 1 0 1 0 ; 0 1 0 1 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'#' => Bool.([0 0 0 0 0 ; 0 1 0 1 0 ; 0 1 0 1 0 ; 1 1 1 1 1 ; 0 1 0 1 0 ; 1 1 1 1 1 ; 0 1 0 1 0 ; 0 1 0 1 0 ; ]),
'$' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 1 1 1 1 ; 1 0 1 0 0 ; 0 1 1 1 0 ; 0 0 1 0 1 ; 1 1 1 1 0 ; 0 0 1 0 0 ; ]),
'>' => Bool.([0 0 0 0 0 ; 0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 1 0 ; 0 0 0 0 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; ]),
'<' => Bool.([0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 1 0 0 0 0 ; 0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 1 0 ; ]),
'0' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 1 1 ; 1 0 1 0 1 ; 1 1 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'1' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; ]),
'2' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 0 0 0 0 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 1 1 1 1 1 ; ]),
'3' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 1 0 ; 0 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'4' => Bool.([0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 1 1 0 ; 0 1 0 1 0 ; 1 0 0 1 0 ; 1 1 1 1 1 ; 0 0 0 1 0 ; 0 0 0 1 0 ; ]),
'5' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 1 1 1 1 0 ; 0 0 0 0 1 ; 0 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'6' => Bool.([0 0 0 0 0 ; 0 0 1 1 0 ; 0 1 0 0 0 ; 1 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'7' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 0 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'8' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'9' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; 0 0 0 0 1 ; 0 0 0 1 0 ; 0 1 1 0 0 ; ]),
'.' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 1 1 0 0 ; ]),
'=' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
')' => Bool.([0 0 0 0 0 ; 0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; ]),
'(' => Bool.([0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 1 0 ; ]),
'A' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'B' => Bool.([0 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 1 1 0 ; ]),
'C' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'D' => Bool.([0 0 0 0 0 ; 1 1 1 0 0 ; 1 0 0 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 1 0 ; 1 1 1 0 0 ; ]),
'E' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 1 1 1 1 ; ]),
'F' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; ]),
'G' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 0 ; 1 0 1 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; ]),
'H' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'I' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; ]),
'J' => Bool.([0 0 0 0 0 ; 0 0 1 1 1 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 1 0 0 1 0 ; 0 1 1 0 0 ; ]),
'K' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 1 0 ; 1 0 1 0 0 ; 1 1 0 0 0 ; 1 0 1 0 0 ; 1 0 0 1 0 ; 1 0 0 0 1 ; ]),
'L' => Bool.([0 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 1 1 1 1 ; ]),
'M' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 1 0 1 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'N' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 0 0 1 ; 1 0 1 0 1 ; 1 0 0 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'O' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'P' => Bool.([0 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 1 1 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; ]),
'Q' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 1 0 1 ; 1 0 0 1 0 ; 0 1 1 0 1 ; ]),
'R' => Bool.([0 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 1 1 0 ; 1 0 1 0 0 ; 1 0 0 1 0 ; 1 0 0 0 1 ; ]),
'S' => Bool.([0 0 0 0 0 ; 0 1 1 1 1 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 0 1 ; 0 0 0 0 1 ; 1 1 1 1 0 ; ]),
'T' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'U' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'V' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 0 1 0 ; 0 0 1 0 0 ; ]),
'W' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 1 1 0 1 1 ; 1 0 0 0 1 ; ]),
'X' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 0 1 0 ; 0 0 1 0 0 ; 0 1 0 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'Y' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 0 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'Z' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 0 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 1 0 0 0 0 ; 1 1 1 1 1 ; ]),
'a' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 0 1 ; 0 1 1 1 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; ]),
'b' => Bool.([0 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 1 1 0 ; 1 1 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'c' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'd' => Bool.([0 0 0 0 0 ; 0 0 0 0 1 ; 0 0 0 0 1 ; 0 1 1 0 1 ; 1 0 0 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; ]),
'e' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 0 1 1 1 0 ; ]),
'f' => Bool.([0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 1 0 1 ; 0 0 1 0 0 ; 0 1 1 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'g' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; 0 0 0 0 1 ; 0 1 1 1 0 ; ]),
'h' => Bool.([0 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 1 1 0 ; 1 1 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'i' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; ]),
'j' => Bool.([0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 1 0 0 1 0 ; 0 1 1 0 0 ; ]),
'k' => Bool.([0 0 0 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 1 0 0 1 ; 0 1 0 1 0 ; 0 1 1 0 0 ; 0 1 0 1 0 ; 0 1 0 0 1 ; ]),
'l' => Bool.([0 0 0 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; ]),
'm' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 0 1 0 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; ]),
'n' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 1 1 0 ; 1 1 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'o' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'p' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; ]),
'q' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; 0 0 0 0 1 ; 0 0 0 0 1 ; ]),
'r' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 0 1 1 ; 0 1 1 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; ]),
's' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 1 ; 1 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 0 1 ; 1 1 1 1 0 ; ]),
't' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 1 ; 0 0 0 1 0 ; ]),
'u' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 1 1 ; 0 1 1 0 1 ; ]),
'v' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 0 1 0 ; 0 0 1 0 0 ; ]),
'w' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 0 1 0 1 0 ; ]),
'x' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 0 0 1 ; 0 0 1 1 0 ; 0 0 1 0 0 ; 0 1 1 0 0 ; 1 0 0 1 1 ; ]),
'y' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 0 1 0 0 1 ; 0 0 1 1 0 ; 0 0 1 0 0 ; 1 1 0 0 0 ; ]),
'z' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 1 1 1 1 1 ; ]),
'?' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 0 0 0 0 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 0 1 0 0 ; ]),
',' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; ]),
';' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 1 1 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; ]),
':' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 1 1 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 1 1 0 0 ; 0 0 0 0 0 ; ]),
'|' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'@' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 0 0 0 0 1 ; 0 1 1 0 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 0 1 1 1 0 ; ]),
'%' => Bool.([0 0 0 0 0 ; 1 1 0 0 0 ; 1 1 0 0 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 1 0 0 1 1 ; 0 0 0 1 1 ; ]),
'[' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 1 1 1 0 ; ]),
'&' => Bool.([0 0 0 0 0 ; 0 1 1 0 0 ; 1 0 0 1 0 ; 1 0 1 0 0 ; 0 1 0 0 0 ; 1 0 1 0 1 ; 1 0 0 1 0 ; 0 1 1 0 1 ; ]),
'_' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; ]),
'\'' => Bool.([0 0 0 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
']' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 1 1 1 0 ; ]),
'\\' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 0 0 ; 0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 1 0 ; 0 0 0 0 1 ; 0 0 0 0 0 ; ]),
'~' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 0 1 ; 1 0 1 1 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
# Greek
'Γ' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; ]),
'Δ' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 1 1 1 1 ; ]),
'Θ' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'Ι' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 0 1 0 0 ; ]),
'Λ' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'Ξ' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; ]),
'Π' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'Σ' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 0 1 0 0 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 1 0 0 0 0 ; 1 1 1 1 1 ; ]),
'Φ' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 0 1 1 1 0 ; 0 0 1 0 0 ; ]),
'Ψ' => Bool.([0 0 0 0 0 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 0 1 1 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'Ω' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 0 1 0 ; 1 1 0 1 1 ; ]),
'α' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 0 1 ; 1 0 0 1 0 ; 1 0 0 1 0 ; 1 0 0 1 0 ; 0 1 1 0 1 ; ]),
'β' => Bool.([0 0 0 0 0 ; 1 1 1 0 0 ; 1 0 0 1 0 ; 1 1 1 0 0 ; 1 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 0 ; 1 0 0 0 0 ; ]),
'γ' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 0 1 0 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'δ' => Bool.([0 0 0 0 0 ; 0 1 1 1 1 ; 0 0 1 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'ε' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 0 1 1 0 0 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'ζ' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 0 0 1 1 0 ; 0 0 0 0 1 ; 0 0 0 1 0 ; ]),
'η' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 1 1 0 ; 1 1 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 0 0 0 1 ; ]),
'θ' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'ι' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 1 ; 0 0 0 1 0 ; ]),
'κ' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 1 0 ; 1 0 1 0 0 ; 1 1 0 0 0 ; 1 0 1 0 0 ; 1 0 0 1 0 ; ]),
'λ' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 0 0 ; 0 1 0 0 0 ; 0 0 1 0 0 ; 0 1 0 1 0 ; 1 0 0 0 1 ; ]),
'μ' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 1 1 ; 1 1 1 0 1 ; 1 0 0 0 0 ; ]),
'ν' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 0 1 0 ; 0 0 1 0 0 ; ]),
'ξ' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 0 ; 0 1 1 0 1 ; 1 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 0 1 ; 0 0 0 1 0 ; ]),
'ο' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'π' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; 0 1 0 1 0 ; 0 1 0 1 0 ; 0 1 0 1 0 ; 0 1 0 1 0 ; ]),
'ρ' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; ]),
'σ' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 1 ; 1 0 0 1 0 ; 1 0 0 1 0 ; 1 0 0 1 0 ; 0 1 1 0 0 ; ]),
'τ' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 1 0 1 0 ; 0 0 1 0 0 ; ]),
'υ' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'φ' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 1 0 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 0 1 1 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'χ' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 0 0 1 ; 0 0 1 1 0 ; 0 0 1 0 0 ; 0 1 1 0 0 ; 1 0 0 1 1 ; ]),
'ψ' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 0 1 1 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'ω' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 0 1 0 ; 1 0 0 0 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 0 1 0 1 0 ; ]),
'ά' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 0 1 ; 1 0 0 1 0 ; 1 0 0 1 0 ; 1 0 0 1 0 ; 0 1 1 0 1 ; ]),
'έ' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 0 1 1 0 0 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'ή' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 1 0 1 1 0 ; 1 1 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 0 0 0 1 ; ]),
'ί' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 1 ; 0 0 0 1 0 ; ]),
'ό' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'ύ' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 1 0 0 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'ώ' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 0 1 0 ; 1 0 0 0 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 0 1 0 1 0 ; ]),
# Accented Vowels
'Á' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'É' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 0 ; 1 1 1 1 1 ; ]),
'Í' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; ]),
'Ó' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'Ú' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'Ý' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 0 1 0 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'á' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 0 1 ; 0 1 1 1 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; ]),
'é' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 0 1 1 1 0 ; ]),
'í' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; ]),
'ó' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'ú' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 1 1 ; 0 1 1 0 1 ; ]),
'ý' => Bool.([0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 0 1 0 0 1 ; 0 0 1 1 0 ; 0 0 1 0 0 ; 1 1 0 0 0 ; ]),
'À' => Bool.([0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'È' => Bool.([0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 0 ; 1 1 1 1 1 ; ]),
'Ì' => Bool.([0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; ]),
'Ò' => Bool.([0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'Ù' => Bool.([0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'à' => Bool.([0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 0 1 ; 0 1 1 1 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; ]),
'è' => Bool.([0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 0 1 1 1 0 ; ]),
'ì' => Bool.([0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; ]),
'ò' => Bool.([0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'ù' => Bool.([0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 1 1 ; 0 1 1 0 1 ; ]),
'Â' => Bool.([0 0 1 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'Ê' => Bool.([0 0 1 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 0 ; 1 1 1 1 1 ; ]),
'Î' => Bool.([0 0 1 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; ]),
'Ô' => Bool.([0 0 1 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'Û' => Bool.([0 0 1 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'â' => Bool.([0 0 1 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 0 1 ; 0 1 1 1 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; ]),
'ê' => Bool.([0 0 1 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 0 1 1 1 0 ; ]),
'î' => Bool.([0 0 1 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; ]),
'ô' => Bool.([0 0 1 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'û' => Bool.([0 0 1 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 1 1 ; 0 1 1 0 1 ; ]),
'Ä' => Bool.([0 0 0 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'Ë' => Bool.([0 0 0 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 0 ; 1 1 1 1 1 ; ]),
'Ï' => Bool.([0 0 0 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; ]),
'Ö' => Bool.([0 0 0 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'Ü' => Bool.([0 0 0 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'Ÿ' => Bool.([0 0 0 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 0 1 0 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'ä' => Bool.([0 0 0 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 0 1 ; 0 1 1 1 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; ]),
'ë' => Bool.([0 0 0 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 0 1 1 1 0 ; ]),
'ï' => Bool.([0 0 0 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; ]),
'ö' => Bool.([0 0 0 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'ü' => Bool.([0 0 0 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 1 1 ; 0 1 1 0 1 ; ]),
'ÿ' => Bool.([0 0 0 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 0 1 0 0 1 ; 0 0 1 1 0 ; 0 0 1 0 0 ; 1 1 0 0 0 ; ]),
'Ã' => Bool.([0 1 1 0 1 ; 1 0 1 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'Ñ' => Bool.([0 1 1 0 1 ; 1 0 1 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'Õ' => Bool.([0 1 1 0 1 ; 1 0 1 1 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 1 0 0 1 ; 1 0 1 0 1 ; 1 0 0 1 1 ; 1 0 0 0 1 ; ]),
'ã' => Bool.([0 1 1 0 1 ; 1 0 1 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 0 1 ; 0 1 1 1 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; ]),
'ñ' => Bool.([0 1 1 0 1 ; 1 0 1 1 0 ; 0 0 0 0 0 ; 1 0 1 1 0 ; 1 1 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'õ' => Bool.([0 1 1 0 1 ; 1 0 1 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
# Accented Consonants and Other Foreign Characters
'Ç' => Bool.([0 0 0 0 0 ; 0 1 1 1 1 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 0 1 1 1 1 ; 0 0 1 0 0 ; 0 1 0 0 0 ; ]),
'ç' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 1 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 0 1 1 1 1 ; 0 0 1 0 0 ; 0 1 0 0 0 ; ]),
'Œ' => Bool.([0 0 0 0 0 ; 0 1 1 1 1 ; 1 0 1 0 0 ; 1 0 1 0 0 ; 1 0 1 1 0 ; 1 0 1 0 0 ; 1 0 1 0 0 ; 0 1 1 1 1 ; ]),
'œ' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 0 1 0 ; 1 0 1 0 1 ; 1 0 1 1 1 ; 1 0 1 0 0 ; 0 1 0 1 1 ; ]),
'Æ' => Bool.([0 0 0 0 0 ; 0 1 1 1 1 ; 1 0 1 0 0 ; 1 0 1 0 0 ; 1 1 1 1 0 ; 1 0 1 0 0 ; 1 0 1 0 0 ; 1 0 1 1 1 ; ]),
'æ' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 0 1 0 ; 0 0 1 0 1 ; 0 1 1 1 1 ; 1 0 1 0 0 ; 1 1 1 1 1 ; ]),
'ß' => Bool.([0 0 0 0 0 ; 0 1 1 0 0 ; 1 0 0 1 0 ; 1 0 1 0 0 ; 1 0 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 1 1 0 ; ]),
'º' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 0 1 0 1 0 ; 0 1 1 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'ª' => Bool.([0 0 0 0 0 ; 0 0 1 1 0 ; 0 1 0 1 0 ; 0 0 1 1 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'ø' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 1 1 0 ; ]),
'Ø' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 1 1 ; 1 0 1 0 1 ; 1 1 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'Å' => Bool.([0 0 1 0 0 ; 0 1 0 1 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'å' => Bool.([0 0 1 0 0 ; 0 1 0 1 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; 0 0 0 0 1 ; 0 1 1 1 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; ]),
'Þ' => Bool.([0 0 0 0 0 ; 1 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 1 1 0 ; 1 0 0 0 0 ; ]),
'þ' => Bool.([0 0 0 0 0 ; 1 0 0 0 0 ; 1 0 1 1 0 ; 1 1 0 0 1 ; 1 0 0 0 1 ; 1 1 0 0 1 ; 1 0 1 1 0 ; 1 0 0 0 0 ; ]),
'Ð' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 0 1 0 0 1 ; 0 1 0 0 1 ; 1 1 1 0 1 ; 0 1 0 0 1 ; 0 1 0 0 1 ; 0 1 1 1 0 ; ]),
'ð' => Bool.([0 0 0 0 0 ; 0 1 0 1 0 ; 0 0 1 0 0 ; 0 1 0 1 0 ; 0 0 1 1 1 ; 0 1 0 0 1 ; 0 1 0 0 1 ; 0 0 1 1 0 ; ]),
'Š' => Bool.([0 1 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 1 1 ; 1 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 0 1 ; 1 1 1 1 0 ; ]),
'š' => Bool.([0 1 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 1 1 ; 1 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 0 1 ; 1 1 1 1 0 ; ]),
'Ž' => Bool.([0 1 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 1 1 1 1 1 ; ]),
'ž' => Bool.([0 1 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 1 1 1 1 1 ; ]),
# Foreign Punctuation
'¿' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'¡' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'«' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 1 0 1 ; 0 1 0 1 0 ; 1 0 1 0 0 ; 0 1 0 1 0 ; 0 0 1 0 1 ; 0 0 0 0 0 ; ]),
'»' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 1 0 0 ; 0 1 0 1 0 ; 0 0 1 0 1 ; 0 1 0 1 0 ; 1 0 1 0 0 ; 0 0 0 0 0 ; ]),
#Arabic
'أ' => Bool.([0 1 1 0 0 ; 0 1 1 0 0 ; 0 0 0 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'ب' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 0 0 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'ج' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 0 1 1 0 0 ; 1 0 0 0 0 ; 1 0 1 0 0 ; 1 0 0 0 1 ; 0 1 1 1 0 ; 0 0 0 0 0 ; ]),
'د' => Bool.([0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 0 0 1 ; 0 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'ه' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; 1 0 0 1 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'و' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 1 0 1 0 ; 0 0 1 1 0 ; 1 0 0 1 0 ; 0 1 1 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'ز' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; 0 0 0 0 0 ; ]),
'ح' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 0 1 1 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 1 ; 0 1 1 1 0 ; 0 0 0 0 0 ; ]),
'ط' => Bool.([0 1 0 0 0 ; 0 1 1 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 1 1 1 0 ; 0 1 0 0 1 ; 1 1 1 1 1 ; 0 0 0 0 0 ; ]),
'ي' => Bool.([0 0 0 1 1 ; 1 0 1 0 0 ; 1 0 0 1 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 0 0 0 0 ; ]),
'ك' => Bool.([0 0 0 1 1 ; 0 0 0 0 1 ; 0 0 0 0 1 ; 0 0 1 0 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'ل' => Bool.([0 0 0 0 0 ; 0 0 0 0 1 ; 0 0 0 0 1 ; 0 0 0 0 1 ; 0 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 1 0 ; 0 1 1 0 0 ; ]),
'م' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 1 0 1 0 ; 0 0 0 1 0 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; ]),
'ن' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 1 ; 0 0 0 0 1 ; 0 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'س' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 1 1 1 ; 1 0 1 1 1 ; 1 1 1 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'ع' => Bool.([0 0 0 0 0 ; 1 1 0 0 0 ; 1 0 0 0 0 ; 1 1 1 0 0 ; 0 1 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 0 1 1 1 1 ; ]),
'ف' => Bool.([0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 0 0 0 ; 0 0 0 1 1 ; 1 0 0 1 1 ; 0 1 1 1 1 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'ص' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 1 1 1 ; 1 1 1 1 1 ; 1 1 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'ق' => Bool.([0 0 0 1 1 ; 0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 1 0 1 ; 0 0 0 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'ر' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 0 0 1 ; 0 0 0 0 1 ; 0 1 1 1 0 ; 0 0 0 0 0 ; ]),
'ش' => Bool.([0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 0 1 1 ; 0 0 0 0 0 ; 1 0 1 1 1 ; 1 0 1 1 1 ; 1 1 1 0 0 ; 0 0 0 0 0 ; ]),
'ت' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 0 1 1 1 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'ث' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 0 1 1 1 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'خ' => Bool.([0 0 1 0 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; 0 1 1 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'ذ' => Bool.([0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 1 1 1 0 ; 0 0 0 0 0 ; ]),
'ض' => Bool.([0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 0 0 0 ; 0 0 0 1 0 ; 1 0 1 0 1 ; 1 1 1 1 1 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'ظ' => Bool.([0 0 0 0 0 ; 0 1 0 0 0 ; 0 1 0 1 0 ; 0 1 0 0 0 ; 0 1 1 1 0 ; 0 1 0 0 1 ; 1 1 1 1 1 ; 0 0 0 0 0 ; ]),
'غ' => Bool.([0 1 0 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 1 0 0 0 0 ; 0 1 1 0 0 ; 1 0 0 0 0 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]));
end #module
