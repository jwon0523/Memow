//
//  HomeViewModel.swift
//  Memow
//
//  Created by jaewon Lee on 3/17/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var messages: [Message]
    
    init(messages: [Message] = []) {
        self.messages = messages
    }
}

// 함수 기능 추가
extension HomeViewModel {
    func sendMessage(_ message: Message) {
        messages.append(message)
    }
}
