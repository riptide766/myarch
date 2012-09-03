
targetdir=/media/customlinux


cachedir=/tmp/customlinux
cachelist="$cachedir/dependlist"
desclist="$cachedir/descfile"
cachelist="$cachedir"/dependlist
installedlist="$cachedir"/installedlist
etclist="$cachedir"/etclist

mkdir -p $cachedir

function cpkg(){
	grep -q -e "$1$" $installedlist
	[ $? == 0 ] && return
	for f in `pacman -Ql $1 | cut -d" " -f2    `; do
		[ -d $f  ] && mkdir -p "$targetdir"$f || cp -v $f "$targetdir"$f
		[ ${f:1:3} == "etc" ] && echo "$1 --- $f" >> $etclist
	done
	echo $1 >> $installedlist
}


for pkg in `cat $cachelist` ; do
	#echo $pkg
	cpkg $pkg
done

