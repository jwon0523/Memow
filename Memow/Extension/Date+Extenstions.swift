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
    
    // 날짜 커스텀
    var formattedDay: String {
        //        let now = Date()
        //        let calender = Calendar.current
        
        //        let nowStartOfDay = calender.startOfDay(for: now)
        //        let dateStartOfDay = calender.startOfDay(for: self)
        //        let numOfDaysDifference = calender.dateComponents([.day], from: nowStartOfDay, to: dateStartOfDay).day!
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "Y년 M월 d일 E요일"
        
        return formatter.string(from: self)
        
        
    }
}
