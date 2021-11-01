#! /bin/bash

OUTPUT_FILE=content/dart/evaluation/example/bart_webnlg.txt
export TEAMR=team

echo $OUTPUT_FILE
echo $TEAMR

cp $OUTPUT_FILE content/dart/evaluation/webnlg-automatic-evaluation/submissions/$TEAMR.txt

# BLEU
cd content/dart/evaluation/webnlg-automatic-evaluation/
python evaluation.py $TEAMR
. bleu_eval_3ref.sh
cd ..
echo "ALL:"; cat webnlg-automatic-evaluation/eval/bleu3ref-$TEAMR\_all-cat.txt > bleu_all.txt
# BLEU seen
echo "SEEN:"; cat webnlg-automatic-evaluation/eval/bleu3ref-$TEAMR\_old-cat.txt > bleu_seen.txt
# BLEU unseen
echo "UNSEEN:"; cat webnlg-automatic-evaluation/eval/bleu3ref-$TEAMR\_new-cat.txt > bleu_unseen.txt

# METEOR
cd content/dart/evaluation/meteor-1.5/ 
../webnlg-automatic-evaluation/meteor_eval.sh 

cd ..
echo "ALL:"; cat webnlg-automatic-evaluation/eval/meteor-$TEAMR-all-cat.txt > meteor_all.txt
# METEOR seen
echo "SEEN:"; cat webnlg-automatic-evaluation/eval/meteor-$TEAMR-old-cat.txt > meteor_seen.txt
# METEOR unseen
echo "UNSEEN:"; cat webnlg-automatic-evaluation/eval/meteor-$TEAMR-new-cat.txt > meteor_unseen.txt

# TER
cd content/dart/evaluation/meteor-1.5/tercom-0.7.25/
../webnlg-automatic-evaluation/ter_eval.sh 
cd ..
echo "ALL:"; cat webnlg-automatic-evaluation/eval/ter3ref-$TEAMR-all-cat.txt > ter_all.txt
# TER seen
echo "SEEN:"; cat webnlg-automatic-evaluation/eval/ter3ref-$TEAMR-old-cat.txt > ter_seen.txt
# TER unseen
echo "UNSEEN:"; cat webnlg-automatic-evaluation/eval/ter3ref-$TEAMR-new-cat.txt > ter_unseen.txt

python print_scores_webnlg.py

