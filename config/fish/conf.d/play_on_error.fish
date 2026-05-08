function play_on_error --on-event fish_postexec
    if test $status -ne 0
        # play instantly with no lag. can run 'exit' immediately after this.
        paplay ~/.config/fish/sounds/assets_fahhh.wav &
        disown
    end
end
