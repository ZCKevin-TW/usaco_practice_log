#!/bin/bash
####    initialize ####
# path of test data

path=~/Downloads/test_data

# file to execute

file=~/run.in

max_run_time=1000
####               ####

accnt=0
tlecnt=0
RED='\033[0;31m'
GREEN='\033[1;32m'
BLUE='\033[0;34m'
DEF='\033[0m'
testcnt=0
total_time=0
# cnt normal
for i in ${path}/*.in
do
	((++testcnt))
done

# Run testcases
for (( i = 1;i <= $testcnt; ++i))
do
	start_t=$(date +%s%N)
	timeout --foreground $(($max_run_time / 1000+1)) "$file"<"$path/$i.in">"$path/tmp.out"
	tostatus=$?
	end_t=$(date +%s%N)
	time_elapsed=$((($end_t - $start_t) / 1000000))
	printf "${DEF}Running test case %3d  " $i
	verdict=$(diff "$path/tmp.out" "$path/$i.out")
	if [ $tostatus == 124 ]
	then 
		echo -e "${BLUE}TLE ∞"
		((++tlecnt))
	else if [ "$verdict" != "" ]
	then
		echo -e "${RED}WA \c"
	else if (($time_elapsed <= 1000))
		then
			echo -e "${GREEN}AC \c"
			((++accnt))
		else 
			echo -e "${BLUE}TLE\c"
			((++tlecnt))
		fi
	fi
	printf "%6d ms\n" $time_elapsed
	fi
	((total_time += time_elapsed))
done
# Get the verdicts
rm "$path/tmp.out"
if [ $accnt == $testcnt ] 
then 
	echo -e "${GREEN}AC $accnt / $testcnt\c"
else if [ $tlecnt != 0 ]
	then
	echo -e "${BLUE}TLE ${GREEN}$accnt${BLUE} / $testcnt\c"
else 
	echo -e "${RED}WA  ${GREEN}$accnt${RED} / $testcnt\c"
fi
fi
if [ $tlecnt != 0 ] 
then echo "   Run Time : ∞" 
else
echo "  Run Time : $total_time"
fi
echo -e $DEF
