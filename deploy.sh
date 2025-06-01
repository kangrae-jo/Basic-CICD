#!/bin/bash

APP_DIR=~/app/build/libs
cd $APP_DIR || { echo "디렉토리 이동 실패"; exit 1; }

JAR_NAME=$(ls -t *.jar | grep -v plain | head -n 1)
echo "[DEPLOY] 실행 대상: $JAR_NAME"

PID=$(pgrep -f $JAR_NAME)
if [ -n "$PID" ]; then
  echo "[DEPLOY] 기존 프로세스 종료: $PID"
  kill -9 $PID
fi

echo "[DEPLOY] 앱 실행 시작"
nohup java -jar $JAR_NAME > $APP_DIR/deploy.log 2>&1 &