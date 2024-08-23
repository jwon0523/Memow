//
//  SideMenuView.swift
//  Memow
//
//  Created by jaewon Lee on 7/27/24.
//

import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var noteListViewModel: NoteListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var noteDataController: NoteDataController
    @Binding var isShowing: Bool
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    @State private var backgroundOpacity: Double = 0.0

    var body: some View {
        ZStack {
            if isShowing {
                Rectangle()
                    .opacity(backgroundOpacity)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
                
                HStack {
                    VStack(alignment: .leading, spacing: 32) {
                        NoteListView()
                            .environmentObject(pathModel)
                            .environmentObject(noteListViewModel)
                            .environmentObject(homeViewModel)
                            .environmentObject(noteDataController)
                            .environment(\.managedObjectContext, noteDataController.container.viewContext)
                    }
                    .frame(width: 340, alignment: .leading)
                    .background(.white)
                    .offset(x: offset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let totalTranslation = value.translation.width + lastOffset
                                // 왼쪽으로 드래그 시 totalTranslation이 0 이하로 넘어가지 않도록 제한
                                if totalTranslation <= 0 {
                                    offset = totalTranslation
                                    backgroundOpacity = Double(
                                        min(abs(offset) / 340, 0.3)
                                    )
                                }
                            }
                            .onEnded { value in
                                let dragThreshold: CGFloat = 100
                                if -offset > dragThreshold {
                                    // 사용자가 충분히 왼쪽으로 드래그하면 사이드 메뉴를 닫음
                                    withAnimation {
                                        isShowing = false
                                    }
                                    offset = -340
                                } else {
                                    // 그렇지 않으면 사이드 메뉴를 다시 원위치로
                                    withAnimation {
                                        offset = 0
                                        backgroundOpacity = 0.3
                                    }
                                }
                                lastOffset = offset
                            }
                    )
                    
                    Spacer()
                }
                .transition(.move(edge: .leading))
            }
        }
        .onChange(of: isShowing) { newValue in
            withAnimation(.easeInOut(duration: 0.3)) {
                if newValue {
                    offset = 0
                    lastOffset = 0
                    backgroundOpacity = 0.3
                } else {
                    backgroundOpacity = 0.0
                }
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
    
    return SideMenuView(
        isShowing: .constant(true)
    )
    .environment(\.managedObjectContext, context)
    .environmentObject(PathModel())
    .environmentObject(HomeViewModel())
    .environmentObject(NoteListViewModel())
    .environmentObject(NoteDataController.preview)
}
