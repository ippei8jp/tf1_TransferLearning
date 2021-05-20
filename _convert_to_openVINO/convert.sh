#!/usr/bin/bash

TARGET=HAND
# TARGET=VOC

# pyenvでpythonのバージョンを切り替えたときの問題の対策  ==================================
## 現在のpythonのバージョン取得
# TMP_PYVER=`python -V |  sed -e "s/^.*\(3.[0-9]\{1,\}\).*$/\1/g"`
TMP_PYVER=`python -c "import sys; v = sys.version_info; print(f'{v[0]}.{v[1]}')"`
## PYTHONPATHの該当箇所を置換
export PYTHONPATH=`echo $PYTHONPATH  | sed -e "s/\/python3\.[0-9]\{1,\}/\/python${TMP_PYVER}/g"`
# =========================================================================================

if [ "${TARGET}" == "HAND" ]; then
    # hand_detect
    MODEL_NAME=ssd_mobilenet_v2_hand_detect
    CONFIG_FILE=../hand_detect/pipeline.config
    INPUT_MODEL=../hand_detect/frozen_inference_graph.pb
    LABELS_FILE=../hand_detect/label_map.txt
    TRANS_CONFIG=/opt/intel/openvino_2021/deployment_tools/model_optimizer/extensions/front/tf/ssd_support_api_v1.15.json
else
    # voc_detect
    MODEL_NAME=ssd_mobilenet_v2_hand_detect
    CONFIG_FILE=../voc_detect/pipeline.config
    INPUT_MODEL=../voc_detect/frozen_inference_graph.pb
    LABELS_FILE=../voc_detect/label_map.txt
    TRANS_CONFIG=/opt/intel/openvino_2021/deployment_tools/model_optimizer/extensions/front/tf/ssd_support_api_v1.15.json
fi

OPTIONS=" --framework=tf"
# OPTIONS+=" --log_level=DEBUG"
OPTIONS+=" --data_type=FP16"
OPTIONS+=" --transformations_config=${TRANS_CONFIG}"
OPTIONS+=" --reverse_input_channels --input_shape=[1,300,300,3]"
OPTIONS+=" --input=image_tensor"
OPTIONS+=" --tensorflow_object_detection_api_pipeline_config=${CONFIG_FILE}"
OPTIONS+=" --output=detection_classes,detection_scores,detection_boxes,num_detections"
OPTIONS+=" --model_name=${MODEL_NAME}"
OPTIONS+=" --input_model=${INPUT_MODEL}"
OPTIONS+=" --output_dir=./_IR/${MODEL_NAME}/FP16"

# 実行
# echo ${OPTIONS}
/opt/intel/openvino_2021/deployment_tools/model_optimizer/mo.py ${OPTIONS}

# ラベルファイルもコピー
if [ -f ${LABELS_FILE} ]; then
    cp ${LABELS_FILE} ./_IR/${MODEL_NAME}/FP16/${MODEL_NAME}.labels
fi
