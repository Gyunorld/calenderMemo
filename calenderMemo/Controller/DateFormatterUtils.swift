//
//  DateFormatter.swift
//  calenderMemo
//
//  Created by 김민규 on 11/21/24.
//

import Foundation

class DateFormatterUtils {
    static func formatDate(_ date: Date, format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
