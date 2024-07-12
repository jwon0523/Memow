//
//  MessageDataController.swift
//  Memow
//
//  Created by jaewon Lee on 6/29/24.
//

import Foundation
import CoreData

class MessageDataController: ObservableObject {
    static let shared = MessageDataController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MessageEntity")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
}

extension MessageDataController {
    func addMessage(content: String, context: NSManagedObjectContext? = nil) {
        let context = context ?? self.context
        let newMessage = MessageEntity(context: context)
        newMessage.id = UUID()
        newMessage.content = content
        newMessage.date = Date()
        
        saveContext(context: context)
    }
    
    func deleteMessage(_ message: MessageEntity, context: NSManagedObjectContext? = nil) {
        let context = context ?? self.context
        context.delete(message)
        
        saveContext(context: context)
    }
    
    private func saveContext(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchMessages() -> [MessageEntity]? {
        let context = self.context
        let fetchRequest = NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
        
        do {
            let messages = try context.fetch(fetchRequest)
            return messages
        } catch {
            print("Failed to fetch messages: \(error)")
            return nil
        }
    }
    
    func sampleMessageData() {
        addMessage(content: "Hello, World!")
        addMessage(content: "I'm just developing")
        addMessage(content: "Please I need your help🙂")
        saveContext(context: context)
    }
    
    // 모든 데이터를 삭제하는 함수
    func deleteAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MessageEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.viewContext.execute(deleteRequest)
            saveContext(context: container.viewContext)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func initializePreviewData() {
        deleteAllData()
        sampleMessageData()
    }
}

// preview에 sampleMessage 추가
extension MessageDataController {
    static var preview: MessageDataController = {
        let controller = MessageDataController(inMemory: true)
        controller.initializePreviewData()
        return controller
    }()
}
