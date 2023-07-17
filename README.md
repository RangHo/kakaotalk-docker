# 카카오톡 컨테이너

카카오톡을 컨테이너에 설치한 후 이용하세요!

## 사용법

이 컨테이너는 `podman`과 `docker` 모두 지원합니다.
저는 `podman`을 쓸게요.
`docker`를 이용하시는 분은 그냥 `podman`을 `docker`로 바꿔서 이용하시면 됩니다.

먼저 이 레포를 클론합니다.

```sh
git clone https://github.com/RangHo/kakaotalk-docker
```

다음 이미지를 빌드해 줍니다.
(호환성을 위해 Windows 설치 디스크로부터 한글 폰트를 전부 가져옵니다!
시간이 오래 걸릴 수 있으니 잠시만 기다려주세요.)

```sh
cd kakaotalk-docker
podman build --tag rangho/kakaotalk .
```

빌드가 완료되면 필수 명령줄 인자를 넣고 컨테이너를 실행하시면 됩니다.
첫 실행이라면 Wine 설치와 카카오톡 설치가 시작될 거예요.

```sh
podman run --rm \
    -e "DISPLAY=unix$DISPLAY" \
    -e "GTK_IM_MODULE=$GTK_IM_MODULE" \
    -e "QT_IM_MODULE=$QT_IM_MODULE" \
    -e "XMODIFIERS=$XMODIFIERS" \
    -v /etc/localtime:/etc/localtime:ro \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$HOME/.cache/kakaotalk:/kakaotalk" \
    --hostname "$(hostnamectl --static)" \
    --ipc=host \
    rangho/kakaotalk
```

## 기능

이 컨테이너로 사용 가능한 기능은 아래를 참고해 주세요.
체크 표시가 된 항목은 검증이 완료된 부분입니다.

- [x] 카카오톡 로그인
- [x] 메시지 전송
- [ ] 한글 입력
- [ ] PulseAudio를 이용한 소리 지원
- [ ] 메시지 알림
- [ ] 보이스톡

## 왜요?

`amd64` 전용 리눅스 배포판을 이용하는 사용자 입장에서 wine 하나를 위해 32비트
호환 라이브러리를 설치하는 건 어불성설이니까요...

~~카카오는 하루빨리 리눅스 네이티브 클라이언트를 개발하라!~~
