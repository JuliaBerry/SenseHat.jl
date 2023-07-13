"""
    ioctl(f, request, arg)

A wrapper around the unix `ioctl` function:

- `f` should be either a file descriptor (a `Cint`), an `IOStream` or a `File` object

- `request` is a request code

- `arg` is either an integer (which will be passed as a `Cint`), or a buffer (which will
  be passed as a `Ptr{nothing}`).

Will throw a `SystemError` if an error occurs. Otherwise returns a `Cint` (which is
typically, though not always, 0).

"""
function ioctl end


function ioctl(fd::Cint, request::Integer, arg::Integer)
    ret = ccall(:ioctl, Cint, (Cint, Culong, Cint...), fd, request, arg)
    if ret < 0
        throw(SystemError("ioctl error"))
    end
    return ret
end
function ioctl(fd::Cint, request::Integer, arg)
    ret = ccall(:ioctl, Cint, (Cint, Culong, Ptr{Cvoid}...), fd, request, arg)
    if ret < 0
        throw(SystemError("ioctl error"))
    end
    return ret
end

ioctl(f::Union{Base.Filesystem.File, IOStream}, request::Integer, arg) =
    ioctl(Cint(fd(f)), request, arg)
    
