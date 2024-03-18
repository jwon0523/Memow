//
//  Path.swift
//  Memow
//
//  Created by jaewon Lee on 3/19/24.
//

import Foundation

class Path: ObservableObject {
    @Published var paths: [PathType]
    
    init(
        paths: [PathType] = []
    ) {
        self.paths = paths
    }
}
