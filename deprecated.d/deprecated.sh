
#alias del='mv -t ~/.local/share/Trash/files --backup=t'
#alias backup="tar uPvf ~/backup-`lsb_release -r | cut -f 2`.tar /var/cache/apt/archives --exclude=/var/cache/apt/archivesa/partial/* --exclude=/var/cache/apt/archives/lock"
# Use VIm as man pager
vman () {
    export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
                     vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
                     -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
                     -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

    # invoke man page
    man $1

    # we muse unset the PAGER, so regular man pager is used afterwards
    unset PAGER
}

# 

_foo() 
{
    local cur prev opts
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="number alpha"
 
    case "${prev}" in
		number)
	    COMPREPLY=( 1 2 3)
            return 0
            ;;
        alpha)
	    COMPREPLY=( a b c )
            return 0
            ;;
        *)
        ;;
    esac

    COMPREPLY=( $(compgen -W "${opts}" ${cur}) )
}
complete -F _foo foo


