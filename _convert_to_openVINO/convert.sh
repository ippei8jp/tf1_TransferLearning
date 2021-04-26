#!/usr/bin/bash

# hand_detect
MODEL_NAME=ssd_mobilenet_v2_hand_detect
CONFIG_FILE=../inference/pipeline.config
# CONFIG_FILE=./inference/temp.config         # batch_norm_trainable を残したバージョン
INPUT_MODEL=../inference/frozen_inference_graph.pb
TRANS_CONFIG=/opt/intel/openvino_2021/deployment_tools/model_optimizer/extensions/front/tf/ssd_support_api_v1.15.json
# TRANS_CONFIG=" --transformations_config=./ssd_v2_support.json"
# TRANS_CONFIG=" --tensorflow_use_custom_operations_config=./ssd_v2_support.json"

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


<<_COMMENT_
--tensorflow_object_detection_api_pipeline_config=./inference/pipeline.config \
--model_name=${MODEL_NAME} \
--input_model=./inference/frozen_inference_graph.pb \
--output_dir=./_IR/${MODEL_NAME}/FP16 

# --transformations_config=/opt/intel/openvino_2021/deployment_tools/model_optimizer/extensions/front/tf/ssd_v2_support.json \

_COMMENT_
