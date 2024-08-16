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
    @Published var selectedAlarmMessage: Notification
    
    var navigationBarRightMode: NavigationBtnType {
        return isEditMessageMode ? .close : .select
    }

    init(
        messages: [MessageEntity] = [],
        removeMessages: [MessageEntity] = [],
        isEditMessageMode: Bool = false,
        isDisplayRemoveNoteAlert: Bool = false,
        selectedMessages: Set<MessageEntity> = [],
        isShowNoteListModal: Bool = false,
        isShowDatePickerModal: Bool = false,
        isMessageToNoteSipped: Bool = false,
        selectedAlarmMessage: Notification = Notification(id: UUID(), content: "")
    ) {
        self.messages = messages
        self.removeMessages = removeMessages
        self.isEditMessageMode = isEditMessageMode
        self.isDisplayRemoveNoteAlert = isDisplayRemoveNoteAlert
        self.selectedMessages = selectedMessages
        self.isShowNoteListModal = isShowNoteListModal
        self.isShowDatePickerModal = isShowDatePickerModal
        self.isMessageToNoteSipped = isMessageToNoteSipped
        self.selectedAlarmMessage = selectedAlarmMessage
    }
}

// 함수 기능 추가
extension HomeViewModel {
    func setLastMessageId(lastMessageId id: UUID) {
        self.lastMessageId = id
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
    
    func selectedMessageAlarmBtnTapped(for message: MessageEntity) {
        isShowDatePickerModal = true
        selectedAlarmMessage = Notification(id: message.id!, content: message.content!)
    }
    
    func scheduleNotificationBtnTapped(
        for date: Date,
        using notificationManager: NotificationManager
    ) {
        notificationManager.createScheduledNotification(
            date: date,
            subtitle: selectedAlarmMessage.content
        )
        isShowDatePickerModal.toggle()
    }
    
    func toggleMessageIsAlarmSet(
        using messageDataController: MessageDataController,
        in context: NSManagedObjectContext? = nil
    ) {
        messageDataController.setMessageAlarm(
            for: selectedAlarmMessage.id,
            to: true,
            in: context
        )
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
}
