export PATH=$PATH:/home/liulang/.local/bin
while read line;do 
eval $line;
done < submission_command.txt

exit

dx download GBA1/gba* -o ../GBA1/