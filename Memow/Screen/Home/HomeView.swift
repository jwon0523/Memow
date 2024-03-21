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
                .onChange(of: homeViewModel.lastMessageId) { id in
                    // 메세지의 lastMessageId가 변경되면 대화의 마지막 부분으로 이동
                    withAnimation {
                        proxy.scrollTo(id, anchor: .bottom)
                    }
                }
            }
        }
    }
}

// MARK: - 메세지 버블 뷰
private struct MessageBubbleView: View {
    private let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    private var message: Message
    @State private var showRightIcon: Bool = false
    @State private var dragOffset: CGSize = .zero
    @State private var moveLeft: Bool = false
    
    fileprivate init(message: Message) {
        self.message = message
    }
    
    fileprivate var body: some View {
        VStack {
            HStack {
                HStack {
                    VStack {
                        Spacer()
                        Text(message.date.formattedTime)
                            .foregroundColor(.customFont)
                            .font(.system(size: 8))
                            .padding(.top)
                    }
                    
                    Text(message.content)
                        .font(.system(size: 12))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.customYellow)
                        .cornerRadius(10)
                    
                }
                // 메세지의 최대 너비는 화면의 68%로 지정
                .frame(maxWidth: screenWidth * 0.68, alignment: .trailing)
                // 왼쪽으로 당기면 x축으로 전체 width범위의 -10까지 이동
                .offset(x: moveLeft ? -10 : 0)
                .animation(.default)
                // 왼쪽으로 당기는 제스처
                .gesture(
                    DragGesture(minimumDistance: 50)
                        .onChanged { value in
                            self.dragOffset = value.translation
                            // 오른쪽에서 왼쪽으로 드래그
                            if self.dragOffset.width < 0 {
                                // 애니메이션으로 부드럽게 보여줌
                                withAnimation {
                                    self.showRightIcon = true
                                    self.moveLeft = true
                                }
                                // 왼쪽에서 오른쪽으로 드래그
                            } else if self.dragOffset.width > 0 {
                                // 애니메이션으로 부드럽게 보여줌
                                withAnimation {
                                    self.showRightIcon = false
                                    self.moveLeft = false
                                }
                            }
                        }
                        .onEnded { _ in
                            self.dragOffset = .zero
                            // 드래그 완료시 작동할 코드 추가 가능.
                        }
                )
                if showRightIcon {
                    HStack {
                        Image("Alarm")
                            .frame(width: 35, height: 35)
                            .background(.customWhite)
                            .cornerRadius(20)
                            .shadow(radius: 2)
                        
                        Spacer()
                            .frame(width: 15)
                        
                        Image("AddFile")
                            .frame(width: 35, height: 35)
                            .background(.customWhite)
                            .cornerRadius(20)
                            .shadow(radius: 2)
                        
                        Spacer()
                            .frame(width: 5)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.vertical, 3)
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
