//
//  UIApplication+Extension.swift
//  Memow
//
//  Created by jaewon Lee on 3/24/24.
//

import SwiftUI

extension UIApplication {
    func keyboardDown() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
