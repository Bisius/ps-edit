# ps-edit.sh


PSEDIT_EXITCODE=false
PSEDIT_SHORT=false
PSEDIT_HIDE=false
PSEDIT_BRANCH=true
PSEDIT_COMMIT=true
PSEDIT_SCREEN=true
PSEDIT_COLOR="${NC}"

alias "psedit-p"="PSEDIT_SHORT=true ; PSEDIT_HIDE=false"
alias "psedit+p"="PSEDIT_SHORT=false; PSEDIT_HIDE=false"
alias "psedit--p"="PSEDIT_HIDE=true"
alias "psedit+e"="PSEDIT_EXITCODE=true"
alias "psedit-e"="PSEDIT_EXITCODE=false"
alias "psedit+b"="PSEDIT_BRANCH=true"
alias "psedit-b"="PSEDIT_BRANCH=false"
alias "psedit+c"="PSEDIT_COMMIT=true"
alias "psedit-c"="PSEDIT_COMMIT=false"
alias "psedit+s"="PSEDIT_SCREEN=true"
alias "psedit-s"="PSEDIT_SCREEN=false"
alias "psedit++"="PSEDIT_EXITCODE=true ; PSEDIT_SHORT=false ; PSEDIT_HIDE=false ; PSEDIT_BRANCH=true ; PSEDIT_COMMIT=true"
alias "psedit--"="PSEDIT_EXITCODE=false ; PSEDIT_SHORT=false ; PSEDIT_HIDE=false ; PSEDIT_BRANCH=false ; PSEDIT_COMMIT=false"

function prompt() {
    local code="$?"
    local lcode=""
    local luser=""
    local lhost=""
    local lsession=""
    local lpath=""
    local lgit=""
    local lprompt=""
    local lcmdColor=""

    ##  pre  ##
    if [ $PSEDIT_EXITCODE == true ]; then
        if [ "${code}" == "0" ]; then
            lcode="[${GREEN}${code}${NC}]"
        else
            lcode="[${RED}${code}${NC}]"
        fi
    fi

    ##  user  ##
    if [ "$(whoami)" == "root" ]; then
        luser="${RED}\u${NC}"
    else
        luser="${GREEN}\u${NC}"
    fi


    ##  host  ##
    lhost="${GREEN}\h${NC}"


    ##  session  ##
    if [ $PSEDIT_SCREEN == true ]; then
	if [ "${STY}" == "" ]; then
	    lsession=""
	else
	    lsession="[${CYAN}${STY}${NC}]"
	fi
    fi


    ##  path  ##
    if [ $PSEDIT_HIDE == true ]; then
        lpath=""
    else
        if [ $PSEDIT_SHORT == true ]; then
            lpath="${BLUEB}\W${NC}"
        else
            lpath="${BLUEB}\w${NC}"
        fi
    fi


    ##  git  ##
	local lbranch=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
	local lcommit=`git log --pretty=format:'%h' -n 1 2> /dev/null`

	if [ $PSEDIT_BRANCH == true ]; then
		if [ "${lbranch}" != "" ]; then
			lgit="[${PURPLE}${lbranch}${NC}"
		fi
	fi

	if [ $PSEDIT_COMMIT == true ]; then
		if [ "${lcommit}" != "" ]; then
			if [ "${lgit}" == "" ]; then
				lgit="[${PURPLE}${lcommit}${NC}"
			else
				lgit="${lgit}-${PURPLE}${lcommit}${NC}"
			fi
		fi
	fi

	if [ "${lgit}" != "" ]; then
		lgit="${lgit}]"
	fi


    ##  prompt  ""
    if [ "$(whoami)" == "root" ]; then
        lprompt="#"
    else
        lprompt="\$"
    fi


    ##  cmd color  ##
    lcmdColor="${PSEDIT_COLOR}"


    PS1="${lcode}${luser}@${lhost}${lsession}:${lpath}${lgit}${lprompt}${lcmdColor} "
}


PROMPT_COMMAND=prompt
