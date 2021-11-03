#! /bin/bash



export curr_dir=$PWD
export CODALAB_BASEPATH=~/temp_eval

mkdir ${CODALAB_BASEPATH}


OUTPUT_FILE=$1
TEAMR=$2

echo $OUTPUT_FILE
echo $TEAMR


TEST_TARGETS_REF0=our_dart_ref/reference0.txt
TEST_TARGETS_REF1=our_dart_ref/reference1.txt
TEST_TARGETS_REF2=our_dart_ref/reference2.txt


# BLEU
./multi-bleu.perl ${TEST_TARGETS_REF0} ${TEST_TARGETS_REF1} ${TEST_TARGETS_REF2} < ${OUTPUT_FILE} > ${CODALAB_BASEPATH}/bleu.txt

python prepare_files.py ${OUTPUT_FILE} ${TEST_TARGETS_REF0} ${TEST_TARGETS_REF1} ${TEST_TARGETS_REF2}
# METEOR
cd meteor-1.5/ 
java -Xmx2G -jar meteor-1.5.jar ${OUTPUT_FILE} ${CODALAB_BASEPATH}/all-notdelex-refs-meteor.txt -l en -norm -r 8 > ${CODALAB_BASEPATH}/meteor.txt
cd ..

# TER
cd tercom-0.7.25/
java -jar tercom.7.25.jar -h ${CODALAB_BASEPATH}/relexicalised_predictions-ter.txt -r ${CODALAB_BASEPATH}/all-notdelex-refs-ter.txt > ${CODALAB_BASEPATH}/ter.txt
cd ..

# MoverScore
python moverscore.py ${TEST_TARGETS_REF0} ${OUTPUT_FILE} > ${CODALAB_BASEPATH}/moverscore.txt
# BERTScore
bert-score -r ${TEST_TARGETS_REF0} ${TEST_TARGETS_REF1} ${TEST_TARGETS_REF2} -c ${OUTPUT_FILE} --lang en > ${CODALAB_BASEPATH}/bertscore.txt
# BLEURT
python -m bleurt.score_files -candidate_file=${OUTPUT_FILE} -reference_file=${TEST_TARGETS_REF0} -bleurt_checkpoint=bleurt/bleurt/test_checkpoint -scores_file=${CODALAB_BASEPATH}/bleurt.txt

python print_scores.py
