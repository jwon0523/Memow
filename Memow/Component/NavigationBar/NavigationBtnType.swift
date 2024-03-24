//
//  NavigationBarType.swift
//  Memow
//
//  Created by jaewon Lee on 3/15/24.
//

import Foundation

enum NavigationBtnType: String {
    // CustomNavigationBar에서 title 외 나머지는 이미지로 보여줌
    case notes = "Notes"
    case close = "Close"
    // 추후 디자인 나오면 추가 예정
    case hamburgerMenuIcon
    case kebabMenuIcon = "KebabMenu"
    case meetbalMenulIcon
    case leftBack = "LeftBack"
    case add = "Create"
    case complete = "완료"
    case update = "수정"
    case home = "house"
    case select = "Select"
    case memow = "Memow"
    case delete = "Trash"
}
