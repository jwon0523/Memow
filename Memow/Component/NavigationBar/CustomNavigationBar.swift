//
//  CustomNavigationBar.swift
//  Memow
//
//  Created by jaewon Lee on 3/15/24.
//

import SwiftUI

struct CustomNavigationBar: View {
    let isDisplayLeftBtn: Bool
    let isDisplayRightBtn: Bool
    let leftBtnAction: () -> Void
    let rightBtnAction: () -> Void
    
    init(
        isDisplayLeftBtn: Bool = false,
        isDisplayRightBtn: Bool = true,
        leftBtnAction: @escaping () -> Void = {},
        rightBtnAction: @escaping () -> Void = {}
    ) {
        self.isDisplayLeftBtn = isDisplayLeftBtn
        self.isDisplayRightBtn = isDisplayRightBtn
        self.leftBtnAction = leftBtnAction
        self.rightBtnAction = rightBtnAction
    }
    
    var body: some View {
        HStack {
            if isDisplayLeftBtn {
                Button(
                    action: leftBtnAction,
                    label: { Image("LeftBack") }
                )
            } else {
                Spacer()
                    .frame(width: 50)
            }
            
            Spacer()
            
            Image("Icon")
            
            Spacer()
            
            if isDisplayRightBtn {
                Button(
                    action: rightBtnAction, label: {
                        Image("RightBtn")
                })
            }
        }
    }
}

#Preview {
    CustomNavigationBar()
}
