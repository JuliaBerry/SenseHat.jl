using Test
using SenseHat

@test -40 <= temperature() <= 60
@test 0 <= humidity() <= 100
@test 900 <= pressure() <= 1200
