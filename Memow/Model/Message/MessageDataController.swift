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
    
    init() {
        container = NSPersistentContainer(name: "MessageEntity")
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
    func addMessage(content: String) {
        let newMessage = MessageEntity(context: context)
        newMessage.id = UUID()
        newMessage.content = content
        newMessage.date = Date()
        
        saveContext()
    }
    
    func saveContext() {
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
        let context = MessageDataController.shared.context
        let fetchRequest = NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
        
        do {
            let messages = try context.fetch(fetchRequest)
            return messages
        } catch {
            print("Failed to fetch messages: \(error)")
            return nil
        }
    }
}
