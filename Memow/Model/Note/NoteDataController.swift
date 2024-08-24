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
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "NoteEntity")
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

extension NoteDataController {
    func addNoteData(
        id: UUID,
        title: String,
        content: String,
        date: Date,
        context: NSManagedObjectContext? = nil
    ) {
        let context = context ?? self.context
        let newNote = NoteEntity(context: context)
        newNote.id = id
        newNote.title = title
        newNote.content = content
        newNote.date = date
        
        saveContext(context: context)
    }
    
    func updateNoteData(
        id: UUID,
        updateTitle: String,
        updateContent: String,
        context: NSManagedObjectContext? = nil
    ) {
        let context = context ?? self.context
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let notes = try context.fetch(fetchRequest)
            if let noteToUpdate = notes.first {
                noteToUpdate.title = updateTitle
                noteToUpdate.content = updateContent
                
                saveContext(context: context)
            } else {
                print("No note found with the specified ID.")
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func deleteNoteData(
        noteId: UUID,
        context: NSManagedObjectContext? = nil
    ) {
        let context = context ?? self.context
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", noteId as CVarArg)
        
        do {
            let noteEntities = try context.fetch(fetchRequest)
            for noteEntity in noteEntities {
                context.delete(noteEntity)
            }
            try context.save()
        } catch {
            print("Failed to delete note: \(error)")
        }
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
}

// preview에 sampleMessage 추가
extension NoteDataController {
    static var preview: NoteDataController = {
        let result = NoteDataController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newNote = NoteEntity(context: viewContext)
            newNote.id = UUID()
            newNote.title = "Sample Note"
            newNote.content = "This is a sample content for the note."
            newNote.date = Date()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
