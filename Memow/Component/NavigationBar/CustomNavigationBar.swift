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
    
    // 왼쪽과 오른쪽 버튼을 false로 초기화
    // 왼쪽과 오른쪽 버튼의 기능을 각각 커스텀 가능
    init(
        isDisplayLeftBtn: Bool = false,
        isDisplayRightBtn: Bool = false,
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
                // 왼쪽 버튼을 보여주지 않을 경우 빈공간 주어 로고 정렬
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
            } else {
                // 오른쪽 버튼을 보여주지 않을 경우 빈공간 주어 로고 정렬
                Spacer()
                    .frame(width: 50)
            }
        }
    }
}

#Preview {
    CustomNavigationBar()
}
