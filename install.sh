#! /bin/bash -
################################################################
# File Name: install.sh
# Author: wh01am
# Mail: wh0197m@gmail.com
# Created Time: Web 16 May 2018 03:46:23 PM CST
# Usage: sh install.sh
# Description: install punk's requirements
# Attention: punk help u be efficient
################################################################

# --- Basic Syntax ---
# File test
# -z string: if string was empty (z means zero)
# -n string: if string was not empty
# -e FILE: if FILE exist
# -f FILE: if FILE was normal file
# -d FILE: if FILE was directory
# -r FILE: if FILE was readable
# -W FILE: if FILE was writeable
# -x FILE: if FILE was editable

# --- Colors ---

RED="\033[1;31m"
CYAN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
PURPLE="\033[1;35m"
GREEN="\033[1;36m"
WHITE="\033[1;37m"

RED_BG="\033[41;37m"
CYAN_BG="\0322[32;37m"
YELLOW_BG="\033[43;37m"
BLUE_BG="\033[44;37m"
PURPLE_BG="\033[45;37m"
GREEN_BG="\033[46;37m"
WHITE_BG="\033[47;30m"

# Purple With Yellow & Green With RED
PWY="\033[45;33m"
GWR="\033[46;31m"
CEND="\033[0m"

# ----------------------------------- Utils -----------------------------------

# recover the cursor
trap ctrl_c INT

# tput clear # clear screen
# tput sc # save cursor position
# tput cup 10 13 # move cursor to row col
# tput civis # cursor hidden
# tput cnorm # cursor visible
# tput rc # show output
ctrl_c() {
	tput cnorm
	exit
}

# Show Banner
banner() {
	printf "${CYAN}┌------------------- <Ghost in the Shell>-------------------┐\n"
	printf "|                                                           |\n"
	printf "${CYAN}|${PWY}   ______      __              ${GWR}     ____              __   ${CEND}${CYAN}|\n"
	printf "${CYAN}|${PWY}  / ______  __/ /_  ___  _____ ${GWR}    / __ \__  ______  / /__ ${CEND}${CYAN}|\n"
	printf "${CYAN}|${PWY} / /   / / / / __ \/ _ \/ ___/${GWR} ${PWY} ${GWR}  / /_/ / / / / __ \/ //_/ ${CEND}${CYAN}|\n"
	printf "${CYAN}|${PWY}/ /___/ /_/ / /_/ /  __/ /    ${GWR} ${PWY} ${GWR} / ____/ /_/ / / / / ,<    ${CEND}${CYAN}|\n"
	printf "${CYAN}|${PWY}\____/\__, /_.___/\___/_/      ${GWR} /_/    \__,_/_/ /_/_/|_|   ${CEND}${CYAN}|\n"
	printf "${CYAN}|${PWY}     /____/                    ${GWR}                            ${CEND}${CYAN}|\n"
	printf "${CYAN}└-------------------The Greatest Animation------------------┘\n"
}

# Error Messages
os_not_match() {
	printf "😰  ${RED}Sorry, this tool only works on ${CYAN}MacOS ${RED}or ${BLUE}CentOS7${CEND}\n"
	exit 0
}

requirement_not_exist() {
	printf "🙈  ${RED}$1 missing, we will install it for u!${CEND}\n"
}

requirement_exist() {
	printf "✅  ${GREEN}$1 already exists.${CEND}\n"
}

need_install_manually() {
	printf "🚨  ${RED}$1 need install first, plz do it manually.${CEND}\n"
}

# define 0: mac
# define 1: linux
# define 2: others
# -a: and; -o: or; !: anti
# this tool just work for centos7 and macos
check_os() {
	sysOS=`uname -s`
	if [ $sysOS == "Darwin" ];then
		return 0
	elif [ $sysOS == "Linux" ];then
		source /etc/os-release
		if [ $ID == "centos" -a $VERSION_ID == "7" ];then
			return 1
		else
			os_not_match
		fi
	else
		os_not_match
	fi
}

