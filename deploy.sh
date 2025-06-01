#!/bin/bash

APP_DIR=~/app/build/libs
cd $APP_DIR || { echo "디렉토리 이동 실패"; exit 1; }

# plain.jar 제외한 jar 중 가장 최신 것 실행
JAR_NAME=$(ls -t *.jar | grep -v plain | head -n 1)

echo "[DEPLOY] 실행 대상: $JAR_NAME"

# 기존 프로세스 종료
PID=$(pgrep -f $JAR_NAME)
if [ -n "$PID" ]; then
  echo "[DEPLOY] 기존 프로세스 종료: $PID"
  kill -9 $PID
fi

# 실행
echo "[DEPLOY] 앱 실행 시작"
nohup java -jar $JAR_NAME > deploy.log 2>&1 &