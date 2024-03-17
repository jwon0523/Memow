//
//  ContentView.swift
//  Memow
//
//  Created by jaewon Lee on 3/15/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                isDisplayLeftBtn: false
            )
            
            ChatListView(homeViewModel: homeViewModel)
            
             MessageFieldView(homeViewModel: homeViewModel)
        }
    }
}

// MARK: - 채팅 리스트 뷰
private struct ChatListView: View {
    @ObservedObject private var homeViewModel: HomeViewModel
    private var date: Date
    
    fileprivate init(homeViewModel: HomeViewModel, date: Date = Date()) {
        self.homeViewModel = homeViewModel
        self.date = date
    }
    
    fileprivate var body: some View {
        VStack {
            Text(date.formattedDay)
                .font(.system(size: 12, weight: .bold))
            
            ForEach(homeViewModel.messages, id: \.self) { message in
                MessageBubbleView(message: message)
            }
        }
    }
}

// MARK: - 메세지 버블 뷰
private struct MessageBubbleView: View {
    private var message: Message
    
    fileprivate init(message: Message) {
        self.message = message
    }
    
    fileprivate var body: some View {
        VStack(alignment: message.received ? .leading : .trailing) {
            Text(message.content)
        }
    }
}

// MARK: - 메세지 입력 뷰
private struct MessageFieldView: View {
    @ObservedObject private var homeViewModel: HomeViewModel
    @State private var text: String = ""
    
    fileprivate init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    fileprivate var body: some View {
        HStack {
            CustomTextField(
                placeholder: Text("내용을 입력하세요"), 
                text: $text
            )
            
            Button {
                homeViewModel.sendMessage(
                    .init(id: "1", content: text, date: Date())
                )
                text = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.customBlack)
                    .cornerRadius(50)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.gray)
        .cornerRadius(50)
        .padding()
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
