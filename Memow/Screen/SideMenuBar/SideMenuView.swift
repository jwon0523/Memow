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
    @Binding var offset: CGFloat
    @Binding var lastOffset: CGFloat
    @State private var backgroundOpacity: Double = 0.0

    private let sideMenuWidth: CGFloat = 340

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
                    .frame(width: sideMenuWidth, alignment: .leading)
                    .background(Color.white)
                    .offset(x: offset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // 오른쪽으로 드래그 시 열림, 왼쪽으로 드래그 시 닫힘
                                let totalTranslation = value.translation.width + lastOffset
                                if totalTranslation <= 0 {
                                    offset = totalTranslation
                                    backgroundOpacity = Double(min(abs(offset) / sideMenuWidth, 0.3))
                                }
                            }
                            .onEnded { value in
                                withAnimation {
                                    if -offset > sideMenuWidth / 2 {
                                        isShowing = false
                                    }
                                    offset = 0
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
                    offset = -sideMenuWidth
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
        isShowing: .constant(true),
        offset: .constant(0),
        lastOffset: .constant(0)
    )
    .environment(\.managedObjectContext, context)
    .environmentObject(PathModel())
    .environmentObject(HomeViewModel())
    .environmentObject(NoteListViewModel())
    .environmentObject(NoteDataController.preview)
}
