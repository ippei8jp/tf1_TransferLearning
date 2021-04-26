# 概要
Tensorflow1環境でのSSDモデルの転移学習の手順を試してみた。  
<https://github.com/ippei8jp/tf2_TransferLearning>のtensorflow1版。  

# 参考
以下のサイトをtensorflow1向けに変更してトレースしています。  
< https://towardsdatascience.com/train-an-object-detector-using-tensorflow-2-object-detection-api-in-2021-a4fed450d1b9>


# 転移学習の実行
tf1_HandDetector.ipynb をGoogle Colaboratory で実行

# 実行完了をひたすら待つ
試したときは？時間くらいかかった
コマンド実行終了した後、ほったらかしておくと
「あんたロボットと違う？」と聞かれ、ちゃんと答えないと接続切られちゃうので注意。  
(スタートして寝たり出掛けたりしちゃうと、せっかく学習終了したのに消えちゃうことも)  

最初のセルコードセル化して実行し、カレントをGoogleDriveにしておくと接続切られても結果は残ってる。  
でも、空き容量ないと動かないので注意。  

## 出力データと生成済みモデルのダウンロード
output_training_XXXXXXXX_XXXXXX.zip    出力データ
inference_XXXXXXXX_XXXXXX.zip          生成済みモデル


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
GoogleColab上ではtensorboardの出力がうまく表示されないので、ローカルで表示してみる。  
出力データを展開してtensorbloadを起動。  

```
unzip output_training_XXXXXXXX_XXXXXX.zip
unzip 
tensorboard --logdir output_training
```

ブラウザで``localhost:6006``に接続

## ダウンロードしたモデルファイルを展開する

```
unzip inference_XXXXXXXX_XXXXXX.zip
unzip 
```

## テスト

テストディレクトリに移動  
```
cd _test
sh _test.sh
```

または、任意の画像ファイルを指定して以下を実行

```
python hand_detect.py <<JPEGファイル>>
```

# openVINOモデルへの変換

## 準備
python 仮想環境はopenVINO環境に切り替えておく。  
```
cd _convert_to_openVINO
pyenv local openvino_py37
```

## モデル変換
```
bash convert.sh
```
_IRディレクトリ以下に変換されたモデルが出力される。  

## テスト

```
bash _test.sh
```

