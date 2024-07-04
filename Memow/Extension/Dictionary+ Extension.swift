//
//  Dictionary+ Extension.swift
//  Memow
//
//  Created by jaewon Lee on 7/4/24.
//

import Foundation

extension Dictionary where Key == DateComponents {
    func sortedKeys() -> [DateComponents] {
        return self.keys.sorted {
            Calendar.current.date(from: $0)! < Calendar.current.date(from: $1)!
        }
    }
}
