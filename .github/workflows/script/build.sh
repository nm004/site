#!/bin/bash

# site_generator 直下でこのスクリプトを実行すること

# dist を生成
pushd kunai
  npm install
  npm run build
popd

# dist の中身を cpprefjp の static ディレクトリに反映
pushd cpprefjp/static/static
  ln -s ../../../kunai/dist kunai
popd

# crsearch.json ファイルを生成
pushd crsearch.json
  ln -s ../cpprefjp/site site
  pip3 install -r docker/requirements.txt
  python3 run.py
popd

# crsearch.json を cpprefjp の static ディレクトリに反映
mkdir -p cpprefjp/static/static/crsearch
pushd cpprefjp/static/static/crsearch
  ln -s ../../../../crsearch.json/crsearch.json crsearch.json
popd

# サイトの生成
pip3 install -r docker/requirements.txt
python3 run.py settings.cpprefjp

# 生成されたサイトの中身を push
pushd cpprefjp/cpprefjp.github.io
  # push するために ssh のリモートを追加する
  git remote add origin2 git@github.com:cpprefjp/cpprefjp.github.io.git

  git add ./ --all
  git commit -a "--author=cpprefjp-autoupdate <shigemasa7watanabe@gmail.com>" -m "update automatically"
  git push origin2 master
popd
