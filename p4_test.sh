#!/bin/bash
REQUIRED_FILES="task1.py task2.sh topic-words.txt doc-topics.txt topic-labels.txt"
ZIP_FILE=$1
TMP_DIR=/tmp/p4-grading/

function error_exit()
{
   echo "$1" 1>&2
   rm -rf ${TMP_DIR}
   exit 1
}

# usage
if [ $# -ne 1 ]
then
     error_exit "Usage: $0 project4.zip"
fi

if [ `hostname` != "cs246" ]; then
     error_exit "ERROR: You need to run this script within the class virtual machine"
fi


# clean any existing files
rm -rf ${TMP_DIR}
mkdir ${TMP_DIR}

# unzip the submission zip file 
if [ ! -f ${ZIP_FILE} ]; then
    error_exit "ERROR: Cannot find ${ZIP_FILE}"
fi
unzip -q -d ${TMP_DIR} ${ZIP_FILE}
if [ "$?" -ne "0" ]; then 
    error_exit "ERROR: Cannot unzip ${ZIP_FILE} to ${TMP_DIR}"
fi

# change directory to the grading folder
cd ${TMP_DIR}

# check the existence of the required files
for FILE in ${REQUIRED_FILES}
do
    if [ ! -f ${FILE} ]; then
        error_exit "ERROR: Cannot find ${FILE} in the root folder of your zip file"
    fi
done

# run task1.py and check the existence of output file
echo "Testing Task 1..."

# retrieve sample image
curl -s -O "http://oak.cs.ucla.edu/classes/cs246/projects/project4/lion-small.png" 
if [ $? -ne 0 ]; then
    error_exit "Error: Failed to retrieve lion-small.png file"
fi

python3 task1.py lion-small.png 3
REQUIRED_OUTPUT1="lion-small.3.png lion-small.3.npy"

for FILE in ${REQUIRED_OUTPUT1}
do
    if [ ! -f ${FILE} ]; then
        error_exit "ERROR: Cannot find ${FILE} in the output of task1.py"
    fi
done
FINFO=$(file lion-small.3.png)
if [ "$FINFO" != "lion-small.3.png: PNG image data, 1024 x 640, 8-bit grayscale, non-interlaced" ]; then 
    error_exit "ERROR: The output of task1.py is wrong"
fi
echo "Finished testing Task 1, SUCCESS!"

# run task2.sh and check the format of the output files
echo "Testing Task 2..."

sh task2.sh $MALLET_HOME/sample-data/web/en/ 5 >& /dev/null

REQUIRED_OUTPUT2="topic-words.txt doc-topics.txt"

for FILE in ${REQUIRED_OUTPUT2}
do
    if [ ! -f ${FILE} ]; then
        error_exit "ERROR: Cannot find ${FILE} in the output of task2.sh"
    fi
done
TP=$(cat topic-words.txt | head -1 | wc -w)
DT=$(cat doc-topics.txt | head -1| wc -w)
if [ $TP != "22" ] || [ $DT != "7" ]; then
    error_exit "ERROR: The output of task2.sh has wrong format"
fi
echo "Finished testing Task 2, SUCCESS!"

# clean up
rm -rf ${TMP_DIR}
exit 0
