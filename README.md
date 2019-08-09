# ExitWithParent.jl

`exit_with_parent!(p::Base.Process, signal = 2)`

When the current julia process exits, the provided process `p` will be killed with `signal`.

(The function spawns a child process that simply polls until the parent is killed, and then kills `p`.)


```julia
julia> p = open(`...`)
Process(`...`, ProcessRunning)

julia> using ExitWithParent

julia> exit_with_parent!(p)  # now when you exit() julia, p will be killed.
```


