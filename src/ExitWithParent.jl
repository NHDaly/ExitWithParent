module ExitWithParent

export exit_with_parent!

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
    end
else
    # TODO: What should this do for other systems?
    function exit_with_parent!(p::Base.Process, signal = 2) end # SIGINT (ctrl-c)
end

end # module
