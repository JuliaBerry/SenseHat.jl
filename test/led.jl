using SenseHat
using Base.Test

using ColorTypes

const LED = led_matrix()

LED[:] = SenseHat.JULIA_LOGO
sleep(3)
led_clear()
