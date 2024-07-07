//
//  MemowApp.swift
//  Memow
//
//  Created by jaewon Lee on 3/15/24.
//

import SwiftUI

@main
struct MemowApp: App {
    let messageDataController = MessageDataController.shared
    let noteDataController = NoteDataController.shared
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
                .environmentObject(messageDataController)
                .environmentObject(noteDataController)
        }
    }
}
