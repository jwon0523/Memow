//
//  NoteListViewModel.swift
//  Memow
//
//  Created by jaewon Lee on 3/18/24.
//

import Foundation

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
        notes: [Note] = [
            Note(
                title: "생각의 플로우",
                content: "메모장을 만들어 보자!메모장을 만들어 보자!메모장을 만들어 보자!메모장을 만들어 보자!",
                date: Date()
            ),
            Note(
                title: "생각의 플로우",
                content: "메모장을 만들어 보자!메모장을 만들어 보자!메모장을 만들어 보자!메모장을 만들어 보자!",
                date: Date()
            ),
            Note(
                title: "생각의 플로우",
                content: "메모장을 만들어 보자!메모장을 만들어 보자!메모장을 만들어 보자!메모장을 만들어 보자!",
                date: Date()
            ),Note(
                title: "생각의 플로우",
                content: "메모장을 만들어 보자!",
                date: Date()
            ),
        ],
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
    func addNote(_ note: Note) {
        notes.append(note)
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
        }
    }
    
    // 메세지 노트로 옮김
    func addSelectedMessageToNote(
        selectedNotes: Set<Note>,
        selectedMessages: Set<Message>
    ) {
        for selectedNote in selectedNotes {
            for selectedMessage in selectedMessages {
                if let index = notes.firstIndex(where: { $0.id == selectedNote.id }) {
                    notes[index].content += "\n" + selectedMessage.content
                }
            }
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
