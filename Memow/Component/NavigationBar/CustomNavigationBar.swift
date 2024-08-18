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
    let leftBtnType: NavigationBtnType
    let rightBtnType: NavigationBtnType
    
    init(
        isDisplayLeftBtn: Bool = true,
        isDisplayRightBtn: Bool = true,
        leftBtnAction: @escaping () -> Void = {},
        rightBtnAction: @escaping () -> Void = {},
        leftBtnType: NavigationBtnType = .notes,
        rightBtnType: NavigationBtnType = .complete
    ) {
        self.isDisplayLeftBtn = isDisplayLeftBtn
        self.isDisplayRightBtn = isDisplayRightBtn
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
                        if leftBtnType == .emptyBtn {
                            EmptyView()
                        } else if leftBtnType == .notes
                            || leftBtnType == .memow
                        {
                            Text(leftBtnType.rawValue)
                                .customFontStyle(.heading)
                                .foregroundColor(.labelNeutral)
                                .padding(.horizontal, 19)
                                .padding(.vertical, 12)
                            
                        } else if leftBtnType == .home {
                            Image(systemName: leftBtnType.rawValue)
                                .font(.system(size: 20, weight: .ultraLight))
                                .padding(8)
                                .foregroundColor(.customFont)
                        } else {
                            VStack {
                                Image(leftBtnType.rawValue)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                            }
                            .frame(width: 48, height: 48)
                        }
                    }
                )
            }
            
            Spacer()
            
            if isDisplayRightBtn {
                Button(
                    action: rightBtnAction,
                    label: {
                        if rightBtnType == .emptyBtn {
                            EmptyView()
                        } else if rightBtnType == .complete
                            || rightBtnType == .update
                        {
                            Text(rightBtnType.rawValue)
                                .customFontStyle(.heading)
                                .foregroundColor(.colorPrimary)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 12)
                        } else {
                            VStack {
                                Image(rightBtnType.rawValue)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                            }
                            .frame(width: 48, height: 48)
                        }
                })
            }
        }
        .frame(height: 48)
    }
}

#Preview {
    CustomNavigationBar()
}