# loading effects when installing
loading() {
	local icon="⚽⚾🎾🏐🏀"
	local i=0
	tput civis # hidden normal cursor
	# kill -0 will send no signal but execute system error check
	# it will return 0 if pid exists
	# it will return 1 if pid not exists
	while kill -0 "$1" 2>/dev/null; do 
		i=$(( (i+1) %4 ))
		printf "\b%s" "${icon:$i:1}"
		sleep 0.05
	done
	tput cnorm
}

# &>file stdout&stderr to file
# 2>&1 stderr to stdout
command_exist() {
	type "$1" &> /dev/null
}

# install different requirements based on system
install_spawn() {
	check_os
	if [ $? -eq 0 ]; then # mac
		if ! command_exist $1; then
			requirement_not_exist "$1"
			sudo brew install "$1" > /dev/null 2>&1 &
			loading $!
			printf "\b✅  ${GREEN}$1 was Installed!${CEND}\n"
		else
			requirement_exist "$1"
		fi
	else # centos
		if ! command_exist $2; then
			requirement_not_exist "$2"
			sudo yum install -y "$2" > /dev/null 2>&1 &
			loading $!
			printf "\b✅  ${GREEN}$2 was Installed!${CEND}\n"
		else
			requirement_exist "$2"
		fi
	fi
}

# verify package manager was installed 
verify_pkm() {
	check_os
	if [ $? -eq 0]; then # mac
		if ! command_exist "brew"; then
			/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		else
			requirement_exist "brew"
		fi
	else
		if ! command_exist "yum"; then
			need_install_manually "yum"
		else
			requirement_exist "yum"
		fi
	fi	
}

# get the answer
get_answer() {
	while true; do
		printf "${BLUE}👉   $1 "

		# default no
		if [[ $2 == "no" ]];then
			printf "[yes | ${GREEN}no${CEND}${BLUE}]${CEND}"
			read ans
			if [[ -z "$ans" ]];then
				ans="no"
			fi
		# default yes
		else
			printf "[${GREEN}yes${CEND} | no${BLUE}]${CEND}"
			read ans
			if [[ -z "$ans" ]];then
				ans="yes"
			fi
		fi

		# 0: yes; 1: no
		if [[ $ans == "yes" ]] || [[ $ans == "y" ]];then
			return 0
		elif [[ $ans == "no" ]] || [[ $ans == "n" ]];then
			return 1
		else
			printf "😭  ${RED}Invalid answer, plz answer with 'yes' or 'no'.${CEND}\n"
		fi
	done
}

# asking
# asking CONST question answer
asking() {
	printf "💡   ${BLUE}$2 "
	printf "${GREEN}$3${CEND}"

	read ans
	if [[ -z "$ans" ]];then
		ans="$3"
	fi

	eval "$1='"$ans"'"
}

