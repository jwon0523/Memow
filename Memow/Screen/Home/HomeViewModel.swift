//
//  HomeViewModel.swift
//  Memow
//
//  Created by jaewon Lee on 3/17/24.
//

import Foundation
import CoreData

class HomeViewModel: ObservableObject {
    @Published private(set) var lastMessageId: UUID?
    @Published var messages: [MessageEntity]
    @Published var removeMessages: [MessageEntity]
    @Published var isEditMessageMode: Bool
    @Published var isDisplayRemoveNoteAlert: Bool
    @Published var selectedMessages: Set<MessageEntity>
    @Published var isShowNoteListModal: Bool
    @Published var isShowDatePickerModal: Bool
    @Published var isMessageToNoteSipped: Bool
    @Published var selectedAlarmDate: Date
    @Published var selectedAlarmMessage: String
    
    var navigationBarRightMode: NavigationBtnType {
        return isEditMessageMode ? .close : .select
    }
    
    // 앱 실행시 빈 배열로 messages 배열 초기화
    // 추후 로컬이나 서버 DB에서 메세지를 받아올 예정
    init(
        messages: [MessageEntity] = [],
        removeMessages: [MessageEntity] = [],
        isEditMessageMode: Bool = false,
        isDisplayRemoveNoteAlert: Bool = false,
        selectedMessages: Set<MessageEntity> = [],
        isShowNoteListModal: Bool = false,
        isShowDatePickerModal: Bool = false,
        isMessageToNoteSipped: Bool = false,
        selectedAlarmDate: Date = Date(),
        selectedAlarmMessage: String = ""
    ) {
        self.messages = messages
        self.removeMessages = removeMessages
        self.isEditMessageMode = isEditMessageMode
        self.isDisplayRemoveNoteAlert = isDisplayRemoveNoteAlert
        self.selectedMessages = selectedMessages
        self.isShowNoteListModal = isShowNoteListModal
        self.isShowDatePickerModal = isShowDatePickerModal
        self.isMessageToNoteSipped = isMessageToNoteSipped
        self.selectedAlarmDate = selectedAlarmDate
        self.selectedAlarmMessage = selectedAlarmMessage
    }
}

// 함수 기능 추가
extension HomeViewModel {
    // HomeView 안에서 마지막 메세지로 자동 스크롤 하기 위해 lastMessageId 얻는 함수
    func getLastMessageId() {
        if let id = self.messages.last?.id {
            self.lastMessageId = id
        }
    }
    
    func removeMessage(_ message: MessageEntity) {
        if let index = messages.firstIndex(where: { $0.id == message.id }) {
            messages.remove(at: index)
        }
    }
    
    func removeBtnTapped(
        messageDataController: MessageDataController,
        context: NSManagedObjectContext? = nil
    ) {
        for message in selectedMessages {
            messageDataController.deleteMessage(message, context: context)
        }
    }
    
    func setIsDisplayRemoveMessageAlert(_ isDisplay: Bool) {
        isDisplayRemoveNoteAlert = isDisplay
    }
    
    func toggleEditMessageMode() {
        // 메시지 수정 모드이거나 스와이핑을 통한 메시지를 선택한 경우 true
        if isEditMessageMode || isMessageToNoteSipped {
            if selectedMessages.isEmpty {
                isEditMessageMode = false
            } else {
                //                setIsDisplayRemoveMessageAlert(true)
                // close(x) 버튼을 누르면 선택된 내용들 모두 삭제하고 편집 모드 종료
                selectedMessages.removeAll()
                isEditMessageMode = false
                isMessageToNoteSipped = false
            }
        } else {
            isEditMessageMode = true
        }
    }
    
    func toggleNoteListModal() {
        // 메시지 수정 모드이거나 스와이핑을 통한 메시지를 선택한 경우 true
        if isEditMessageMode || isMessageToNoteSipped {
            if(isShowNoteListModal) {
                isShowNoteListModal = false
            } else {
                isShowNoteListModal = true
            }
        }
    }
    
    // 메세지의 id값이 들어왔을 때 selectedMessages에 같은 값이 있으면
    // 삭제하면서 선택 취소하고, 없다면 Set배열에 넣어주면서 선택 체크
    func messageSelectedBoxTapped(_ message: MessageEntity) {
        if selectedMessages.contains(message) {
            selectedMessages.remove(message)
        } else {
            selectedMessages.insert(message)
        }
    }
    
    func messageToNoteSwipingTapped() {
        isMessageToNoteSipped = true
        isShowNoteListModal = true
    }
    
    func selectedMessageAlarmBtnTapped(message: MessageEntity) {
        isShowDatePickerModal = true
        selectedAlarmMessage = message.content!
    }
    
    func groupMessagesByDate(messages: [MessageEntity]) -> [DateComponents: [MessageEntity]] {
        var groupedMessages = [DateComponents: [MessageEntity]]()
        for message in messages {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: message.date!)
            if groupedMessages[components] == nil {
                groupedMessages[components] = [MessageEntity]()
            }
            groupedMessages[components]?.append(message)
        }
        return groupedMessages
    }
    
    func formattedDateComponents(_ dateComponents: DateComponents) -> String {
        let year = dateComponents.year ?? 0
        let month = String(format: "%02d", dateComponents.month ?? 0)
        let day = String(format: "%02d", dateComponents.day ?? 0)
        return "\(year)년 \(month)월 \(day)일"
    }
}
