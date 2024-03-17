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
    var editingChanged: (Bool) -> Void = {_ in}
    var commit: () -> Void = {}
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder.opacity(0.5)
            }
            
            TextField(
                "",
                text: $text,
                onEditingChanged: editingChanged,
                onCommit: commit
            )
        }
    }
}
