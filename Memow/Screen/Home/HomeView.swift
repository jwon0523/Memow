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
                // 왼쪽 버튼 클릭시 작동할 함수 작성 필요
            )
            
            ChatListView(homeViewModel: homeViewModel)
            
            MessageFieldView(homeViewModel: homeViewModel)
        }
        .background(.customBlack)
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
            // 메세지가 작성된 날짜를 보여줌
            Text(date.formattedDay)
                .font(.system(size: 12, weight: .bold))
            
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(homeViewModel.messages, id:\.id) { message in
                        MessageBubbleView(message: message)
                    }
                }
                .padding(.top, 10)
                .background(.customBlack)
                .onChange(of: homeViewModel.lastMessageId, initial: true) {
                    // 메세지의 lastMessageId가 변경되면 대화의 마지막 부분으로 이동
                    withAnimation {
                        proxy.scrollTo(homeViewModel.lastMessageId, anchor: .bottom)
                    }
                }
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
        // 내가 보낸 메세지면 끝에 정렬하고, 상대방이 보낸 메세지라면 앞에 정렬
        VStack(alignment: message.received ? .leading : .trailing) {
            HStack {
                Text(message.content)
                    .padding()
                    .background(Color.customYellow)
                    .cornerRadius(10)
            }
            .frame(
                maxWidth: 300,
                alignment: message.received ? .leading : .trailing
            )
        }
        .frame(
            maxWidth: .infinity,
            alignment: message.received ? .leading : .trailing
        )
        .padding(.trailing)
        .padding(.horizontal, 10)
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
            // TextField를 커스텀한 뷰
            CustomTextField(
                placeholder: Text("내용을 입력하세요"),
                text: $text
            )
            
            Button {
                homeViewModel.sendMessage(text)
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
