function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s dupa> ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting

end

starship init fish | source

set LV2_PATH ~/.lv2
set LC_ALL "C.UTF-8"

set -Ux fish_user_paths ~/go/bin

fish_add_path ~/.local/bin

alias pamcan pacman
alias ls 'eza --icons'
alias clear "printf '\033[2J\033[3J\033[1;1H'"
alias q 'qs -c ii'
alias hx helix

# function fish_prompt
#   set_color cyan; echo (pwd)
#   set_color green; echo '> '
# end
