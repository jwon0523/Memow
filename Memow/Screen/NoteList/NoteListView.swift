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
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            VStack {
                CustomNavigationBar(
                    leftBtnAction: {
                        pathModel.paths.removeLast()
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
                
                SearchBarView(text: $searchText)
                
                NoteListCellView()
                
            }
            .background(.customBackground)
            
            WriteNoteBtnView()
                .padding(.trailing, 20)
                .padding(.bottom, 30)
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
    
    fileprivate var body: some View {
        List(noteListViewModel.notes, id:\.id) { note in
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
    @State private var isRemoveSelected: Bool
    private var note: Note
    
    fileprivate init(
        note: Note,
        isRemoveSelected: Bool = false
    ) {
        self.note = note
        self.isRemoveSelected = isRemoveSelected
    }
    
    fileprivate var body: some View {
        VStack {
            Button(action: {
                pathModel.paths.append(.noteView(
                    isCreateMode: false,
                    note: note
                ))
            }, label: {
                HStack(alignment:.top) {
                    // 메모 선택 버튼 클릭시 활성
                    if noteListViewModel.isEditNoteMode {
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

#Preview {
    NoteListView()
        .environmentObject(NoteListViewModel())
        .environmentObject(PathModel())
}
