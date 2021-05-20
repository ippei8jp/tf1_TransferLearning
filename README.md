# 概要
Tensorflow1環境でのSSDモデルの転移学習の手順を試してみた。  
<https://github.com/ippei8jp/tf2_TransferLearning>のtensorflow1版。  

# 参考
以下のサイトをtensorflow1向けに変更してトレースしています。  
< https://towardsdatascience.com/train-an-object-detector-using-tensorflow-2-object-detection-api-in-2021-a4fed450d1b9>


# 転移学習の実行
tf1_TransferLearning.ipynb をGoogle Colaboratory で実行

# 実行完了をひたすら待つ
tf1のモデルは収束が遅くて1回のマシン割り当て時間では終了しなかった。何回かに分けて実行してようやく終了。  
コマンド実行終了した後、ほったらかしておくと
「あんたロボットと違う？」と聞かれ、ちゃんと答えないと接続切られちゃうので注意。  
(スタートして寝たり出掛けたりしちゃうと、せっかく学習終了したのに消えちゃうことも)  
2回目以降の実行は自動的に続きから実行されるので、再割り当て(翌日とかだけど...)したあと、最初から実行すれば良い。  


## 出力データと生成済みモデルのダウンロード
hand_detect_tf1/output_training_YYYY_XXXXXXXX_XXXXXX.zip    出力データ
hand_detect_tf1/hand_detect_YYYY_XXXXXXXX_XXXXXX.zip        生成済みモデル
VOCのときはhandをvocに読み替え  
YYYYは学習回数  
XXXXXXXX_XXXXXXは日時  
tensorboardで表示したい場合はoutput_trainingが必要だが、要らないならダウンロード不要。  


# ローカル環境でのテスト

## このリポジトリをcloneする

## python仮想環境設定
```
pyenv virtualenv 3.7.10 tensorflow1_py37
pyenv local tensorflow1_py37
pip install --upgrade pip setuptools
```

## pythonモジュールのインストール
```
pip install tensorflow==1.*
git clone --depth 1 https://github.com/tensorflow/models

cd models/research/

protoc object_detection/protos/*.proto --python_out=.
cp object_detection/packages/tf1/setup.py .
pip install .

cd ../../
```

## 学習結果の確認
ローカルでtensorboardで学習結果等を表示したい場合は以下の手順で。  

出力データを展開してtensorbloadを起動。  

```
unzip output_training_YYYY_XXXXXXXX_XXXXXX.zip
tensorboard --logdir output_training
```

ブラウザで``localhost:6006``に接続(ポート番号は要確認)

## ダウンロードしたモデルファイルを展開する

```
unzip hand_detect_YYYY_XXXXXXXX_XXXXXX.zip
```

## テスト

テストディレクトリに移動  
```
cd _test
sh _hand_test.sh
```

または、任意の画像ファイルを指定して以下を実行
(各ファイルのパスは``_hand_test.sh``を参照)

```
python _test.py <<ラベルファイル>> <<FrozenModelファイル>> <<JPEGファイル>>
```

# openVINOモデルへの変換

## 準備
python 仮想環境はopenVINO環境に切り替えておく。  
```
cd _convert_to_openVINO
pyenv local openvino_py37
```

## モデル変換

``convert.sh``を開いて変数``TARGET``を設定。  

```
bash convert.sh
```
_IRディレクトリ以下に変換されたモデルが出力される。  

## テスト

``_test.sh``を開いて変数``TARGET``を設定。  

```
bash _test.sh
```

