function deactivate
    # Reset the prompt
    functions -e fish_prompt
    functions -c _old_fish_prompt fish_prompt

    # Remove environment variables
    set -e VIRTUAL_ENV
    set -e _old_fish_prompt
    set -e _old_path

    # Restore PATH
    set PATH $PATH[1..$_old_path_count]

    # Restore fish_title
    functions -e fish_title
    functions -c _old_fish_title fish_title
    set -e _old_fish_title
end

set -g VIRTUAL_ENV (pwd)

# Save old prompt and set new one
functions -c fish_prompt _old_fish_prompt
function fish_prompt
    echo -n (basename $VIRTUAL_ENV) ' '
    _old_fish_prompt
end

# Save old PATH
set -g _old_path $PATH
set -g _old_path_count (count $PATH)

# Add the virtual environment's bin directory to PATH
set PATH $VIRTUAL_ENV/bin $PATH

# Save old fish_title and set new one
functions -c fish_title _old_fish_title
function fish_title
    echo (basename $VIRTUAL_ENV) $argv
end

