//
//  ContentView.swift
//  Memow
//
//  Created by jaewon Lee on 3/15/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            CustomNavigationBar(
                isDisplayLeftBtn: false
            )
            
            // ChatView
            
            // ChatCotentInputView
        }
    }
}

private struct ChatView: View {
    private var date = Date()
    
    fileprivate var body: some View {
        Text("\(date.formattedDay)")
            .font(.system(size: 12, weight: .medium))
    }
}

#Preview {
    HomeView()
}
