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
    
    var body: some View {
        ZStack {
            VStack {
                CustomNavigationBar(
                    rightBtnAction: {
                        pathModel.paths.removeLast()
                    }, 
                    leftBtnType: .notes,
                    rightBtnType: .home
                )
                
                // NoteSearchView
                
                NoteListCellView()
                
            }
            
            WriteNoteBtnView()
                .padding(.trailing, 20)
                .padding(.bottom, 30)
        }
    }
}

// MARK: - 노트 검색 뷰
private struct NoteSearchView: View {
    fileprivate var body: some View {
        HStack {
            Text("Search")
        }
    }
}

// MARK: - 노트 리스트 셀 뷰
private struct NoteListCellView: View {
    @EnvironmentObject private var noteListViewModel: NoteListViewModel
    
    fileprivate var body: some View {
        List {
            ForEach(noteListViewModel.notes, id:\.id) { note in
                NoteContentView(note: note)
            }
        }
        // 리스트 간격 벌려주는 속성
        .listRowSpacing(20)
        
    }
}

// MARK: - 노트 컨텐트 뷰
private struct NoteContentView: View {
    @EnvironmentObject private var pathModel: PathModel
    private var note: Note
    
    fileprivate init(note: Note) {
        self.note = note
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
                    VStack(alignment: .leading) {
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
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            })
        }
        .frame(minHeight: 50)
        // 스와이프 기능 추가
        .swipeActions {
            Button(
                action: {
                    // 삭제 기능 추가 필요
                    print("Delete")
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
