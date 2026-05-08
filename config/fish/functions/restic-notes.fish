function restic-notes
    set -lx RESTIC_REPOSITORY "rclone:gdrive:backups/jho-notes"
    set -lx RESTIC_PASSWORD_FILE ~/.config/restic/pass
    restic $argv
end
