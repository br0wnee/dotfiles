# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

#export PATH="$HOME/CLion/bin:$VULKAN_SDK/bin:$PATH"


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="alanpeabody" # set by `omz`

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


#Function to add things to PATH
add_to_path() {
    if [ -d "$1" ]; then
        if [[ ":$PATH:" != *":$1:"* ]]; then
            export PATH="$1:$PATH"
            # echo "Added $1 to PATH"
        # else
            # echo "$1 is already in PATH"
        fi
    else
        echo "Directory $1 does not exist"
    fi
}

#Function to remove things from PATH
remove_from_path() {
    if [[ ":$PATH:" == *":$1:"* ]]; then
        export PATH=$(echo "$PATH" | awk -v RS=: -v ORS=: '$0 != "'"$1"'"' | sed 's/:$//')
        echo "Removed $1 from PATH"
    else
        echo "$1 is not in PATH"
    fi
}


# ranger() {
# 	local IFS=$'\t\n'
# 	local tempfile="$(mktemp -t tmp.XXXXXX)"
# 	local ranger_cmd=(
# 		command
# 		ranger
# 		--cmd="map Q chain shell echo %d > "$tempfile"; quitall"
# 	)
	
# 	${ranger_cmd[@]} "$@"
# 	if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
# 		cd -- "$(cat "$tempfile")" || return
# 	fi
# 	command rm -f -- "$tempfile" 2>/dev/null
# }

#Change zcompdump dir
export ZDOTDIR=/home/bartek/.config/zsh

#Set the editor
export EDITOR=hx

# Custom smth?
eval "$(zoxide init zsh)"
source $ZSH_CUSTOM/key-bindings.zsh


# Custom aliases

alias "ls=eza --tree --level=1"
alias cd=z
alias "codium=codium --ozone-platform-hint=wayland"
alias config='/usr/bin/git --git-dir=/home/bartek/.cfg/ --work-tree=/home/bartek'
alias ncspot='flatpak run io.github.hrkfdn.ncspot'
alias prime-run='__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia'
alias gpu-temp='nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader'
alias mpv-term='mpv --profile=sw-fast --vo=kitty --vo-kitty-use-shm=yes'

#Custom paths
#add_to_path "$HOME/Clion/bin"
#add_to_path "$HOME/raylib"
add_to_path /home/bartek/.cargo/bin
add_to_path /home/bartek/.zig
add_to_path /home/bartek/.marksman
add_to_path /home/bartek/.yazi
add_to_path /home/bartek/.swing
add_to_path /home/bartek/.zls
add_to_path /home/bartek/.presenterm
add_to_path /home/bartek/.tdf/release
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

