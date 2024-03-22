//
//  NoteViewModel.swift
//  Memow
//
//  Created by jaewon Lee on 3/22/24.
//

import Foundation

class NoteViewModel: ObservableObject {
    @Published var note: Note
    
    init(note: Note) {
        self.note = note
    }
}
