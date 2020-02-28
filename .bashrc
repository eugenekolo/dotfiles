# ~/.bashrc: executed by bash(1) for non-login shells.

case $- in
    *i*) ;;
      *) return;;
esac

case "$(uname -s)" in
  Darwin)
    machine=MACOS;;
  Linux)
    machine=LINUX;;
  CYGWIN*|MINGW32*|MSYS*|MINGW*)
    machine=WINDOWS;;
  *)
    machine=OTHER;;
esac

BGREEN='\[\033[1;32m\]'
DGREEN='\[\033[0;32m\]'
BRED='\[\033[1;31m\]'
RED='\[\033[0;31m\]'
BBLUE='\[\033[1;36m\]'
BLUE='\[\033[0;34m\]'
NORMAL='\[\033[00m\]'
BPURPLE='\[\033[1;35m\]'
DPURPLE='\[\033[1;34m\]'
WHITE='\[\033[0;37m\]'
BWHITE='\[\033[1;37m\]'

# Bash terminal config
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000000
HISTFILESIZE=2000000
shopt -s checkwinsize

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

PS1="${debian_chroot:+($debian_chroot)}${BGREEN}\u${BWHITE}:${DPURPLE}\w ${BWHITE}\$${DPURPLE}${NORMAL} "
#PS1="$ ${BGREEN}demo${NORMAL} > " # for demos

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

function extract () {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)  tar -jxvf $1                        ;;
            *.tar.gz)   tar -zxvf $1                        ;;
            *.bz2)      bunzip2 $1                          ;;
            *.dmg)      hdiutil mount $1                    ;;
            *.gz)       gunzip $1                           ;;
            *.rar)      unrar x $1                          ;;
            *.tar)      tar -xvf $1                         ;;
            *.tbz2)     tar -jxvf $1                        ;;
            *.tgz)      tar -zxvf $1                        ;;
            *.zip)      unzip $1                            ;;
            *.ZIP)      unzip $1                            ;;
            *.pax)      cat $1 | pax -r                     ;;
            *.pax.Z)    uncompress $1 --stdout | pax -r     ;;
            *.Z)        uncompress $1                       ;;
            *)          echo "'$1' cannot be extracted/mounted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

function b64d () {
  echo "$1" | base64 -d
}

function b64e () {
  echo "$1" | base64
}

function dockerbash () {
    if [ -z $1 ]; then
        echo "You need to specify the name of the container you want to get into like:"
        echo "$ dockerbash mycontainer"
    else
        pid=`docker ps | grep $1 | awk '{print $1}'`
        docker exec -it $pid /bin/bash
    fi
}

function iadb() {
   if [[ $1 == "shell" ]]; then
      ssh root@localhost -p 2222
   elif [[ $1 == "pull" ]]; then
      if [ -n "$3" ]; then
         scp -P2222 root@localhost:"$2" "$3"
      else
         scp -P2222 root@localhost:"$2" .
      fi
   elif [[ $1 == "push" ]]; then
      scp -P2222 "$2" root@localhost:"$3"
   else
      echo "iadb (iphone adb) command not found"
   fi
}

function tre() {
    tree -aC -I '.git' --dirsfirst "$@" | less -FRNX
}


if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
fi

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias gs="git status"
alias gd="git diff"
alias gc="git commit -m"
alias ga="git add"
alias gpom="git push origin master"
alias gitdiff="git diff"
alias grc="git rebase --continue"
alias git-submodule-update="git submodule update --recursive --remote"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias update="sudo apt-get update && sudo apt-get upgrade"
alias wgetclone="wget --no-clobber --convert-links --random-wait -r -p -E -e robots=off -U mozilla"
alias myscp="rsync --progress --partial"
alias traceroute="mtr "
alias myip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d\   -f2"
alias pls="ls --group-directories-first"
alias delpyc="find . -name '*.pyc' -delete; find . -type d -name '__pycache__' -exec rm -rf {} +"
alias py2='python2'
alias py3='python3'
alias ccopy='xclip -selection clipboard'  # pipe into ccopy --> clipboard
alias cpaste='xclip -selection clipboard -o'  # paste with cpaste

export LS_COLORS="$LS_COLORS:*.md=00;36:*.MD=00;36:*.txt=00;36:*.TXT=00;36"

export PATH="$HOME/.local/bin:$PATH"  # Stuff likes installing here
export PATH="/opt/bin:$PATH"  # Sometimes I put stuff here

# TODO(eugenek): Need to generalize these
# Android + Java exports
# export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
#export PATH="/opt/Android/platform-tools:$PATH"
#export PATH="/opt/Android/build-tools/29.0.1:$PATH"  
#export ANDROID_NDK_ROOT="/opt/android-ndk-r20"  # add ndk
#export ANDROID_SDK_ROOT="/opt/Android/Sdk"  # add sdk

#export PATH="$HOME/.rbenv/bin:$PATH"  # Add rbenv
#eval "$(rbenv init -)"
#export PATH="$PATH:/opt/dex2jar"
#export PATH="/opt/jadx/bin:$PATH"  # jadx
#export PATH="/opt/jd-gui:$PATH"  # jdgui
#export PATH="/opt/google/chrome:$PATH"  # chrome
#export PATH="/opt/cydia-impactor:$PATH"  # cydia-impactor
#export PATH="/home/eugenek/code/ida:$PATH"  # ida
#export PATH="/home/eugenek/code/ida/idasdk73/bin:$PATH"  # idadk73
#export PATH="/opt/Postman:$PATH"  # Postman

# export PATH="$PATH:/usr/lib/gcc/x86_64-linux-gnu/5"  # Add gcc5





