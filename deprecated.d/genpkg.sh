


function cpkg(){
echo $1
for p in  $1 ; do
	for f in `pacman -Ql $p | cut -d" " -f2    `; do
		[ -d $f  ] && mkdir -p "/mnt/lfs"$f || cp -v $f "/mnt/lfs"$f
	done
done
}


function gen_packages_list(){
{

for p in `pacman -Qi --group $1 | cut -d" " -f2`; do
	pactree -lu $p
done 
} | sort | uniq | tr "\n" " "

}


#} | sort | uniq  >  /tmp/rslt22

#cpkg $@

cpkg "`gen_packages_list  $1 `"





#uniq /tmp/rslt >> /tmp/rslt
