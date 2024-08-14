//
//  Date+Extenstions.swift
//  Memow
//
//  Created by jaewon Lee on 3/15/24.
//

import Foundation

extension Date {
    // 시간 커스텀
    var formattedTime: String {
        let formatter = DateFormatter()
        //     한글로 변환
//        formatter.locale = Locale(identifier: "ko_KR")
        // 시간 나타낼 방식
        formatter.dateFormat = "hh:mm a"
        
        return formatter.string(from: self)
    }
    
    func formattedDate(from dateComponents: DateComponents) -> String {
        let calendar = Calendar.current
        
        guard let date = calendar.date(from: dateComponents) else {
            return "Invalid Date"
        }
        
        // DateFormatter 설정
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEE, MMMM d, yyyy" // "Wednesday, December 20, 2023" 형식
        
        // 날짜를 포맷팅하여 문자열로 반환
        return formatter.string(from: date)
    }
    
    func daysBetween(date: Date) -> Int {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        if let daysBetween = calendar.dateComponents([.day], from: date1, to: date2).day {
            return daysBetween
        }
        return 0
    }
}
