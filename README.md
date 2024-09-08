# 채팅형 메모 애플리케이션, MEMOW!

## 📱 개요

이 프로젝트는 사용자가 **시간이 지나도 메모가 적체되지 않도록 관리할 수 있는** 간단하면서도 효율적인 **채팅형 메모 애플리케이션**입니다. Apple 기본 메모 앱이나 Notion과 같은 복잡한 도구에서 느꼈던 불편함을 바탕으로, 이 앱은 **간편함과 기능성** 사이에서 균형을 찾는 것을 목표로 개발되었습니다.

사용자는 익숙한 **채팅 인터페이스**에서 빠르게 메모를 작성할 수 있으며, 메모 병합, 알람 설정 등의 기능을 통해 사용하지 않거나 잊어버린 메모들이 쌓이는 것을 방지할 수 있습니다. 간단한 생각을 적거나 장기적인 작업을 정리하는 등 다양한 방식으로 이 앱을 사용할 수 있습니다.

## 🚀 주요 기능

- **채팅형 메모 작성**: 채팅 인터페이스에서 쉽게 메모를 작성할 수 있어, 직관적이고 빠른 메모 작성이 가능합니다.
- **메모 병합**: 여러 메모를 하나로 병합해 불필요한 정보들을 정리하고 관리할 수 있습니다.
- **알람 설정**: 중요한 메모에 알람을 설정하여 중요한 작업이나 메모를 잊지 않도록 도와줍니다.
- **로컬 데이터 저장 (CoreData)**: 메모가 안전하게 로컬에 저장되어 오프라인 상태에서도 메모를 사용할 수 있습니다.
- **커스텀 애니메이션 및 스와이프 제스처**: 부드럽고 직관적인 스와이프 제스처로 메모 관리 및 사이드바 사용이 가능합니다.

## 🌟 이 앱의 필요성

Apple 기본 메모 앱은 빠르고 간편하게 사용할 수 있지만 시간이 지남에 따라 메모가 쌓여 관리가 어렵습니다. 반면, Notion과 같은 앱은 기능이 많지만 복잡하고, 사용하기 어렵습니다. **가볍고 간단하게 사용할 수 있는 메모 앱**이 필요하다는 생각에서 이 앱을 개발하게 되었습니다.

많은 사용자가 **카카오톡 '나와의 채팅'** 기능을 메모용으로 사용하지만, 여러 번의 터치가 필요하고 시간이 지나면 메모를 잊어버리는 문제가 있었습니다. 이를 개선해 채팅형 인터페이스를 통해 간편하지만 더 효율적인 메모 작성을 가능하게 하고자 했습니다.

## 💻 기술 스택

- **SwiftUI**: 현대적이고 선언형 UI를 구현하기 위해 SwiftUI를 사용했습니다.
- **CoreData**: 메모를 안전하게 로컬에 저장하기 위한 데이터 저장소로 CoreData를 사용했습니다.
- **Combine**: 앱 상태 및 데이터 흐름을 효율적으로 관리하기 위해 Combine을 사용했습니다.
- **커스텀 제스처 및 애니메이션**: 부드럽고 직관적인 사용자 경험을 제공하기 위해 커스텀 제스처와 애니메이션을 추가했습니다.

## 👨‍💻 개발 과정

이 프로젝트는 **기획**, **디자인**, **개발**을 각각 맡은 세 명이 협력하여 시작되었습니다. 처음에는 네이티브 개발이 필요해지면서 iOS 개발 공부를 막 시작한 제가 팀에 합류하게 되었고, 몇 달에 걸쳐 앱을 개발하며 **CoreData** 및 **커스텀 제스처**와 같은 기능을 구현하는 데 많은 도전과 해결 과정을 겪었습니다.   
서비스의 구체적인 [소개글](https://medium.com/@davincimemow/memow-%EA%B8%B0%ED%9A%8D-%EC%8A%A4%ED%86%A0%EB%A6%AC-5fa66bad4afa)과 [회고록](https://velog.io/@jwlee010523/First-iOS-App-Launch)을 통해 확인해 보세요.

## 📅 앞으로의 계획

앱의 첫 번째 출시가 완료되었지만, 개발은 계속 진행 중입니다.    
추가 기능을 포함해 사용자 경험을 개선할 계획이며, 올해 안에 2차 업데이트를 목표로 하고 있습니다.

---

# Chat-Style Memo Application, MEMOW!

## 📱 Overview

This project is a **chat-style memo application** designed to help users manage their notes without accumulation over time. Based on the shortcomings of tools like Apple’s default memo app and Notion, this app aims to strike a balance between **simplicity and functionality**.

Users can quickly create notes in a familiar **chat interface**, with features like note merging and reminders to prevent forgotten or unused memos from piling up. Whether it’s jotting down thoughts or organizing long-term tasks, the app offers an intuitive solution.

## 🚀 Key Features

- **Chat-Style Note Taking**: Easily create notes in a chat interface for quick and intuitive note-taking.
- **Merge Notes**: Combine multiple notes to declutter and keep information organized.
- **Reminders**: Set reminders for important notes so you don’t forget tasks or memos.
- **Local Data Storage (CoreData)**: Notes are stored locally for secure, offline access.
- **Custom Animations and Swipe Gestures**: Smooth swipe gestures and sidebar interactions for easy note management.

## 🌟 Why This App?

While Apple’s default memo app is quick and easy, it can become cluttered over time. On the other hand, Notion offers extensive features but is often too complex and cumbersome. This app was developed with the idea of creating a **lightweight, easy-to-use memo app**.

Many users also use **KakaoTalk’s ‘My Chat’** feature for notes, but it requires multiple taps and often leads to forgotten memos. This app solves that by combining a chat-like interface with more efficient note-taking features.

## 💻 Tech Stack

- **SwiftUI**: Used for a modern, declarative UI.
- **CoreData**: Employed for local data storage to keep notes safe.
- **Combine**: Used to efficiently manage app state and data flow.
- **Custom Gestures and Animations**: Added to enhance user experience with smooth and intuitive interactions.

## 👨‍💻 Development Process

This project was a collaboration between three team members who handled **planning**, **design**, and **development**. I joined the team after starting iOS development, facing challenges and solving problems like implementing **CoreData** and **custom gestures**.  
"Get more details with specific [introductions](https://medium.com/@davincimemow/memow-%EA%B8%B0%ED%9A%8D-%EC%8A%A4%ED%86%A0%EB%A6%AC-5fa66bad4afa) and [memoirs of the service](https://velog.io/@jwlee010523/First-iOS-App-Launch)."

## 📅 Future Plans

The first release of the app is complete, but development continues.  
We plan to add new features and improve the user experience, with a second update planned before the end of the year.
