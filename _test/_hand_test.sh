FROZEN_FILE=../hand_detect/frozen_inference_graph.pb
LABEL_FILE=../hand_detect/label_map.pbtxt
JPEG_FILE1=hand_a.jpg
JPEG_FILE2=hand_b.jpg

if [ ! -e ${JPEG_FILE1} ]; then
  wget https://cdn.amebaowndme.com/madrid-prd/madrid-web/images/sites/483796/1357355de6edbc4c4b54d22faf0b0756_ce052e9b134a9dbb047a8e17c890832a.jpg -O ${JPEG_FILE1}
  wget https://cdn.amebaowndme.com/madrid-prd/madrid-web/images/sites/483796/564b6ca69e9022aa1977f335a148a05a_2d642c807aaf8f5b972a0a406903447d.jpg -O ${JPEG_FILE2}
fi

python _test.py ${LABEL_FILE} ${FROZEN_FILE} ${JPEG_FILE1}
python _test.py ${LABEL_FILE} ${FROZEN_FILE} ${JPEG_FILE2}
