# Luke's config for the Zoomer Shell

# Enable colors and change prompt:
# fortune | cowsay
# $HOME/scripts/simple-unix
autoload -U colors && colors
# PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
# PS1="%B%{$fg[green]%}%n%{$fg[green]%}@%{$fg[green]%}%M%{$fg[white]%}:%{$fg[blue]%}%~%{$reset_color%}$%b "
# PS1="%B%{$fg[green]%}%n%{$fg[green]%}: %{$fg[blue]%}%~%{$reset_color%}$%b "
PS1='%~: '
PS1="%B%F{160%}%~%{$reset_color%}:%b "
# History in cache directory:
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=$HOME/.zhistory
MYVIMRC=$HOME/.config/nvim/init.vim
export EDITOR=nvim
export FZF_DEFAULT_COMMAND="fd -H"

# Basic auto/tab complete:
autoload -U compinit && compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'


# export MANPAGER='/bin/bash -c "\vim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"</dev/tty <(col -b)"'

export MANPAGER="nvim +Man!"
# Set nvim as manpager
# export MANPAGER="nvim -c 'set ft=man' -"


# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

alias history="history 1"
# Load aliases and shortcuts if existent.
# [ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

# Load zsh-syntax-highlighting; should be last.
# neofetch
setxkbmap -option ctrl:nocaps
xcape -e 'Control_L=Escape'

# Set repeated keystroke rate.
# 300: delay (ms) before first repeat
# 50: following first repeat, # of repeats per second
xset r rate 300 50

fpath=(~/zsh-completions/src $fpath)

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null 

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