# setup autocomplete
# key command: compgen, complete
# COMPREPLY=() define array
setup_autocomplete() {
	# autocomplete just work for zsh shell, so u need verify it was installed
sudo bash -c 'cat << EOF > '$PUNK_AUTO'
	if [[ ! -z "\$ZSH_VERSION" ]]
	then
		autoload cominit
		autoload bashcompinit
		compinit
		bashcompinit
	fi

	_punk() 
	{
		local cur prev opts
		COMPREPLY=()
		cur="\${COMP_WORDS[COMP_CWORD]}"
		prev="\${COMP_WORDS[COMP_CWORD-1]}"
		opts=\$(cat '$PUNK_SRC' 2>/dev/null | grep -P '"'"'phelp\s"[^"]+"\s*"[^"]+"'"'"' | cut -d"\"" -f2 | cut -d" " -f1)

		if [[ ! -z "\$opts" ]] && [[ "\$prev" = '$PUNK_BIN' ]]
		then
			COMPREPLY=( \$(compgen -W "\${opts}" -- \${cur}) )
		fi
	}
	complete -F _punk punk
EOF'

	# setup bash
	# logname means current user
	bashrc=$(eval echo "~$(logname)")/.bashrc
	if [[ -f "$bashrc" ]];then
		# if .bashrc has include "source ..." command
		if ! grep -Fxq "source $PUNK_AUTO" $bashrc
		then
			printf "\nsource %s" $PUNK_AUTO >> $bashrc
			source $PUNK_AUTO
		fi
	fi

	# setup zsh
	zshrc=$(eval echo "~$(logname)")/.zshrc
	if [[ -f "$zshrc" ]];then
		if ! grep -Fxq "source $PUNK_AUTO" $zshrc
		then
			printf "\nsource %s" $PUNK_AUTO >> $zshrc
			source $PUNK_AUTO
		fi
	else
		sudo touch $zshrc
		printf "\nsource %s" $PUNK_AUTO >> $zshrc
		source $PUNK_AUTO
	fi
}

main() {
	INSTALL_DIR=/usr/local/bin
	if [[ ! -z "$1" ]];then
		INSTALL_DIR="$1"
	fi

	if [[ ! -w "$INSTALL_DIR" ]];then
		printf "⛔  ${RED_BG}must be root to install. ${CEND}\n"
		exit
	fi

	banner

	if [[ ! -f "punk" ]]; then
		printf "✈️  ${BLUE}Downloading......... ${CEND}\n"
		
		if ! command_exist "git"; then
			need_install_manually "git"
			exit
		fi

		git clone https://github.com/wh0197m/CyberPunk.git --depth=1 > /dev/null 2>&1 &
		loading $!
		cd CyberPunk
	fi

	CUR_DIR="$( pwd )"
	
	printf "\n✏️   ${BLUE}OK, there is a questions need u answer before install process. Just press ${GREEN}ENTER ${BLUE}if u want use default config. ${CEND}\n"

	asking EDITOR "Which is your favourite editor?" "vi"
	
	# DEFAULT_SHELL 0:bash 1:zsh
	DEFAULT_SHELL=0
	if get_answer "Do u want to use zsh as your default shell?";then
		DEFAULT_SHELL=1
	fi

	PUNK_BIN="punk"
	PUNK_SRC=$INSTALL_DIR/$PUNK_BIN
	printf "#!/usr/bin/env bash\n\n" > $PUNK_SRC
	printf "EDITOR=${EDITOR}\n" >> $PUNK_SRC
	printf "\n" >> $PUNK_SRC

	tail -n +3 "$CUR_DIR/punk.sh" >> $PUNK_SRC
	chmod +x $PUNK_SRC

	# create the auto-completetion file
	if [[ -d "/etc/bash_completion.d/" ]];then
		PUNK_AUTO="/etc/bash_completion.d/punk_completion"
	else
		sudo mkdir -p /etc/bash_completion.d/
		PUNK_AUTO="/etc/bash_completion.d/punk_completion"
	fi
	setup_autocomplete

	printf "\n🤟  ${GREEN}OK, everything is ready, we'll install a series of dependencies.${CEND}\n"

	# command             # on mac             # on centos7
	install_spawn         wget                 wget
	install_spawn         curl                 curl
	install_spawn         nmap                 nmap
	install_spawn         zsh                  zsh

	# switch to DEFAULT_SHELL
	if [[ $DEFAULT_SHELL -eq 0 ]];then
		chsh -s /bin/bash > /dev/null 2>&1 &
	else
		# 0 means true, 1 means false
		if ! grep -Fxq "/bin/zsh" /etc/shells;then
			requirement_not_exist "zsh"
		else
			chsh -s /bin/zsh > /dev/null 2>&1 &
		fi
	fi
}

# $@: all parameters
# $?: the last command exit status (INT)
# $$: current process pid
main $@