#!/bin/dash
#===================
# the backup script
#===================
#=== conf ===#
exclude="--exclude /home/mario/.wine --exclude /home/mario/Torrents --exclude /home/mario/.games" # write --exclude <smth>       ### see rdiff-backup
o_opt="--print-statistics" # other options to rdiff-backup  ## man pages
b_dir="/home/" # directory to backup
d_dir="/media/backup/" # destination of backup
log="/root/.backup.log/" # place for log
disc="/dev/sdb1" # disc for backup

#=== variables ===#
cols=$(tput cols)
cols_t=$(($cols-2))
cols_s=$(($cols-6))
wzium=$(awk -v cols=$cols_t 'BEGIN{while (a++<cols) s=s "="; print s}')
space=$(awk -v cols=$cols_s 'BEGIN{while (a++<cols) s=s " "; print s}')

#=== name of log file ===#
today=$(date '+%d%m%y')
l_file="${log}${today}.log"

#=== colors ===#
p="\033[1;35m"
g="\033[1;32m"
c="\033[0m"
r="\033[1;31m"
b="\033[1;34m"
w="\033[1;39m"

#=== Don't edit below ===#
echo "Mounting ${p}${d_dir}${c}…"
mount ${disc} ${d_dir}
exit_code_m=$?

if [ $exit_code_m = 0 ]
then
    echo "${g}${space}done  "
else
    echo "${r}Mount failed!"
    exit
fi

echo "${r}Starting backup…${c}"
rdiff-backup ${o_opt} ${exclude} ${b_dir} ${d_dir} >> ${l_file}
exit_code=$?

if [ $exit_code = 0 ]
then
    echo "${g}Backup ${b_dir} finished successful"
    echo "${c}Unmounting ${p}${d_dir}${c}…"
    umount ${d_dir}
    echo "${g}${space}done  "
    
    echo "${b}Don't forget to do it next day!"
else
    echo "${r}Backup ${b_dir} failed!"
    echo "${w} ${wzium} ${c}"
    cat ${l_file}
    echo "${w} ${wzium} "
    echo "${r}Backup failed! Check logs!"
fi

echo "${r}Log is available in: ${l_file}"
echo "${c}"