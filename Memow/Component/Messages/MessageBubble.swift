//
//  MessageBubble.swift
//  Memow
//
//  Created by jaewon Lee on 3/20/24.
//

import SwiftUI

struct MessageBubble: View {
    var message: Message
    @State var showRightIcon = false
    @State var dragOffset: CGSize = .zero
    @State var moveLeft = false
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                HStack {
                    VStack(alignment: .trailing) {
                        HStack {
                            VStack {
                                Spacer()
                                Text(message.date.formattedTime)
                                    .foregroundColor(.customFont)
                                    .font(.system(size: 8))
                            }
                            
                            Text(message.content)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.customYellow)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                                
                        }
                        .frame(maxWidth: 260, alignment: .trailing)
                    }
                    // 왼쪽으로 당기면 x축으로 전체 width범위의 10%까지만 왼쪽으로 이동
                    .offset(x: moveLeft ? -geometry.size.width * 0.03 : 0)
                    .animation(.default)
                    // 왼쪽으로 당기는 제스처
                    .gesture(
                        DragGesture(minimumDistance: 50)
                            .onChanged { value in
                                self.dragOffset = value.translation
                                if self.dragOffset.width < 0 {
                                    // 애니메이션으로 부드럽게 보여줌
                                    withAnimation {
                                        self.showRightIcon = true
                                        self.moveLeft = true
                                    }
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
                                // 여기에 답장 보내는 코드를 추가 가능.
//                                print(geometry.size.width)
                            }
                    )
                    if showRightIcon {
                        HStack {
                            Image("AddFile")
                                .frame(width: 35, height: 35)
                                .background(.customWhite)
                                .cornerRadius(20)
                                .shadow(radius: 2.8)
                            
                            Spacer()
                                .frame(width: 15)
                            
                            Image("AddFile")
                                .frame(width: 35, height: 35)
                                .background(.customWhite)
                                .cornerRadius(20)
                                .shadow(radius: 2.8)
                            Spacer()
                                .frame(width: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.vertical,20)
            .padding(.horizontal,10)
        }
    }
}

#Preview {
    MessageBubble(
        message: .init(
            id: "1",
            content: "HelloHelloHelloHelloHelloHelloHelHelloHelloHelloHelloHelloHelloHelHelloHelloHelloHelloHelloHelloHel",
            date: Date()
        )
    )
}
