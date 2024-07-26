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
    
    var body: some View {
        ZStack {
            if isShowing {
                Rectangle()
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                
                HStack {
                    VStack(alignment: .leading, spacing: 32) {
                        NoteListView()
                            .environmentObject(pathModel)
                            .environmentObject(noteListViewModel)
                            .environmentObject(homeViewModel)
                            .environmentObject(noteDataController)
                            .environment(
                                \.managedObjectContext,
                                 noteDataController.container.viewContext
                            )
                    }
                    .frame(width: 340, alignment: .leading)
                    .background(.white)
                    
                    Spacer()
                }
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut, value: isShowing)
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
