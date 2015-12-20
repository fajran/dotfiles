#
# Colors - source: https://wiki.archlinux.org/index.php/Color_Bash_Prompt
#

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

OS=`uname -s`

Clock=$'\xe2\x8c\x9a'
Error="${BIRed}\xe2\x98\xa2"
Branch=$'\xe2\x8c\xa5 '
BackgroundJob=$"\xe2\x99\xa8"

if [ "$OS" = "Darwin" ]; then
  Clock="🕙 "
  Error="❌ "
  Branch="🌵 "
  BackgroundJob="☕️ "
fi

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
if [ "$OS" = "Darwin" ]; then
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
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e $"s/* \(.*\)/ (git) ${Branch} \\1/"
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

__CHROOT_PS1=
if [ -r /etc/debian_chroot ]; then
  __CHROOT_NAME=$(cat /etc/debian_chroot)
  __CHROOT_PS1=$'\xe2\x8a\xa2${__CHROOT_NAME}\xe2\x8a\xa3 '
fi

__check_error_ps1() {
  ERR=$1
  if [ $ERR -ne "0" ]; then
    echo -e " $Error $ERR"
  fi
}

__check_jobs_ps1() {
  RUNNING=$(jobs -r | wc -l | xargs echo)
  STOPPED=$(jobs -s | wc -l | xargs echo)
  if [ $RUNNING -gt 0 -o $STOPPED -gt 0 ]; then
    echo -e " ${IWhite}${BackgroundJob} ${IGreen}$RUNNING${IBlack}+${IYellow}$STOPPED"
  fi
}

export PS1=$"\n${IBlack}\d ${Clock} \t\$(__check_error_ps1 \$?)\$(__check_jobs_ps1)${Color_Off}\$(__git_ps1)\n${__SSH_PS1}${__SCREEN_PS1}${__CHROOT_PS1}${C1}\u@\h ${C2}\w${Color_Off}\n$ "

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

