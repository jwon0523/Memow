//
//  NoteView.swift
//  Memow
//
//  Created by jaewon Lee on 3/22/24.
//

import SwiftUI

// 노트 horizontal 패딩 사이즈 상수 선언
private let noteHorizontalPaddingSize: CGFloat = 16

struct UpdateNoteData: Hashable {
    var title: String
    var content: String
}

struct NoteView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var noteListViewModel: NoteListViewModel
    @EnvironmentObject private var noteDataController: NoteDataController
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var noteViewModel: NoteViewModel
    @FocusState private var focusedField: Field?
    @State var isCreateMode: Bool = true
    @State private var isEditNote: Bool = false
    @State private var prevNoteTitle: String? = nil
    @State private var prevNoteContent: String? = nil
    @State private var updateNoteData: UpdateNoteData = UpdateNoteData(
        title: "", content: ""
    )
    
    enum Field: Hashable {
        case title
        case content
    }
    
    var body: some View {
        ZStack {
            VStack {
                 NoteTitleView(
                    noteViewModel: noteViewModel,
                    isCreateMode: $isCreateMode,
                    updateNotetitle: $updateNoteData.title
                 )
                 .padding(.top, 10)
                 .focused($focusedField, equals: .title)
                 .onSubmit {
                     focusedField = .content
                 }
                 .onChange(of: updateNoteData.title) { newNoteTitle in
                     if prevNoteTitle != newNoteTitle {
                         isEditNote = true
                     } else {
                         isEditNote = false
                     }
                 }
                
                 NoteContentInputView(
                    noteViewModel: noteViewModel,
                    updateNoteContent: $updateNoteData.content
                 )
                    .focused($focusedField, equals: .content)
                    .onChange(of: updateNoteData.content) { newNoteContent in
                        if prevNoteContent != newNoteContent {
                            isEditNote = true
                        } else {
                            isEditNote = false
                        }
                    }
            }
            .onAppear {
                self.updateNoteData.title = noteViewModel.note.title
                self.prevNoteTitle = noteViewModel.note.title
                self.updateNoteData.content = noteViewModel.note.content
                self.prevNoteContent = updateNoteData.content
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CustomNavigationBar(
                    rightBtnAction: {
                        if isCreateMode {
                            noteListViewModel.addNote(
                                id: noteViewModel.note.id,
                                title: updateNoteData.title,
                                content: updateNoteData.content,
                                date: noteViewModel.note.date,
                                noteDataController: noteDataController,
                                context: viewContext
                            )
                        } else {
                            noteListViewModel.updateNote(
                                id: noteViewModel.note.id,
                                updateTitle: updateNoteData.title,
                                updateContent: updateNoteData.content,
                                noteDataController: noteDataController,
                                context: viewContext
                            )
                            noteViewModel.note.title = updateNoteData.title
                            noteViewModel.note.content = updateNoteData.content
                        }
                        pathModel.paths.removeLast()
                    },
                    leftBtnType: .emptyBtn,
                    rightBtnType: isEditNote ? .complete : .emptyBtn
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
    @Binding private var updateNotetitle: String
    
    fileprivate init(
        noteViewModel: NoteViewModel,
        isCreateMode: Binding<Bool>,
        updateNotetitle: Binding<String>
    ) {
        self.noteViewModel = noteViewModel
        self._isCreateMode = isCreateMode
        self._updateNotetitle = updateNotetitle
    }
    
    fileprivate var body: some View {
        VStack {
            TextField(
                "제목을 입력하세요",
                text: $updateNotetitle
            )
            .customFontStyle(.title)
            .foregroundStyle(.colorPrimary)
            .focused($isTitleFieldFocused)
            .onAppear {
                if isCreateMode {
                    isTitleFieldFocused = true
                }
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, noteHorizontalPaddingSize)
    }
}

private struct NoteContentInputView: View {
    @ObservedObject private var noteViewModel: NoteViewModel
    @Binding var updateNoteContent: String
    
    fileprivate init(
        noteViewModel: NoteViewModel,
        updateNoteContent: Binding<String>
    ) {
        self.noteViewModel = noteViewModel
        self._updateNoteContent = updateNoteContent
    }
    
    fileprivate var body: some View {
        ZStack {
            TextEditor(text: $updateNoteContent)
            
            if noteViewModel.note.content.isEmpty {
                Text("메모를 입력하세요.")
                    .customFontStyle(.body)
                    .foregroundStyle(.customBorder)
                    .allowsHitTesting(false)
                    .padding(.top, 10)
                    .padding(.leading, 5)
            }
        }
        .padding(.horizontal, noteHorizontalPaddingSize - 4)
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
