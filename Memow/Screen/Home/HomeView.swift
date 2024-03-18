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
                // 왼쪽 버튼 클릭시 작동 함수 필요
                isDisplayRightBtn: true
                // 오른쪽 버튼 클릭시 작동 함수 필요
            )
            
            ChatListView(homeViewModel: homeViewModel)
            
            MessageFieldView(homeViewModel: homeViewModel)
        }
        .background(.customBackground)
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
                .foregroundStyle(.customFont)
            
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(homeViewModel.messages, id:\.id) { message in
                        MessageBubbleView(message: message)
                    }
                }
                .padding(.top, 10)
                .background(.customBackground)
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
                // 보낸 시각을 메세지 왼쪽 최하단에 위치시킴
                VStack {
                    Spacer()
                    Text(message.date.formattedTime)
                        .padding(.leading)
                        .foregroundColor(.customFont)
                        .font(.system(size: 8))
                }
                
                Text(message.content)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.customYellow)
                    .cornerRadius(10)
            }
            .frame(
                maxWidth: 400,
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
                placeholder:
                    Text("내용을 입력하세요")
                    .foregroundColor(Color.customFont)
                ,
                text: $text
            )
            
            Button {
                // 입력된 내용이 없을 경우 전송되지 않음
                if text != "" {
                    homeViewModel.sendMessage(text)
                    text = ""
                }
            } label: {
                // 입력 내용이 있을 경우만 전송 버튼 보임.
                if text != "" {
                    Image("SendMessage")
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .frame(minHeight: 40)
        .background(Color.customTextField)
        .cornerRadius(20)
        .border(.customBorder, width: 2)
        .padding()
    }
}

#Preview {
    HomeView()
}
