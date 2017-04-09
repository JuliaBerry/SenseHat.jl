module Stick

export StickEvent, StickEventTask

function _stick_input_device()
    try
        for devname in readdir("/sys/class/input")
            sysfname = joinpath("/sys/class/input",devname,"device","name")
            if startswith(devname, "event") && isfile(sysfname)
                if startswith(readstring(sysfname),"Raspberry Pi Sense HAT Joystick")
                    return joinpath("/dev/input",devname)
                end
            end
        end
    catch e
    end
    error("Sense Hat not found.")
end

const STICK_INPUT_DEVICE = _stick_input_device()

const EV_KEY = Cushort(0x01)

@enum Direc UP=103 LEFT=105 RIGHT=106 DOWN=108 MIDDLE=28
@enum State RELEASE=0 PRESS=1 HOLD=2


"""
    StickEventRaw

The raw data format from the input device. This is based on the struct specification from https://github.com/RPi-Distro/python-sense-hat/blob/ec8c96118d5eb58488c4ff6091cd373117e6ce08/sense_hat/stick.py#L41.
"""
immutable StickEventRaw
    tv_sec::Clong
    tv_usec::Clong
    ev_type::Cushort
    ev_direc::Cushort
    ev_state::Cuint
end
Base.read(io::IO, ::Type{StickEventRaw}) = read(io, Ref{StickEventRaw}())[]


"""
    StickEvent(timestamp::DateTime, direc::Direc, state::State)

The data from a joystick event. The type contains the following fields:

* `timestamp` : `DateTime` of when the event occurred.

* `direc` : the direcion of the event, either `UP`, `DOWN`, `LEFT`, `RIGHT`, `MIDDLE` (`MIDDLE`
  occurs when the button is pressed down).

* `state` : the state of the event (`PRESS`, `RELEASE`, `HOLD`).

"""
immutable StickEvent
    timestamp::DateTime
    direc::Direc
    state::State
end

Base.convert(::Type{StickEvent}, r::StickEventRaw) =
    StickEvent(Dates.unix2datetime(r.tv_sec + r.tv_usec/1_000_000),
               Direc(r.ev_direc), State(r.ev_state))

"""
    readstick()

This reads a single `StickEvent` from the joystick on the Sense HAT. This will block until an event occurs.

See also `sticktask()` which may be better for reading in a loop.
"""
function readstick()
    open(STICK_INPUT_DEVICE) do dev
        fddev = RawFD(fd(dev))
        while true
            wait(fddev, readable=true)
            s = read(dev, StickEventRaw)
            if s.ev_type == EV_KEY
                return StickEvent(s)
            end
        end
    end
end

"""
    sticktask()

This is a `Task` that produces `StickEvent`s when the joystick on the Sense HAT is
manipulated. It will block until new `StickEvent`s occur.

A typical usage will be to create a new task which will call this asynchronously, e.g. the
following will call the function `f(::StickEvent)` for each event:

```
@schedule for e in sticktask()
    f(e)
end
```

"""
function sticktask()
    @task open(STICK_INPUT_DEVICE) do dev
        fddev = RawFD(fd(dev))
        while true
            wait(fddev, readable=true)
            s = read(dev, StickEventRaw)
            if s.ev_type == EV_KEY
                produce(StickEvent(s))
            end
        end
    end
end


end # module
