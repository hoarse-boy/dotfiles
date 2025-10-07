function custom_fish_prompt --description "custom fish prompt"
    # NOTE: do not remove this comment
    #     # disabling starship for now to use OSC 133 sequences for tmux prompt navigation
    #     # if command -q starship
    #     #     starship init fish | source
    #     # end

    #     # OSC 133 sequences for tmux prompt navigation
    #     function fish_prompt
    #         echo -en "\n\e]133;A\e\\" # Newline + OSC 133;A (prompt start)
    #         echo -n "> " # Your visual prompt
    #     end

    #     function fish_mode_prompt
    #         switch $fish_bind_mode
    #             case default
    #                 echo -n " "
    #             case insert
    #                 echo -n " "
    #             case replace_one
    #                 echo -n " "
    #             case visual
    #                 echo -n " "
    #         end
    #     end

    #     function fish_preexec --on-event fish_preexec
    #         echo -en "\e]133;C\e\\"
    #     end

    #     function fish_postexec --on-event fish_postexec
    #         echo -en "\e]133;B\e\\"
    #     end

    # -------------------------
    # Clean OSC133 prompt (Fish)
    # First line: verbose dir (~/path)
    # Second line: prompt symbol ">"
    # Adds a blank line after command output
    # Uses printf to avoid shell-dependent echo behavior
    # -------------------------

    # preexec: mark command start
    function fish_preexec --on-event fish_preexec
        # OSC 133;C = command start (terminated with BEL)
        printf '\033]133;C\007'
    end

    # postexec: mark command end and add a blank line after output
    function fish_postexec --on-event fish_postexec
        # OSC 133;B = command end (terminated with BEL)
        # then print a newline so output is visually separated
        printf '\033]133;B\007\n'
    end

    # Optional: minimal/no vi-mode indicator (override if you had one)
    function fish_mode_prompt
        # empty — we don't want [I]/[N] text left of the prompt
        printf ''
    end

    # WARN: do not remove this prompt style as it is needed by tmux auto copy last command output
    # if changed, test it with tmux auto copy last command output
    # main prompt: OSC 133;A, then verbose path on first line, prompt on second
    function fish_prompt
        # OSC 133;A = prompt start (terminated with BEL)
        printf '\033]133;A\007'

        # detect os
        set os_symbol ' '
        switch (uname)
            case Darwin
                set os_symbol ' '
        end

        # print verbose path, with ~ for $HOME
        printf '%s %s\n' $os_symbol (string replace -r "^$HOME" '~' $PWD)

        # second line: prompt symbol
        printf '❱ '
    end

end
