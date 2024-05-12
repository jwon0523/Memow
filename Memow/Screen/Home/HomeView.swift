//
//  ContentView.swift
//  Memow
//
//  Created by jaewon Lee on 3/15/24.
//

import SwiftUI

private let screenWidth: CGFloat = UIScreen.main.bounds.size.width

struct HomeView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var noteListViewModel: NoteListViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                leftBtnAction: {
                    if !homeViewModel.isEditMessageMode {
                        pathModel.paths.append(.noteListView)
                    }
                },
                rightBtnAction: {
                    withAnimation {
                        homeViewModel.toggleEditMessageMode()
                    }
                },
                leftBtnType: .memow,
                rightBtnType: homeViewModel.navigationBarRightMode
                // 오른쪽 버튼 클릭시 작동 함수 필요
            )
            
            if homeViewModel.isEditMessageMode {
                OptionMenuBar()
            }
            
            ChatListView()
            
            if !homeViewModel.isEditMessageMode {
                MessageFieldView()
            }
        }
        .background(.customBackground)
        .sheet(
            isPresented: $homeViewModel.isShowNoteListModal,
            onDismiss: noteListViewModel.removeAllSelectedNote
        ) {
            NoteListView()
        }
    }
}

// MARK: - 채팅 리스트 뷰
private struct ChatListView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel

    fileprivate var body: some View {
        GeometryReader(content: { geometry in
            ScrollView {
                ScrollViewReader { proxy in
                    // 메세지가 작성된 날짜를 보여줌
                    ChatListCellView()
                        .padding(.top, 10)
                        .padding(.horizontal)
                        .background(.customBackground)
                        .onChange(of: homeViewModel.lastMessageId) { id in
                        // 메세지의 lastMessageId가 변경되면 대화의 마지막 부분으로 이동
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                }
            }
        })
        // 키보드 화면 밖 선택시 키보드 내림
        .onTapGesture {
            UIApplication.shared.keyboardDown()
        }
    }
}

// MARK: - 날짜별 섹션 뷰
private struct ChatListCellView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    private let columns = [GridItem(.flexible())]
    
    fileprivate var body: some View {
        LazyVGrid(
            columns: columns,
            spacing: 0
//            pinnedViews: [.sectionHeaders]
        ) {
            let sectionMessages = homeViewModel.getDateSectionMessages()
            ForEach(sectionMessages.indices, id:\.self) { selectionIndex in
                let messages = sectionMessages[selectionIndex]
                Section(
                    header: DateSectionHeader(firstMessage: messages.first!)
                ) {
                    ForEach(messages, id:\.id) { message in
                        MessageBubbleView(message: message)
                    }
                }
            }
        }
    }
}

// MARK: - 날짜 헤더 뷰
private struct DateSectionHeader: View {
    let firstMessage: Message
    
    fileprivate var body: some View {
        // 바인딩 필요
        Text(firstMessage.date.formattedDay)
            .foregroundStyle(.customFont)
            .font(.system(size: 14, weight: .regular))
            .frame(height: 24)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
    }
}

// MARK: - 메세지 버블 뷰
private struct MessageBubbleView: View {
    private var message: Message
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var showRightIcon: Bool = false
    @State private var dragOffset: CGSize = .zero
    @State private var moveLeft: Bool = false
    
    fileprivate init(message: Message) {
        self.message = message
    }
    
    fileprivate var body: some View {
        HStack {
            if homeViewModel.isEditMessageMode {
                Button(action: {
                    homeViewModel.messageSelectedBoxTapped(message)
                }, label: {
                    if homeViewModel.selectedMessages.contains(message) {
                        Image("SelectedBox")
                    } else {
                        Image("unSelectedBox")
                    }
                })
            }
            
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
                // 선택모드일 때 투명도 0.3 지정하고, 선택박스 선택시 투명도 없음
                .opacity(homeViewModel.isEditMessageMode ? 0.3 : 1)
                // 메세지의 최대 너비는 화면의 68%로 지정
                .frame(maxWidth: screenWidth * 0.68, alignment: .trailing)
                // 왼쪽으로 당기면 x축으로 전체 width범위의 -10까지 이동
                .offset(x: moveLeft ? -10 : 0)
                // 왼쪽으로 당기는 제스처
                .gesture(
                    DragGesture(minimumDistance: 50)
                        .onChanged { value in
                            // 편집 모드가 아닌 경우에만 메세지 드래그 가능
                            if !homeViewModel.isEditMessageMode {
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
                        }
                        .onEnded { _ in
                            self.dragOffset = .zero
                            // 드래그 완료시 작동할 코드 추가 가능.
                        }
                )
                
                if showRightIcon && !homeViewModel.isEditMessageMode {
                    HStack {
                        Image("Alarm")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(3)
                            .background(.customBackground)
                        
                        Spacer()
                            .frame(width: 15)
                        
                        Image("AddFile")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(3)
                            .background(.customBackground)
                        
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
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var text: String = ""
    
    fileprivate var body: some View {
        HStack {
            // TextField를 커스텀한 뷰
            CustomTextField(
                placeholder:
                    Text("내용을 입력하세요")
                    .foregroundColor(.customFont)
                ,
                text: $text
            )
            
            // 입력 내용이 있을 경우만 전송 버튼 보임.
            if text != "" {
                Button {
                    // 입력된 내용이 없을 경우 전송되지 않음
                    if text != "" {
                        homeViewModel.sendMessage(text)
                        text = ""
                        // 전송 버튼 클릭시 키보드 내림
                        UIApplication.shared.keyboardDown()
                    }
                } label: {
                    Image("SendMessage")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .frame(minHeight: 40)
        .background(.customTextField)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// MARK: - 선택모드시 네비게이션바 아래에 나타나는 옵션뷰
fileprivate struct OptionMenuBar: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    fileprivate var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                withAnimation {
                    homeViewModel.removeBtnTapped()
                }
            }, label: {
                Text("Delete")
                    .foregroundColor(.customDelete)
                Image("Trash")
                    .resizable()
                    .frame(width: 20, height: 20)
            })
            
            Spacer()
            
            Button(action: {
                print("Share")
            }, label: {
                Text("Share")
                    .foregroundColor(.customFont)
                Image("Share")
                    .resizable()
                    .frame(width: 20, height: 20)
            })
            
            Spacer()
            
            Button(action: {
                if(!homeViewModel.selectedMessages.isEmpty) {
                    homeViewModel.toggleNoteListModal()
                }
            }, label: {
                Text("Move")
                    .foregroundColor(.customFont)
                Image("AddFile")
                    .resizable()
                    .frame(width: 20, height: 20)
            })
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 10)
    }
    
}

#Preview {
    OnboardingView()
}
