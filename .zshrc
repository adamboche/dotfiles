# Use a simple prompt for emacs TRAMP.
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='% ' && return


umask 027

# Let me type a ! in a filename without escaping it
set +o histexpand

# hooks
autoload -U add-zsh-hook

# Automatically show directory contents when changing directory.
add-zsh-hook -Uz chpwd (){
    if type exa &> /dev/null; then
        exa -a
    else
        ls -a
    fi
}

# Make ctrl-backspace delete a whole word
bindkey '^H' backward-kill-word

# A word is only alphanumeric.
autoload -U select-word-style
select-word-style bash

# Append commands to history immediately so that they show up in new shells
setopt inc_append_history

# Ignore "# comments" typed or pasted into an interactive shell
setopt interactivecomments

# Quote URIs.
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# Setup bracketed paste.
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# Use cd stack.
setopt autopushd
alias po='popd'

# IGNOREEOF forces the user to type exit or logout, instead of just pressing ^D.
# setopt IGNOREEOF

# https://github.com/ohmyzsh/ohmyzsh/issues/5108
# Break movement on path separator slash.
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'


# zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
# zstyle ':completion:*' list-colors \'\'
# zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
# zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
# zstyle ':completion:*' format 'Completing %d'
# zstyle ':completion:*' group-name \'\'
# zstyle ':completion:*' menu select=2
# zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' matcher-list "" 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select

# Give a preview of commandline arguments when completing `kill`.
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap

# Give a preview of directory by exa when completing cd.
zstyle ':fzf-tab:complete:cd:*' extra-opts --preview=$extract'exa -1 --color=always ${~ctxt[hpre]}$in'

# Don't exclude dotfiles when tab-completing
_comp_options+=(globdots)



# Don't exclude dotfiles when tab-completing
_comp_options+=(globdots)




# https://github.com/zsh-users/zsh-autosuggestions#configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=6
# "Chooses the most recent match whose preceding history item matches the most
# recently executed command (more info). Note that this strategy won't work as
# expected with ZSH options that don't preserve the history order such as
# HIST_IGNORE_ALL_DUPS or HIST_EXPIRE_DUPS_FIRST"
# ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd

# Set history file location.
HISTFILE=~/.local/share/zsh/zsh_history
# Set history size.
HISTSIZE=1000000
SAVEHIST=1000000


# C-x C-e to open editor
autoload -U edit-command-line

zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
beginning-of-buffer() { RBUFFER=$BUFFER ; LBUFFER= }
end-of-buffer() { LBUFFER=$BUFFER ; RBUFFER= }
zle -N beginning-of-buffer
zle -N end-of-buffer
bindkey '^[<' beginning-of-buffer
bindkey '^[>' end-of-buffer
bindkey '^[{' up-history
bindkey '^[}' down-history

# C-, to repeat previous word.
autoload copy-earlier-word
zle -N copy-earlier-word
bindkey '^[,' copy-earlier-word


# Disable time builtin.
disable -r time

# Set timezone for git in shell.
git(){ TZ=UTC command git "$@"; }


fast-cat() {
    echo -E "$(< $1)"
}

print-git-branch() {
    if [[ -f ".git/HEAD" ]]; then
      	echo -E ":${$(fast-cat .git/HEAD)#ref: refs/heads/}"
    fi
}

colors=(
    29
    30  31  32  33  34  35  36  37  38  39
    40  41  42  43  44  45  46  47  48  49
    50  51
    62  63  64  65  66  67  68  69
    70  71  72  73  74  75  76  77  78  79
    80  81  82  83  84  85  86  87
    99
    105 106 107 108 109
    110 111 112 113 114 115 116 117 118 119
    120 121 122 123                     129
    130 131 132 133 134 135 136 137 138 139
    140 141 142 143 144 145 146 147 148 149
    150 151 152 153 154 155 156 157 158 159
    165 166 167 168 169
    170 171 172 173 174 175 176 177 178 179
    180 181 182 183 184 185 186 187 188 189
    190 191 192 193 194 195 196 197 198 199
    200 201 202 203 204 205 206 207 208 209
    210 211 212 213 214 215 216 217 218 219
    220 221 222 223 224 225 226 227 228 229
    230 231
)


string_to_color() {
    checksum_and_size="$(cksum  <<< "$1" )"
    checksum="$(cut  --delimiter=' ' --fields=1 <<< "$checksum_and_size")"
    remainder="$((checksum % ${#colors[@]}))"
    color="$(tput setaf "${colors[remainder]}")"
    printf  '%s' "$color"
}


bold="$(tput bold)"
reset_color="$(tput sgr0)"
user_color="$(string_to_color "$USER")"
host_color="$(string_to_color "$(hostname)")"
dir_color="$(tput setaf 6)"

red="$(tput setaf 1)"
green="$(tput setaf 2)"
# If previous status was 0 then green else red.
prompt_symbol_color="%(?.%{$green%}.%{$red%})"

setopt promptsubst # needed for \$ evaluation
PS1='%{$user_color%}%n%{$reset_color%}%{$bold%}@%{$reset_color%}%{$host_color%}%m:%{$dir_color%}%2~%{$reset_color%}%{$bold%}$(print-git-branch)%{$reset_color%}:%{$RANGER_SESSION%}%{$bold_color%}%{$prompt_symbol_color%}%%%{$reset_color%} '


# Ensure comments are readable on dark background.
# Otherwise they are dark-on-dark.
# https://github.com/zsh-users/zsh-syntax-highlighting/issues/510
ZSH_HIGHLIGHT_STYLES[comment]='none'



# Aliases
alias gti='git'
alias ipy='ipython'
alias myip='curl ipinfo.io/ip'
alias o='xdg-open'
alias pti='ptipython'
alias pydoc='python3 -m pydoc'
alias ra='ranger'
alias rd='source ranger'
alias u='cd ../'
alias userctl='systemctl --user'
alias uu='cd ../../'
alias uuu='cd ../../../'
alias uuuu='cd ../../../../'
