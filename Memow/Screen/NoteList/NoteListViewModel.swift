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
    @Published var removeNotes: [Note]
    @Published var isDisplayRemoveNoteAlert: Bool
    
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
                content: "메모장을 만들어 보자!메모장을 만들어 보자!메모장을 만들어 보자!메모장을 만들어 보자!",
                date: Date()
            ),
        ],
        isEditNoteMode: Bool = false,
        removeNotes: [Note] = [],
        isDisplayRemoveNoteAlert: Bool = false
    ) {
        self.notes = notes
        self.isEditNoteMode = isEditNoteMode
        self.removeNotes = removeNotes
        self.isDisplayRemoveNoteAlert = isDisplayRemoveNoteAlert
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
        if let index = removeNotes.firstIndex(where: { $0.id == note.id }) {
            removeNotes.remove(at: index)
        } else {
            removeNotes.append(note)
        }
    }
    
    func removeBtnTapped() {
        // notes에서 removeNotes와 일치한 노트만 삭제
        notes.removeAll { note in
            removeNotes.contains(note)
        }
        
        // 삭제된 노트들은 removeNotes에서 삭제
        removeNotes.removeAll()
        isEditNoteMode = false
    }
}
