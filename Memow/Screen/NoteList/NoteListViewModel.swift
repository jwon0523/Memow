//
//  NoteListViewModel.swift
//  Memow
//
//  Created by jaewon Lee on 3/18/24.
//

import Foundation
import CoreData

class NoteListViewModel: ObservableObject {
    @Published var notes: [Note]
    @Published var isEditNoteMode: Bool
    @Published var isDisplayRemoveNoteAlert: Bool
    @Published var selectedNotes: Set<Note>
    
    var navigationBarRightMode: NavigationBtnType {
        return isEditNoteMode ? .delete : .select
    }
    
    var removeNoteCount: Int {
        return selectedNotes.count
    }
    
    init(
        // notes의 값은 테스트를 위한 것이므로 테스트 종료 후 빈 배열로 되돌려놓기
        notes: [Note] = [],
        isEditNoteMode: Bool = false,
//        removeNotes: [Note] = [],
        isDisplayRemoveNoteAlert: Bool = false,
        selectedNote: Set<Note> = []
    ) {
        self.notes = notes
        self.isEditNoteMode = isEditNoteMode
//        self.removeNotes = removeNotes
        self.isDisplayRemoveNoteAlert = isDisplayRemoveNoteAlert
        self.selectedNotes = selectedNote
    }
}

extension NoteListViewModel {
    func addNote(
        _ note: Note,
        noteDataController: NoteDataController,
        context: NSManagedObjectContext
    ) {
        noteDataController.addNoteData(note: note, context: context)
    }
    
    func updateNote(
        id: UUID,
        updateTitle: String,
        updateContent: String,
        noteDataController: NoteDataController,
        context: NSManagedObjectContext
    ) {
        noteDataController.updateNoteData(
            id: id,
            updateTitle: updateTitle,
            updateContent: updateContent,
            context: context
        )
    }
    
    func addSelectedMessageToNote(
        selectedNotes: Set<Note>,
        selectedMessages: Set<MessageEntity>,
        noteDataController: NoteDataController,
        context: NSManagedObjectContext
    ) {
        for selectedNote in selectedNotes {
            var combinedContent = selectedNote.content
            for selectedMessage in selectedMessages.sorted(by: {
                if let date1 = $0.date, let date2 = $1.date {
                    return date1 < date2
                }
                return false
            }) {
                if combinedContent == "" {
                    if let content = selectedMessage.content {
                        combinedContent = content
                    }
                } else {
                    if let content = selectedMessage.content {
                        combinedContent += "\n" + content
                    }
                }
            }
            noteDataController.updateNoteData(
                id: selectedNote.id,
                updateTitle: selectedNote.title,
                updateContent: combinedContent,
                context: context
            )
        }
    }
    
    func swipeRemoveNote(
        note: Note,
        noteDataController: NoteDataController,
        context: NSManagedObjectContext? = nil
    ) {
        noteDataController.deleteNoteData(
            noteId: note.id,
            context: context
        )
    }
    
    func setIsDisplayRemoveNoteAlert(_ isDisplay: Bool) {
        isDisplayRemoveNoteAlert = isDisplay
    }
    
    func noteRemoveSelectedBoxTapped(_ note: Note) {
        // 삭제 버튼 재클릭시 취소
        if selectedNotes.contains(note) {
            selectedNotes.remove(note)
        } else {
            selectedNotes.insert(note)
        }
    }
    
    func removeBtnTapped(
        noteDataController: NoteDataController,
        context: NSManagedObjectContext? = nil
    ) {
        for note in selectedNotes {
            noteDataController.deleteNoteData(
                noteId: note.id,
                context: context
            )
        }
        
        // 삭제된 노트들은 removeNotes에서 삭제
        removeAllSelectedNote()
        isEditNoteMode = false
    }
    
    func navigationSelectBtnTapped() {
        if isEditNoteMode {
            // 삭제 모드시 삭제 버튼 눌렀을 때 removeNotes가 비어있으면 삭제모드 취소
            // removeNotes에 값이 있으면 setIsDisplayRemoveNoteAlert를 실행하여 알람 생성
            if selectedNotes.isEmpty {
                isEditNoteMode = false
            } else {
                setIsDisplayRemoveNoteAlert(true)
            }
        } else {
            isEditNoteMode = true
        }
    }
    
    func removeAllSelectedNote() {
        selectedNotes.removeAll()
    }
}
