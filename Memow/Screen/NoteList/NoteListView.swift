//
//  NoteListView.swift
//  Memow
//
//  Created by jaewon Lee on 3/18/24.
//

import SwiftUI

private let screenWidth: CGFloat = UIScreen.main.bounds.size.width

struct NoteListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var noteListViewModel: NoteListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var noteDataController: NoteDataController
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            VStack {
                if(!homeViewModel.isShowNoteListModal) {
                    CustomNavigationBar(
                        rightBtnAction: {
                            // 버튼 선택시 리스트 왼쪽 다중 선택 활성화
                            withAnimation {
                                noteListViewModel.navigationSelectBtnTapped()
                            }
                        },
                        leftBtnType: .memow,
                        // 버튼 클릭할 때마다 선택 이미지와 삭제 전환
                        rightBtnType: noteListViewModel.navigationBarRightMode
                    )
                } else {
                    CustomNavigationBar(
                        rightBtnAction: {
                            // 버튼 선택시 리스트 왼쪽 다중 선택 활성화
                            withAnimation {
                                homeViewModel.toggleNoteListModal()
                            }
                        },
                        leftBtnType: .memow,
                        // 버튼 클릭할 때마다 선택 이미지와 삭제 전환
                        rightBtnType: .close
                    )
                }
                
                // 검색 기능 구현 전까지 비활성화
//                SearchBarView(text: $searchText)
                
                NoteListCellView()
                
            }
            .background(Color.backgroundDefault)
            
            if(homeViewModel.isShowNoteListModal) {
                MoveMessageToNoteListBtnView()
                    .padding(.trailing)
                    .padding(.bottom)
                
            } else {
                WriteNoteBtnView()
                    .padding(.trailing, 20)
                    .padding(.bottom, 30)
            }
        }
        // 오른쪽 네비게이션바 삭제 버튼 클릭시 실행
        .alert(
            "메모 \(noteListViewModel.removeNoteCount)개 삭제하시겠습니까?",
            isPresented: $noteListViewModel.isDisplayRemoveNoteAlert
        ) {
            Button("삭제", role: .destructive) {
                withAnimation {
                    noteListViewModel.removeBtnTapped(
                        noteDataController: noteDataController,
                        context: viewContext
                    )
                }
            }
            
            Button("취소", role: .cancel) {  }
        }
    }
}

// MARK: - 노트 검색 뷰
private struct SearchBarView: View {
    @Binding var text: String
    @State private var isEditing = false
    @FocusState private var isSearchBarFocused: Bool

    fileprivate var body: some View {
        HStack {
            TextField("Search..", text: $text)
                .padding(7)
                .padding(.horizontal, 10)
                .background(.customBorder)
                .cornerRadius(8)
                .padding(.horizontal, 15)
                .focused($isSearchBarFocused)
                .onTapGesture {
                    withAnimation {
                        self.isEditing = true
                        self.isSearchBarFocused = true
                    }
                }

            // 검색 바 터치하면 오른쪽에 취소 버튼 생성
            if isEditing {
                Button(action: {
                    withAnimation {
                        self.isEditing = false
                        self.text = ""
                        self.isSearchBarFocused = false
                    }
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
    }
}

// MARK: - 노트 리스트 셀 뷰
private struct NoteListCellView: View {
    @EnvironmentObject private var noteListViewModel: NoteListViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: NoteEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \NoteEntity.date, ascending: true)
        ],
        animation: .default
    ) private var notes: FetchedResults<NoteEntity>
    
    fileprivate var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(notes.map { $0.note }, id: \.id) { note in
                    NoteRowView(note: note)
                }
            }
        }
    }
}

