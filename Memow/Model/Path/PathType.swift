//
//  PathType.swift
//  Memow
//
//  Created by jaewon Lee on 3/19/24.
//

import Foundation

enum PathType: Hashable {
    case homeView
    case noteView(isCreateMode: Bool, note: Note?)
    case noteListView
}
