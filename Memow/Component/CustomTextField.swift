//
//  CustomTextField.swift
//  Memow
//
//  Created by jaewon Lee on 3/17/24.
//

import SwiftUI

// TextField 커스텀
struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder.opacity(0.5)
            }
            
            // axis: .vertical로 하여 축이 세로로 늘어나게 설정
            // lineLimit은 5줄로 제한하되, 초과시 스크롤 가능
            TextField("", text: $text, axis: .vertical)
                .lineLimit(5)
        }
    }
}