// MARK: - 노트 리스트 로우 뷰
private struct NoteRowView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var noteListViewModel: NoteListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var noteDataController: NoteDataController
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var note: Note
    @State private var isRemoveSelected: Bool = false
    
    var body: some View {
        HStack {
            if noteListViewModel.isEditNoteMode
                || homeViewModel.isShowNoteListModal {
                Button(action: {
                    isRemoveSelected.toggle()
                    // 삭제 버튼 클릭시 해당 노트 noteListViewModel의 removeNotes에 추가
                    noteListViewModel.noteRemoveSelectedBoxTapped(note)
                }, label: {
                    isRemoveSelected ?
                    Image("NoteSelectedBtn") : Image("NoteUnSelectedBtn")
                })
                .padding(.horizontal, 16)
            }
            
            NoteContentView(note: note)
                .onTapGesture {
                    if(!noteListViewModel.isEditNoteMode
                       && !homeViewModel.isShowNoteListModal) {
                        pathModel.paths.append(.noteView(
                            isCreateMode: false,
                            note: note
                        ))
                    }
                }
            
            if note.isSwiped && !noteListViewModel.isEditNoteMode {
                Button(action: {
                    withAnimation {
                        noteListViewModel.swipeRemoveNote(
                            note: note,
                            noteDataController: noteDataController,
                            context: viewContext
                        )
                    }
                }) {
                    Text("Delete")
                        .customFontStyle(.body)
                        .foregroundColor(.red)
                        .padding(.vertical, 26)
                        .padding(.horizontal, 20)
                        .background(Color.backgorundBtn)
                        .cornerRadius(24)
                }
                .transition(.move(edge: .trailing)) // 부드러운 등장 효과
                .animation(.easeInOut(duration: 0.25), value: note.isSwiped)
            }
        }
        .contentShape(Rectangle())
        .offset(x: 0)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    guard !noteListViewModel.isEditNoteMode else { return }
                    
                    if gesture.translation.width < -30 && !note.isSwiped {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            note.offset = -10
                            note.isSwiped = true
                        }
                    } else if gesture.translation.width > 30 && note.isSwiped {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            note.offset = 0
                            note.isSwiped = false
                        }
                    }
                }
                .onEnded { _ in
                    if !note.isSwiped {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            note.offset = 0
                        }
                    }
                }
        )
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
}

// MARK: - 노트 컨텐트 뷰
private struct NoteContentView: View {
    @ObservedObject var note: Note

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(note.title)
                    .customFontStyle(.body)
                    .lineLimit(1)
                    .foregroundColor(.colorPrimary)
                
                Spacer().frame(height: 8)
                
                Text(note.content)
                    .customFontStyle(.body)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .foregroundColor(.labelDisable)
            }
            .frame(height: 78, alignment: .leading)
            .padding(.leading, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: 78, alignment: .leading)
        .background(Color.backgroundComponent)
        .cornerRadius(24)
    }
}

// MARK: - 노트 작성 버튼 뷰
private struct WriteNoteBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(
                    action: {
                        pathModel.paths.append(.noteView(isCreateMode: true, note: nil))
                    },
                    label: {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.colorPrimary)
                    }
                )
            }
        }
    }
}

// MARK: - 모달 뷰에서 보여줄 메세지 이동 버튼 뷰
private struct MoveMessageToNoteListBtnView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var noteListViewModel: NoteListViewModel
    @EnvironmentObject private var noteDataController: NoteDataController
    @Environment(\.managedObjectContext) private var viewContext
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    noteListViewModel.addSelectedMessageToNote(
                        selectedNotes: noteListViewModel.selectedNotes,
                        selectedMessages: homeViewModel.selectedMessages,
                        noteDataController: noteDataController,
                        context: viewContext
                    )
                    homeViewModel.toggleNoteListModal()
                    homeViewModel.toggleEditMessageMode()
                }, label: {
                    Text("Move text to selected Note")
                        .customFontStyle(.body)
                        .foregroundStyle(.customFont)
                        .frame(width: 250)
                        .padding()
                        .background(.backgorundBtn)
                        .cornerRadius(20)
                })
            }
        }
    }
}

#Preview {
    let context = NoteDataController.preview.container.viewContext
    
    for _ in 0..<10 {
        let newNote = NoteEntity(context: context)
        newNote.id = UUID()
        newNote.title = "Sample Note"
        newNote.content = "This is a sample content for the note."
        newNote.date = Date()
    }
    
    return Group {
        NoteListView()
            .environment(\.managedObjectContext, context)
            .environmentObject(PathModel())
            .environmentObject(HomeViewModel())
            .environmentObject(NoteListViewModel())
    }
}
