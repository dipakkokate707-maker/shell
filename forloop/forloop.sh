root@ip-172-31-46-253:~/day3# cat forloop.sh 
#!/bin/bash
#this is for & while loops 
for (( num=1 ; num <=5 ; num++ )) ;
do
        mkdir "demo$num"
done
