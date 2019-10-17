# ## Environmental sensors with the SenseHat
# ### Reads and displays temperature, humidity and pressure.

using SenseHat

# Create channel to store stick events
c = Channel{StickEvent}(32)
@async while true
   # Push every event into the channel
   put!(c, readstick())
end

while true
   # Retrieve events from channel
    ev = take!(c)
    if ev.direc == SenseHat.Stick.MIDDLE && ev.state == SenseHat.Stick.PRESS
      # Flash the Julia logo on the display
      LED[:] = SenseHat.JULIA_LOGO; sleep(1); led_clear()
      # Display atmospheric pressure
      show_message(string("P R E S S U R E:", round(Int, pressure()), "mb"), 0.08, colorant"purple")
      # Display temperature
      show_message(string("T E M P E R A T U R E:", round(Int, temperature()), "C"), 0.08, colorant"red")
      # Display humidity
      show_message(string("H U M I D I T Y:", round(Int, humidity()), "%"), 0.08, colorant"blue")
    end
end
