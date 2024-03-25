//
//  HomeViewModel.swift
//  Memow
//
//  Created by jaewon Lee on 3/17/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published private(set) var lastMessageId: String = ""
    @Published var messages: [Message]
    @Published var selectedMessages: [Message]
    @Published var isEditMessageMode: Bool
    @Published var isDisplayRemoveNoteAlert: Bool
    
    var navigationBarRightMode: NavigationBtnType {
        return isEditMessageMode ? .close : .select
    }
    
    // 앱 실행시 빈 배열로 messages 배열 초기화
    // 추후 로컬이나 서버 DB에서 메세지를 받아올 예정
    init(
        messages: [Message] = [
            Message(id: "1", content: "Hello", date: Date()),
            Message(id: "2", content: "Nice!", date: Date()),
            Message(id: "3", content: "Hello", date: Date()),
            Message(id: "4", content: "Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!", date: Date()),
        ],
        selectedMessages: [Message] = [],
        isEditMessageMode: Bool = false,
        isDisplayRemoveNoteAlert: Bool = false
    ) {
        self.messages = messages
        self.selectedMessages = selectedMessages
        self.isEditMessageMode = isEditMessageMode
        self.isDisplayRemoveNoteAlert = isDisplayRemoveNoteAlert
    }
}

// 함수 기능 추가
extension HomeViewModel {
    // 텍스트 문자열만 받아서 messages 배열에 추가
    func sendMessage(_ text: String) {
        // 새로운 Message 생성
        let newMessage = Message(id: "\(UUID())", content: text, date: Date())
        messages.append(newMessage)
        
        getLastMessageId()
    }
    
    // HomeView 안에서 마지막 메세지로 자동 스크롤 하기 위해 lastMessageId 얻는 함수
    func getLastMessageId() {
        if let id = self.messages.last?.id {
            self.lastMessageId = id
        }
    }
    
    func removeMessage(_ message: Message) {
        if let index = messages.firstIndex(where: { $0.id == message.id }) {
            messages.remove(at: index)
        }
    }
    
    func removeBtnTapped() {
        messages.removeAll { message in
            selectedMessages.contains(message)
        }
        selectedMessages.removeAll()
        isEditMessageMode = false
    }
    
    func setIsDisplayRemoveMessageAlert(_ isDisplay: Bool) {
        isDisplayRemoveNoteAlert = isDisplay
    }
    
    func navigationRightBtnTapped() {
        if isEditMessageMode {
            if selectedMessages.isEmpty {
                isEditMessageMode = false
            } else {
//                setIsDisplayRemoveMessageAlert(true)
                selectedMessages.removeAll()
                isEditMessageMode = false
            }
        } else {
            isEditMessageMode = true
        }
    }
    
    func messageSelectedBoxTapped(_ message: Message) {
        if let index = selectedMessages.firstIndex(of: message) {
            selectedMessages.remove(at: index)
        } else {
            selectedMessages.append(message)
        }
    }
}
