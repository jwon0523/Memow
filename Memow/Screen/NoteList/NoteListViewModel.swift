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
    @Published var selectedNote: Set<Note>
    
    var navigationBarRightMode: NavigationBtnType {
        return isEditNoteMode ? .delete : .select
    }
    
    var removeNoteCount: Int {
        return selectedNote.count
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
        self.selectedNote = selectedNote
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
        _ note: Note,
        noteDataController: NoteDataController,
        context: NSManagedObjectContext
    ) {
        noteDataController.updateNoteData(
            id: note.id,
            updateTitle: note.title,
            updateContent: note.content,
            context: context
        )
    }
    
    // 메세지 노트로 옮김
    func addSelectedMessageToNote(
        selectedNotes: Set<Note>,
        selectedMessages: Set<MessageEntity>,
        noteDataController: NoteDataController,
        context: NSManagedObjectContext
    ) {
        for selectedNote in selectedNotes {
            var combinedContent = selectedNote.content
            for selectedMessage in selectedMessages.sorted(by: { $0.date! < $1.date! }) {
                if combinedContent == "" {
                    combinedContent = selectedMessage.content ?? ""
                } else {
                    combinedContent += "\n" + (selectedMessage.content ?? "")
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
    
    func removeNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes.remove(at: index)
        }
    }
    
    func setIsDisplayRemoveNoteAlert(_ isDisplay: Bool) {
        isDisplayRemoveNoteAlert = isDisplay
    }
    
    func noteRemoveSelectedBoxTapped(_ note: Note) {
        // 삭제 버튼 재클릭시 취소
        if selectedNote.contains(note) {
            selectedNote.remove(note)
        } else {
            selectedNote.insert(note)
        }
    }
    
    func removeBtnTapped() {
        // notes에서 removeNotes와 일치한 노트만 삭제
        notes.removeAll { note in
            selectedNote.contains(note)
        }
        
        // 삭제된 노트들은 removeNotes에서 삭제
        removeAllSelectedNote()
        isEditNoteMode = false
    }
    
    func navigationSelectBtnTapped() {
        if isEditNoteMode {
            // 삭제 모드시 삭제 버튼 눌렀을 때 removeNotes가 비어있으면 삭제모드 취소
            // removeNotes에 값이 있으면 setIsDisplayRemoveNoteAlert를 실행하여 알람 생성
            if selectedNote.isEmpty {
                isEditNoteMode = false
            } else {
                setIsDisplayRemoveNoteAlert(true)
            }
        } else {
            isEditNoteMode = true
        }
    }
    
    func removeAllSelectedNote() {
        selectedNote.removeAll()
    }
}
