#! /bin/bash

fns=./install.d/installarch.sh
if [ -L "$0" ] ; then
	rslt=`ls -l $0  | cut -d\> -f2` 
	fns=`dirname "$rslt"`/$fns
fi

exec_by_name()
{
	echo "invoke ..."
	grep "$1.*()$" $fns | cat -b
	echo "===================================="
	read -p "are you sure?(y/n) " rslt
	[ "${rslt:0:1}" = "n" ] && continue
	for fn in `grep "$1.*()$" $fns`;  do
		${fn:0:-2}
	done
}

main()
{
for act in $@ ; do
	case "$act" in
		[^\_]*)
			case $act in
				list)
					grep "^_.*()$" $fns |  tr -d "()"  ;;
				help)
					grep -B 1 "^_.*()$" $fns |  tr -d "()"  | more ;;
				*)
					exec_by_name $act ;;
			esac
			;;
		*)
			echo invoke $act ...
			$act
	esac
done
}

source $fns

main $@
