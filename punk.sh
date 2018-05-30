#!/usr/bin/env bash
# -------------------sub commands-----------------------

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
PWW="\033[45;37m"
GWR="\033[46;31m"
GWW="\033[46;37m"
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
    # jobs -l will show the jobs status of current shell session
    if [[ -z $(jobs -p) ]];then
        kill $(jobs -p)
    fi
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

br() {
    printf " \n"
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

# format punk help output
phelp() {
    SUB_COMMAND_WIDTH=-40s
    printf "       ${BLUE}punk %${SUB_COMMAND_WIDTH}${CEND} ${WHITE}%s\n" "${1}" "${2}"
}

# -------------------------------basic const-------------------------------
subcommand=$1
arg1=$2
arg2=$3
arg3=$4
arg4=$5

# command: help
help=$(
    printf "${GWW}Usage:${CEND}\n" 
    printf "${YELLOW}       punk subcommand${CEND} ${WHITE}[parameters]${CEND}\n"
    br
    printf "${PWW}Info:${CEND} \n"
    phelp "help" "show available commands and parameters"
    phelp "version" "show the current version of PUNK"
    phelp "update" "upgrade PUNK if new version available"
    br
)

version=$(
    banner
    printf "${CYAN}|${CEND}                                                           ${CYAN}|${CEND}\n"
    printf "${CYAN}|${CEND}                ${YELLOW}Current version: 0.1.0${YELLOW}                     ${CYAN}|${CEND}\n"
    printf "${CYAN}|${CEND}              ${YELLOW}Copyright (c) 2018 wh0197m${YELLOW}                   ${CYAN}|${CEND}\n"
    printf "${CYAN}|${CEND}                 ${YELLOW}Public LICENSE (MIT)${YELLOW}                      ${CYAN}|${CEND}\n"
    printf "${CYAN}└-----------------------------------------------------------┘${CEND}\n"
)
# -------------------------------sub commands-------------------------------

# -----CLASS: INFO-----

# subcommand: help
if [[ $subcommand == "help" || -z $subcommand ]];then
    printf "${help}\n"

# subcommand: version
elif [[ $subcommand == "version" ]];then
    printf "${version}\n"

# subcommand: update
elif [[ $subcommand == "update" ]];then
    # based on github raw file
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/wh0197m/CyberPunk/master/install.sh)"

# -----CLASS: SEARCH-----

# -----CLASS: SYSTEM-----

# -----CLASS: MEDIA-----

# -----CLASS: PHOTOS-----
fi
