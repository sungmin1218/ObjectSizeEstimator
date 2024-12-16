## 프로젝트 소개  
간단한 딥러닝 모델과 iOS 앱을 활용하여 카메라로 사물을 촬영하면 해당 객체를 감지하고 크기와 학습 정보를 제공합니다.

## 개발 환경  
- **언어**: Swift  
- **도구**: Xcode 15, CoreML  
- **API**: Wikipedia API  
- **모델**: YOLOv3  

## User Flow  
1. 사용자가 앱에서 **사진을 촬영**합니다.  
2. 객체를 감지하고 이름을 반환합니다.  
3. Wikipedia API를 통해 감지된 객체의 정보를 표시합니다.  

## 기능 명세서  
- **객체 감지**: 사물을 촬영하면 객체를 감지합니다.  
- **객체 정보 제공**: Wikipedia를 통해 감지된 객체의 설명을 제공합니다.  

## 실행 화면  
![실행 화면](link_to_image_or_video)

## 실행 영상  
[실행 영상 링크](https://youtube.com/...)

## 참조 링크  
- [Wikipedia API](https://www.mediawiki.org/wiki/API:Main_page)  
- [YOLOv3 모델](https://github.com/pjreddie/darknet)
