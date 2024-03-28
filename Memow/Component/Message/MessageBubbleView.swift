//
//  MessageBubbleView.swift
//  Memow
//
//  Created by jaewon Lee on 3/27/24.
//

import SwiftUI

private let screenWidth: CGFloat = UIScreen.main.bounds.size.width

struct MessageBubble: View {
    private var message: Message
    private var isDragGesture: Bool
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var showRightIcon: Bool = false
    @State private var dragOffset: CGSize = .zero
    @State private var moveLeft: Bool = false
    @State private var isSelected: Bool = false
    
    init(
        message: Message,
        isDragGesture: Bool = true
    ) {
        self.message = message
        self.isDragGesture = isDragGesture
    }
    
    var body: some View {
        HStack {
            if homeViewModel.isEditMessageMode {
                Button(action: {
                    isSelected.toggle()
                    homeViewModel.messageSelectedBoxTapped(id: message.id)
                }, label: {
                    isSelected ? Image("SelectedBox") : Image("unSelectedBox")
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
                .opacity(homeViewModel.isEditMessageMode ? isSelected ? 1: 0.3 : 1)
                // 메세지의 최대 너비는 화면의 68%로 지정
                .frame(maxWidth: screenWidth * 0.68, alignment: .trailing)
                // 왼쪽으로 당기면 x축으로 전체 width범위의 -10까지 이동
                .offset(x: moveLeft ? -10 : 0)
                // 왼쪽으로 당기는 제스처
                .gesture(
                     DragGesture(minimumDistance: 50)
                        .onChanged { value in
                            if isDragGesture {
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

#Preview {
    MessageBubble(
        message: Message(
            id: "1", content: "Hello", date: Date()
        ))
    .environmentObject(HomeViewModel())
}
