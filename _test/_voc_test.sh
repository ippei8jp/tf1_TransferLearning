FROZEN_FILE=../voc_detect/frozen_inference_graph.pb
LABEL_FILE=../voc_detect/label_map.pbtxt
JPEG_FILE1=voc_a.jpg
JPEG_FILE2=voc_b.jpg

if [ ! -e ${JPEG_FILE1} ]; then
  wget https://prtimes.jp/i/6067/298/resize/d6067-298-418042-0.jpg             -O ${JPEG_FILE1}
  wget https://www.kic-car.ac.jp/theme/kic_school/img/taisho/ph-society001.jpg -O ${JPEG_FILE2}
fi

python _test.py ${LABEL_FILE} ${FROZEN_FILE} ${JPEG_FILE1}
python _test.py ${LABEL_FILE} ${FROZEN_FILE} ${JPEG_FILE2}
