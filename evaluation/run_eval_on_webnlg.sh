#! /bin/bash
OUTPUT_FILE=webnlg_models/webnlgprefixtune_y_5_act_cat_b=5-e=5_d=0.0_u=no_lr=5e-05_w=0.0_s=222_r=n_m=512_earlystop_o=1_o=1_test_beam
export TEAMR=team

echo $OUTPUT_FILE
echo $TEAMR

cp $OUTPUT_FILE ../../dart/evaluation/webnlg-automatic-evaluation/submissions/$TEAMR.txt
cd ../..

# BLEU
cd dart/evaluation/webnlg-automatic-evaluation/
python evaluation.py $TEAMR
. bleu_eval_3ref.sh
cd ..
echo "ALL:"; cat webnlg-automatic-evaluation/eval/bleu3ref-$TEAMR\_all-cat.txt > bleu_all.txt
# BLEU seen
echo "SEEN:"; cat webnlg-automatic-evaluation/eval/bleu3ref-$TEAMR\_old-cat.txt > bleu_seen.txt
# BLEU unseen
echo "UNSEEN:"; cat webnlg-automatic-evaluation/eval/bleu3ref-$TEAMR\_new-cat.txt > bleu_unseen.txt

# METEOR
cd meteor-1.5/ 
../webnlg-automatic-evaluation/meteor_eval.sh 

cd ..
echo "ALL:"; cat webnlg-automatic-evaluation/eval/meteor-$TEAMR-all-cat.txt > meteor_all.txt
# METEOR seen
echo "SEEN:"; cat webnlg-automatic-evaluation/eval/meteor-$TEAMR-old-cat.txt > meteor_seen.txt
# METEOR unseen
echo "UNSEEN:"; cat webnlg-automatic-evaluation/eval/meteor-$TEAMR-new-cat.txt > meteor_unseen.txt

# TER
cd tercom-0.7.25/
../webnlg-automatic-evaluation/ter_eval.sh 
cd ..
echo "ALL:"; cat webnlg-automatic-evaluation/eval/ter3ref-$TEAMR-all-cat.txt > ter_all.txt
# TER seen
echo "SEEN:"; cat webnlg-automatic-evaluation/eval/ter3ref-$TEAMR-old-cat.txt > ter_seen.txt
# TER unseen
echo "UNSEEN:"; cat webnlg-automatic-evaluation/eval/ter3ref-$TEAMR-new-cat.txt > ter_unseen.txt

python print_scores_webnlg.py
