#!/bin/sh
#===================#
# the backup script #
#      ======       #
#      mariom       #
#===================#
#=== conf ===#
exclude="/home/mario/.wine /home/mario/Torrents /home/mario/.games" # write shell_pattern      ### see man rdiff-backup
o_opt="--print-statistics" # other options to rdiff-backup  ## man pages
b_dir="/home/" # directory to backup
d_dir="/media/backup/" # destination of backup
log="/root/.backup.log/" # place for log, if empty - no logs will be saved.
disc="/dev/sdb1" # disc for backup, if empty - no disk will be mounted

#=== Fancy things ;) ===#
cols=$(tput cols)
cols_t=$(($cols-2))
cols_s=$(($cols-6))
wzium=$(awk -v cols=$cols_t 'BEGIN{while (a++<cols) s=s "="; print s}')
space=$(awk -v cols=$cols_s 'BEGIN{while (a++<cols) s=s " "; print s}')

#=== Name of log file ===#
today=$(date '+%d%m%y')
l_file="${log}${today}.log"

#=== Colors ===#
p="\033[1;35m"
g="\033[1;32m"
c="\033[0m"
r="\033[1;31m"
b="\033[1;34m"
w="\033[1;39m"

#=== Don't edit below ===#
#=== Functions ===#
mounts()
{
    printf "Mounting ${p}${d_dir}${c}…\n"
    mount ${disc} ${d_dir}
    exit_code_m=$?
    
    if [ $exit_code_m = 0 ]
    then
	printf "${g}${space}done  \n"
    else
	printf "${r}Mount failed!\n"
	exit
    fi
}

umounts()
{
    printf "${c}Unmounting ${p}${d_dir}${c}…\n"
    umount ${d_dir}
    
    if [ $exit_code_m = 0 ]
    then
	printf "${g}${space}done  \n"
    else
	printf "${r}Unmount failed!\n"
    fi
}

#=== Parse opts ===#
while getopts "b:d:e:f:hlm::o:" opt; do
    case $opt in
	b)
	    b_dir="${OPTARG}"
	    printf ${OPTARG}
	    ;;
	d)
	    d_dir="${OPTARG}"
	    printf ${OPTARG}
	    ;;
	e)
	    exclude="${OPTARG}"
	    printf ${OPTARG}
	    ;;
	f)
	    printf "Not implemented yet.\n"
	    printf ${OPTARG}
	    ;;
	h)
	    printf "There will be help in future.\n"
	    printf "backup.sh is an backup script using rdiff-backup.\n\n"
	    printf "Options:\n"
	    printf " -b <dir> - directory to backup\n"
	    printf " -d <dir> - destination of backup\n"
	    printf " -e \"<exclude>\" - exclude (see rdiff-backup's man)\n"
	    printf " -f <file> - configuration file (default /etc/backup.sh.rc and ~/.backup.sh.rc)\n"
	    printf " -h - this help\n"
	    printf " -l <dir> - directory to store logs (empty for no logs)\n"
	    printf " -m <device> - device to mount before doing backup\n"
	    printf " -o \"<opts>\" - options to rdiff-backup\n\n\n"

	    printf "mariom, 2011\n"
	    exit 0
	    ;;
	l)
	    log="${OPTARG}"
	    printf ${OPTARG}
	    ;;
	m)
	    disc="${OPTARG}"
	    printf ${OPTARG}
	    ;;
	o)
	    o_opt="${OPTARG}"
	    printf ${OPTARG}
	    ;;
	\?)
	    printf "Infalid option. Try -h for help"
	    exit 1
	    ;;
	:)
	    printf "Option -$OPTARG requies an argument."
	    exit 1
	    ;;
    esac
done
exit 0

#=== Let's start program! ===#
if [ ${disc:-1} = 1 ]
then
    printf "${c}Nothing to mount\n"
else
    mounts
fi

printf "${r}Starting backup…${c}\n"

if [ ${log:-1} = 1 ]

then
    o_log=""
else
    o_log="--print-statistics"
fi

exclude=$(printf ${exclude} | awk '{for (i = 1; i <= NF; i++)\
                               printf "--exclude %s ",$i}')
rdiff-backup ${o_opt} ${o_log} ${exclude} ${b_dir} ${d_dir} >> ${l_file}
exit_code=$?

if [ $exit_code = 0 ]
then
    printf "${g}Backup ${b_dir} finished successful\n"
    if [ ${disc:-1} = 1 ]
    then
	printf "${c}Nothing to unmount\n"
    else
	umounts
    fi

    printf "${b}Don't forget to do it next day!\n"
else
    printf "${r}Backup ${b_dir} failed!\n"
    printf "${w} ${wzium} ${c}\n"
    cat ${l_file}
    printf "${w} ${wzium} \n"
    printf "${r}Backup failed! Check logs!\n"
fi

printf "${r}Log is available in: ${l_file}\n"
printf "${c}\n"
