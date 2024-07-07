//
//  NoteDataController.swift
//  Memow
//
//  Created by jaewon Lee on 7/7/24.
//

import Foundation
import CoreData

class NoteDataController: ObservableObject {
    static let shared = NoteDataController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "NoteEntity")
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

extension NoteDataController {
    func addNote(
        note: Note,
        context: NSManagedObjectContext? = nil
    ) {
        let context = context ?? self.context
        let newNote = NoteEntity(context: context)
        newNote.id = note.id
        newNote.title = note.title
        newNote.content = note.content
        newNote.date = note.date
        
        saveContext(context: context)
    }
    
    func deleteMessage(
        _ note: NoteEntity,
        context: NSManagedObjectContext? = nil
    ) {
        let context = context ?? self.context
        context.delete(note)
        
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
    
    // 모든 데이터를 삭제하는 함수
    func deleteAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NoteEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.viewContext.execute(deleteRequest)
            saveContext(context: container.viewContext)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func sampleNoteData() {
        let note = Note(
            title: "생각의 플로우",
            content: "메모장을 만들어 보자!메모장을 만들어 보자!메모장을 만들어 보자!메모장을 만들어 보자!",
            date: Date()
        )
        addNote(note: note)
    }
    
    func initializePreviewData() {
        sampleNoteData()
        deleteAllData()
    }
}

// preview에 sampleMessage 추가
extension NoteDataController {
    static var preview: NoteDataController = {
        let controller = NoteDataController()
        controller.initializePreviewData()
        return controller
    }()
}

