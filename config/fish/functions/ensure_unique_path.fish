function ensure_unique_path --description "Ensure fish_user_paths doesn't have duplicates"
    set -l unique_paths
    for p in $fish_user_paths
        if not contains $p $unique_paths
            set unique_paths $unique_paths $p
        end
    end
    set -U fish_user_paths $unique_paths
end
