function dedupe_path --description 'Remove duplicate paths from $PATH'
    set -l unique_path
    for p in $PATH
        if not contains $p $unique_path
            set unique_path $unique_path $p
        end
    end
    set -x PATH $unique_path
end
