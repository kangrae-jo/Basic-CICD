# 🚀 EC2 기반 GitHub Actions CI/CD 구축기

이 프로젝트는 GitHub Actions를 활용해 Spring Boot 애플리케이션을 EC2 서버에 자동 배포(CI/CD)하도록 구성되어 있습니다.  
단순히 push만으로 빌드와 배포가 완료되는 무중단 자동화 배포 파이프라인입니다.

## 🧩 CI/CD 구성 요소

| 항목 | 설명 |
|------|------|
| **CI (Continuous Integration)** | GitHub Actions에서 `./gradlew build` 수행 |
| **CD (Continuous Deployment)** | SCP로 EC2에 JAR 전송 후 SSH로 실행 |
| **배포 서버** | AWS EC2 Ubuntu 20.04 |
| **배포 대상** | `main` 브랜치에 push 시 자동 배포 |


## 🗂 프로젝트 구조 요약
```
├── .github/workflows/
│   └── ci.yml      # 빌드 테스트
│   └── cd.yml      # EC2 배포
```

## EC2 deploy.sh 설정
```sh
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
```

## 노트

1. github에서 build하여 .jar를 ec2로 보낸다.
2. ec2의 deploy.sh를 실행시킨다. (실제 배포 로직)

+ deploy.sh도 github에서 관리하려고 했으나 원인 모를 이유로 실패
