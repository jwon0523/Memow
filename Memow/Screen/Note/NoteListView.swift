//
//  NoteListView.swift
//  Memow
//
//  Created by jaewon Lee on 3/18/24.
//

import SwiftUI

struct NoteListView: View {
    @StateObject private var noteListViewModel = NoteListViewModel()
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                leftBtnType: .notes
                // 오른쪽 버튼 액션 추가 필요
            )
            
            // NoteSearchView
            
            NoteListCellView(noteListViewModel: noteListViewModel)
            
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
    @ObservedObject private var noteListViewModel: NoteListViewModel
    
    fileprivate init(
        noteListViewModel: NoteListViewModel
    ) {
        self.noteListViewModel = noteListViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    ForEach(noteListViewModel.notes, id:\.id) { note in
                        NoteContentView(note: note)
                    }
                }
            }
        }
    }
}

// MARK: - 노트 컨텐트 뷰
private struct NoteContentView: View {
    private var note: Note
    
    fileprivate init(note: Note) {
        self.note = note
    }
    
    fileprivate var body: some View {
        Button(
            action: {
                print("Print")
            },
            label: {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(note.title)
                                .lineLimit(1)
                                .font(.system(size: 16))
                                .foregroundColor(.customYellow)
                                .padding(.bottom,8)
                            
                            
                            Text(note.content)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                                .font(.system(size: 12))
                                .foregroundColor(.customFont)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .frame(minHeight: 84)
                    .background(.customWhite)
                    .cornerRadius(10)
                    .shadow(radius: 1, y: 0.5)
                }
                .frame(maxWidth: .infinity)
                .padding()
            })
    }
}

#Preview {
    NoteListView()
}
