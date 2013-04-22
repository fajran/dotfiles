#
# Colors - source: https://wiki.archlinux.org/index.php/Color_Bash_Prompt
#

# Reset
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Underline
UBlack='\e[4;30m'       # Black
URed='\e[4;31m'         # Red
UGreen='\e[4;32m'       # Green
UYellow='\e[4;33m'      # Yellow
UBlue='\e[4;34m'        # Blue
UPurple='\e[4;35m'      # Purple
UCyan='\e[4;36m'        # Cyan
UWhite='\e[4;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

# High Intensity
IBlack='\e[0;90m'       # Black
IRed='\e[0;91m'         # Red
IGreen='\e[0;92m'       # Green
IYellow='\e[0;93m'      # Yellow
IBlue='\e[0;94m'        # Blue
IPurple='\e[0;95m'      # Purple
ICyan='\e[0;96m'        # Cyan
IWhite='\e[0;97m'       # White

# Bold High Intensity
BIBlack='\e[1;90m'      # Black
BIRed='\e[1;91m'        # Red
BIGreen='\e[1;92m'      # Green
BIYellow='\e[1;93m'     # Yellow
BIBlue='\e[1;94m'       # Blue
BIPurple='\e[1;95m'     # Purple
BICyan='\e[1;96m'       # Cyan
BIWhite='\e[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\e[0;100m'   # Black
On_IRed='\e[0;101m'     # Red
On_IGreen='\e[0;102m'   # Green
On_IYellow='\e[0;103m'  # Yellow
On_IBlue='\e[0;104m'    # Blue
On_IPurple='\e[0;105m'  # Purple
On_ICyan='\e[0;106m'    # Cyan
On_IWhite='\e[0;107m'   # White


#
# Common functions
#
__contains() {
  local e
  for e in "${@:2}"
  do
    [[ "$e" == "$1" ]] && return 0
  done
  return 1
}

#
# Colorize output
#
if [ `uname -s` = "Darwin" ]; then
    alias ls="ls -G"
else
    alias ls="ls --color=auto"
fi
alias grep="grep --color=auto"

alias sl=ls   # frequent typo


#
# Git
#
alias gk="gitk --all &"

__git_ps1() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (git) \xe2\x8c\xa5 \1/'
}


#
# PS1
#
HOSTNAME=`hostname -s`
C1=$Green
C2=$Yellow
if __contains $HOSTNAME egg cruz; then
  C1=$Red
  C2=$Blue
fi
if __contains $HOSTNAME sangkil mangkus; then
  C1=$Cyan
  C2=$Yellow
fi

__SSH_PS1=
if [ -n "$SSH_CLIENT" -o -n "$SSH_CONNECTION" -o -n "$SSH_TTY" ]; then
  __SSH_PS1="(ssh) "
fi

__SCREEN_PS1=
if [ ! -z "$STY" ]; then
  __SCREEN_PS1="(screen) "
fi

__check_error_ps1() {
  ERR=$1
  if [ $ERR -ne "0" ]; then
    echo -e " ${BIRed}Error: $ERR"
  fi
}

Clock=$'\xe2\x8c\x9a'
export PS1=$"\n${IBlack}\d ${Clock} \t\$(__check_error_ps1 \$?)${Color_Off}\$(__git_ps1)\n${__SSH_PS1}${__SCREEN_PS1}${C1}\u@\h ${C2}\w${Color_Off}\n$ "


#
# Misc
#

complete -cf sudo

if [ $TERM != "xterm-256color" ]; then
  if [ "$COLORTERM" = "gnome-terminal" ]; then
    export TERM=xterm-256color
  fi
fi

if which xdg-open > /dev/null 2>&1 ; then
  alias open=xdg-open
fi

alias tsmtp="ssh egg -L2525:localhost:25"

alias ADD_LIB_PATH="export LD_LIBRARY_PATH=\$PWD:\$LD_LIBRARY_PATH"
alias ADD_PY_PATH="export PYTHONPATH=\$PWD:\$PYTHONPATH"
alias ADD_PATH="export PATH=\$PWD:\$PATH"

OS=`uname -s`
if [ $OS == "Darwin" ]; then
  export PATH=$HOME/mac/bin:$PATH
fi
if [ $OS == "Linux" ]; then
  export PATH=$HOME/linux/bin:$PATH
fi

#
# Local
#

[ -f $HOME/.bashrc.local ] && source $HOME/.bashrc.local

