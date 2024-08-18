//
//  NoteView.swift
//  Memow
//
//  Created by jaewon Lee on 3/22/24.
//

import SwiftUI

// 노트 horizontal 패딩 사이즈 상수 선언
private let noteHorizontalPaddingSize: CGFloat = 20

struct NoteView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var noteListViewModel: NoteListViewModel
    @EnvironmentObject private var noteDataController: NoteDataController
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var noteViewModel: NoteViewModel
    @State var isCreateMode: Bool = true
    
    var body: some View {
        ZStack {
            VStack {
                 NoteTitleView(
                    noteViewModel: noteViewModel,
                    isCreateMode: $isCreateMode
                 )
                 .padding(.top, 10)
                
                 NoteContentInputView(noteViewModel: noteViewModel)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CustomNavigationBar(
                    rightBtnAction: {
                        if isCreateMode {
                            noteListViewModel.addNote(
                                noteViewModel.note,
                                noteDataController: noteDataController,
                                context: viewContext
                            )
                        } else {
                            noteListViewModel.updateNote(
                                id: noteViewModel.note.id,
                                updateTitle: noteViewModel.note.title,
                                updateContent: noteViewModel.note.content,
                                noteDataController: noteDataController,
                                context: viewContext
                            )
                        }
                        pathModel.paths.removeLast()
                    },
                    leftBtnType: .emptyBtn,
                    rightBtnType: isCreateMode ? .complete : .update
                )
            }
        }
    }
}

// MARK: - 메모 제목 입력 뷰
private struct NoteTitleView: View {
    @ObservedObject private var noteViewModel: NoteViewModel
    @FocusState private var isTitleFieldFocused: Bool
    @Binding private var isCreateMode: Bool
    
    fileprivate init(
        noteViewModel: NoteViewModel,
        isCreateMode: Binding<Bool>
    ) {
        self.noteViewModel = noteViewModel
        self._isCreateMode = isCreateMode
    }
    
    fileprivate var body: some View {
        TextField(
            "제목을 입력하세요",
            text: $noteViewModel.note.title
        )
        .font(.system(size: 25))
        .padding(.horizontal, noteHorizontalPaddingSize)
        .focused($isTitleFieldFocused)
        .onAppear {
            if isCreateMode {
                isTitleFieldFocused = true
            }
        }
    }
}

private struct NoteContentInputView: View {
    @ObservedObject private var noteViewModel: NoteViewModel
    
    fileprivate init(noteViewModel: NoteViewModel) {
        self.noteViewModel = noteViewModel
    }
    
    fileprivate var body: some View {
        ZStack {
            TextEditor(text: $noteViewModel.note.content)
            
            if noteViewModel.note.content.isEmpty {
                Text("메모를 입력하세요.")
                    .font(.system(size: 16))
                    .foregroundColor(.customBorder)
                    .allowsHitTesting(false)
                    .padding(.top, 10)
                    .padding(.leading, 5)
            }
        }
        .padding(.horizontal, noteHorizontalPaddingSize)
    }
}

#Preview {
    NoteView(
        noteViewModel: .init(
            note: .init(
                title: "",
                content: "",
                date: Date()
            )
        )
    )
}
