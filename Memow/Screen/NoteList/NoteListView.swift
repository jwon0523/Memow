//
//  NoteListView.swift
//  Memow
//
//  Created by jaewon Lee on 3/18/24.
//

import SwiftUI

struct NoteListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var noteListViewModel: NoteListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            VStack {
                if(!homeViewModel.isShowNoteListModal) {
                    CustomNavigationBar(
                        leftBtnAction: {
                            if(!noteListViewModel.isEditNoteMode) {
                                pathModel.paths.removeLast()
                            }
                        },
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
                
                SearchBarView(text: $searchText)
                
                NoteListCellView()
                
            }
            .background(.customBackground)
            
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
                    noteListViewModel.removeBtnTapped()
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
        List(notes.map { $0.note }, id:\.id) { note in
            NoteContentView(note: note)
        }
        // 리스트 간격 벌려주는 속성
        .listRowSpacing(20)
    }
}

// MARK: - 노트 컨텐트 뷰
private struct NoteContentView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var noteListViewModel: NoteListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var isRemoveSelected: Bool
    private var note: Note
    
    fileprivate init(
        note: Note,
        isRemoveSelected: Bool = false
    ) {
        self.note = note
        self.isRemoveSelected = isRemoveSelected
    }
    
    
    // 모달창에서 노트리스트를 선택하면 숫자 꼬이는 버그 고치기
    fileprivate var body: some View {
        VStack {
            Button(action: {
                // 노트 리스트 편집 모드가 아니고 HomeView에서
                // 모달 뷰를 띄우지 않았을 때만 노트로 이동 가능
                if(!noteListViewModel.isEditNoteMode
                   && !homeViewModel.isShowNoteListModal) {
                    pathModel.paths.append(.noteView(
                        isCreateMode: false,
                        note: note
                    ))
                }
            }, label: {
                HStack(alignment:.top) {
                    // 리스트 수정 모드시 선택 버튼 활성
                    if noteListViewModel.isEditNoteMode
                        || homeViewModel.isShowNoteListModal {
                        Button(action: {
                            isRemoveSelected.toggle()
                            // 삭제 버튼 클릭시 해당 노트 noteListViewModel의 removeNotes에 추가
                            noteListViewModel.noteRemoveSelectedBoxTapped(note)
                        }, label: {
                            isRemoveSelected ?
                            Image("SelectedBox") : Image("unSelectedBox")
                        })
                        .padding(.vertical)
                        .padding(.horizontal, 5)
                    }
                    
                    VStack(alignment: .leading) {
                        Spacer()
                        
                        Text(note.title)
                            .lineLimit(1)
                            .font(.system(size: 16))
                            .foregroundColor(.customYellow)
                            .padding(.bottom, 8)
                        
                        Text(note.content)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .font(.system(size: 12))
                            .foregroundColor(.customFont)
                        
                        Spacer()
                    }
                    .frame(maxHeight: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
            })
        }
        .frame(minHeight: 50)
        // 스와이프 기능 추가
        .swipeActions {
            // 리스트 삭제
            Button(
                action: {
                    withAnimation {
                        noteListViewModel.removeNote(note)
                    }
                },
                label: {
                    Text("삭제")
                        .foregroundColor(.customWhite)
                })
            .tint(.red)
        }
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
                            .foregroundColor(.customYellow)
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
                        selectedNotes: noteListViewModel.selectedNote,
                        selectedMessages: homeViewModel.selectedMessages,
                        noteDataController: noteDataController,
                        context: viewContext
                    )
                    homeViewModel.toggleNoteListModal()
                    homeViewModel.toggleEditMessageMode()
                }, label: {
                    Text("Move text to selected Note")
                        .foregroundStyle(.customFont)
                        .frame(width: 250)
                        .padding()
                        .background(.customBackground)
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
