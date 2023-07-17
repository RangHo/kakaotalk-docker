#!/bin/sh
set -e

# Verify that WINEPREFIX has `drive_c` directory
# If not, assume that this prefix is not configured and run wineboot on it
# Also install dependencies using winetricks
if [ ! -d "$WINEPREFIX/drive_c" ]; then
    echo "WINEPREFIX is not configured, running wineboot"
    wine wineboot --init
    winetricks -q d3dx11_43 gdiplus richtx32 msxml6
    winetricks win7
fi

# Check if KakaoTalk is installed
if ! [ -e "$WINEPREFIX/drive_c/Program Files/Kakao/KakaoTalk/KakaoTalk.exe" ]; then
    echo "KakaoTalk is not installed. Downloading installer..."
    wget -O kakaotalk_installer.exe https://app-pc.kakaocdn.net/talk/win32/KakaoTalk_Setup.exe

    echo "Installing KakaoTalk..."
    wine kakaotalk_installer.exe
fi

# Run KakaoTalk
wine "$WINEPREFIX/drive_c/Program Files/Kakao/KakaoTalk/KakaoTalk.exe"
