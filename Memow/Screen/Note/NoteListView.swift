//
//  NoteListView.swift
//  Memow
//
//  Created by jaewon Lee on 3/18/24.
//

import SwiftUI

struct NoteListView: View {
    var body: some View {
        VStack {
            CustomNavigationBar(
                leftBtnType: .notes
                // 오른쪽 버튼 액션 추가 필요
            )
            
            // NoteSearchView
            
            // NoteListCellView
            
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
    fileprivate var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    // NoteContentView
                }
            }
        }
    }
}

// MARK: - 노트 컨텐트 뷰
private struct NoteContentView: View {
    fileprivate var body: some View {
        VStack {
            Text("NoteContent")
        }
    }
}

#Preview {
    NoteListView()
}
