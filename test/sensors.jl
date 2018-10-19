using Test
using SenseHat

@test -40 <= temperature() <= 60
@test 0 <= humidity() <= 100
@test 950 <= pressure() <= 1100
