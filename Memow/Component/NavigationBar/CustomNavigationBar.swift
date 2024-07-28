//
//  CustomNavigationBar.swift
//  Memow
//
//  Created by jaewon Lee on 3/15/24.
//

import SwiftUI

// 왼쪽 버튼과 오른쪽 버튼의 표시 여부 선택 가능
// 왼쪽 버튼과 오른쪽 버튼의 타입 설정 가능
// 왼쪽 버튼과 오른쪽 버튼의 액션을 함수로 커스텀 가능
struct CustomNavigationBar: View {
    let isDisplayLeftBtn: Bool
    let isDisplayRightBtn: Bool
    let isDisplayLogo: Bool
    let leftBtnAction: () -> Void
    let rightBtnAction: () -> Void
    let leftBtnType: NavigationBtnType
    let rightBtnType: NavigationBtnType
    
    // 왼쪽과 오른쪽 버튼을 false로 초기화
    // 왼쪽과 오른쪽 버튼의 기능을 각각 커스텀 가능
    init(
        isDisplayLeftBtn: Bool = true,
        isDisplayRightBtn: Bool = true,
        isDisplayLogo: Bool = true,
        leftBtnAction: @escaping () -> Void = {},
        rightBtnAction: @escaping () -> Void = {},
        leftBtnType: NavigationBtnType = .sideMenuIcon,
        rightBtnType: NavigationBtnType = .update
    ) {
        self.isDisplayLeftBtn = isDisplayLeftBtn
        self.isDisplayRightBtn = isDisplayRightBtn
        self.isDisplayLogo = isDisplayLogo
        self.leftBtnAction = leftBtnAction
        self.rightBtnAction = rightBtnAction
        self.leftBtnType = leftBtnType
        self.rightBtnType = rightBtnType
    }
    
    var body: some View {
        HStack {
            if isDisplayLeftBtn {
                Button(
                    action: leftBtnAction,
                    label: {
                        // 왼쪽 버튼 타입에 따라 텍스트나 이미지 보여줌
                        if leftBtnType == .notes
                            || leftBtnType == .memow
                        {
                            Text(leftBtnType.rawValue)
                                .foregroundColor(.customFont)
                                .fontWeight(.bold)
                                .padding()
                            
                        } else if leftBtnType == .home {
                            Image(systemName: leftBtnType.rawValue)
                                .font(.system(size: 20, weight: .ultraLight))
                                .padding(8)
                                .foregroundColor(.customFont)
                        } else {
                            Image(leftBtnType.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .padding(.leading, 10)
                        }
                    }
                )
            }
            
            Spacer()
            
            if isDisplayRightBtn {
                Button(
                    action: rightBtnAction,
                    label: {
                        if rightBtnType == .complete
                            || rightBtnType == .update
                        {
                            Text(rightBtnType.rawValue)
                                .foregroundColor(.customFont)
                                .fontWeight(.bold)
                                .padding(.trailing, 10)
                        } else {
                            Image(rightBtnType.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .padding(.trailing, 10)
                        }
                })
            }
        }
    }
}

#Preview {
    CustomNavigationBar()
}
