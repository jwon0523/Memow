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
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
                .environment(\.managedObjectContext, messageDataController.container.viewContext)
                .environmentObject(messageDataController)
        }
    }
}
