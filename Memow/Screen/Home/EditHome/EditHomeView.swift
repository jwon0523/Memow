//
//  EditHomeView.swift
//  Memow
//
//  Created by jaewon Lee on 3/27/24.
//

import SwiftUI

private let screenWidth: CGFloat = UIScreen.main.bounds.size.width

struct EditHomeView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var pathModel: PathModel
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                rightBtnAction: {
                    withAnimation {
                        // 선택모드 해제시 선택된 체크박스 삭제되지 않고 남아있는 오류 해결 필요
                        homeViewModel.navigationRightBtnTapped()
                    }
                },
                leftBtnType: .memow,
                rightBtnType: .close
                // 오른쪽 버튼 클릭시 작동 함수 필요
            )
            
            OptionMenuBar()
            
            ChatListView()
            
            MessageFieldView()
        }
        .background(.customBackground)
    }
}

// MARK: - 채팅 리스트 뷰
private struct ChatListView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var selectedMessages: Set<String> = []
    private var date: Date
    
    fileprivate init(
        date: Date = Date()
    ) {
        self.date = date
    }
    
    fileprivate var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    // 메세지가 작성된 날짜를 보여줌
                    Text(date.formattedDay)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.customFont)
                    ForEach(homeViewModel.messages, id:\.id) { message in
                        MessageBubble(message: message, isDragGesture: false)
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
        // 키보드 화면 밖 선택시 키보드 내림
        .onTapGesture {
            UIApplication.shared.keyboardDown()
        }
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
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .frame(minHeight: 40)
        .background(.customTextField)
        .cornerRadius(50)
        .padding()
    }
}

// MARK: - 선택모드시 네비게이션바 아래에 나타나는 옵션뷰
fileprivate struct OptionMenuBar: View {
    fileprivate var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                print("Delete")
            }, label: {
                Text("Delete")
                    .foregroundColor(.customDelete)
                Image("Trash")
            })
            
            Spacer()
            
            Button(action: {
                print("Share")
            }, label: {
                Text("Share")
                    .foregroundColor(.customFont)
                Image("Share")
            })
            
            Spacer()
            
            Button(action: {
                print("Move")
            }, label: {
                Text("Move")
                    .foregroundColor(.customFont)
                Image("AddFile")
            })
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 10)
    }
    
}

#Preview {
    EditHomeView()
        .environmentObject(PathModel())
        .environmentObject(HomeViewModel())
}
