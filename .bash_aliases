#!/bin/bash


# safety
#alias rm="echo Use 'del', or the full path i.e. '/bin/rm'"


# ssh into tmux session
st ()  { ssh "$1" -t tmux new-session -A -s 0 ; stty sane ; }


# https://github.com/lf94/peek-for-tmux
peek() { tmux split-window -p 33 "$EDITOR" "$@" || exit; }

# check if command exists
cmdexists() { command -v "$1" >/dev/null 2>&1 ; }

# make sshfs
mksshfs() {
    if [[ -d "$1" ]] ; then
	mkdir "$1"
    fi
    sshfs -o follow_symlinks "${1}:" "$1"
}

# Python calculator
pycalc() {
    python3 -c "from math import *; from fractions import Fraction; print(${1})"
}


# Python
alias pdcsv='ipd -i -c "import sys; df = pd.read_csv(sys.argv[-1])"'
pyve () { source venv/bin/activate ; }
venvbin () {
    which "$1" | xargs realpath | xargs dirname
}


colors256() {
	local c i j

	printf "Standard 16 colors\n"
	for ((c = 0; c < 17; c++)); do
		printf "|%s%3d%s" "$(tput setaf "$c")" "$c" "$(tput sgr0)"
	done
	printf "|\n\n"

	printf "Colors 16 to 231 for 256 colors\n"
	for ((c = 16, i = j = 0; c < 232; c++, i++)); do
		printf "|"
		((i > 5 && (i = 0, ++j))) && printf " |"
		((j > 5 && (j = 0, 1)))   && printf "\b \n|"
		printf "%s%3d%s" "$(tput setaf "$c")" "$c" "$(tput sgr0)"
	done
	printf "|\n\n"

	printf "Greyscale 232 to 255 for 256 colors\n"
	for ((; c < 256; c++)); do
		printf "|%s%3d%s" "$(tput setaf "$c")" "$c" "$(tput sgr0)"
	done
	printf "|\n"
}


# Transform a file in place.
sponge() ( tmp=$(mktemp) && cat > "$tmp"  && cat -- "$tmp" > "$1" && rm -- "$tmp"; )


# Color stderr
# color()(set -o pipefail;"$@" 2>&1>&3|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1

rewrite () {
    from="$1"
    to="$2"

    # git ls-files -z | xargs -0 ex -sc "%s/$from/$to/|wq"

    # Some ``sed -i`` implementations don't follow links, and break hardlinks.
    git ls-files -z | xargs -0 sed -i s/"$from"/"$to"/g
}


pyg () {
    pygmentize -O full,style=monokai "$@"
}



jqt(){

    file="$1"
    jq -rc paths "$file" | IGNOREEOF=9999999 fzf --bind ctrl-d:delete-char --preview 'x={}; jq -C "getpath($x)" '"$file"
}


fp() {
    fzf --preview 'less {}'
}



unzipd () {
    # Unzip into a directory of the same name
    zipfile="$1"
    zipdir=${1%.zip}
    unzip -d "$zipdir" "$zipfile"
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
