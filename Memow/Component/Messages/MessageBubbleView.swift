//
//  MessageBubble.swift
//  Memow
//
//  Created by jaewon Lee on 3/19/24.
//

import SwiftUI

// MARK: - 메세지 버블 뷰
struct MessageBubble: View {
    private var message: Message
    @State private var showReplyIcon = false
    @State private var dragOffset: CGSize = .zero
    @State private var moveLeft = false
    
    init(message: Message) {
        self.message = message
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .trailing) {
                HStack {
//                    Spacer()
//                        .frame(width: 30)
                    Text(message.content)
                        .foregroundColor(.customFont)
                        .font(.system(size: 12))
                        .frame(maxWidth: 300)
                        .background(.yellow)
                }
            }
            .padding()
//            .background(.green)
            .frame(alignment: .trailing)
            .offset(x: moveLeft ? -50 : 0)
            .animation(.default)
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onChanged { value in
                        self.dragOffset = value.translation
                        if self.dragOffset.width < 0 {
                            // 애니메이션으로 부드럽게 보여줌
                            withAnimation {
                                self.showReplyIcon = true
                                self.moveLeft = true
                            }
                        } else if self.dragOffset.width > 0 {
                            // 애니메이션으로 부드럽게 보여줌
                            withAnimation {
                                self.showReplyIcon = false
                                self.moveLeft = false
                            }
                        }
                    }
                    .onEnded { _ in
                        self.dragOffset = .zero
                        // 여기에 답장 보내는 코드를 추가 가능.
                    }
            )
            if showReplyIcon {
                VStack {
                    Image("AddFile")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .background(.red)
    }
}

#Preview {
    MessageBubble(
        message: .init(
            id: "4",
            content: "Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!Good!Good!Good!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!Good!Good!Good!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!Good!Good!Good!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!Good!Good!Good!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!Good!Good!Good!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!!Good!Good!Good!Good!",
//                        content: "Hello",
            date: Date()
        ))
}

