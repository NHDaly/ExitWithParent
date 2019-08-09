module ExitWithParent

export exit_with_parent!

"""
    exit_with_parent!(p::Base.Process, signal = 2)

When this julia process exits, the provided process `p` will be killed with `signal`.

This spawns a child process that simply polls until the parent is killed, and then kills `p`.
"""
function exit_with_parent! end
if Sys.isunix()
    function exit_with_parent!(p::Base.Process, signal = 2)  # SIGINT (ctrl-c)
        targetpid = getpid(p)
        orig_parent = getpid()
        open(`$(Base.julia_cmd()) -e "
            while true
                ppid = ccall(:getppid, Cint, ())
                sleep(1)
                if ppid != $orig_parent
                    ccall(:kill, Cint, (Cint,Cint), $targetpid, $signal)
                    exit()
                end
            end
        "`);
        nothing
    end
else
    # TODO: What should this do for other systems?
    function exit_with_parent!(p::Base.Process, signal = 2) end # SIGINT (ctrl-c)
end

end # module
