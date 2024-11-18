//
//  Letter.swift
//  calenderMemo
//
//  Created by 김민규 on 11/10/24.
//

import Foundation
import RealmSwift

class Letter: Object {
    @objc dynamic var Title: String = ""
    @objc dynamic var Body: String = ""
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var category = Category.RawValue()

    enum Category: String {
        case diary = "일기"
        case book = "독서"
        case memo = "메모"
        case todo = "할일"
        
        static let allCases: [Category] = [.diary, .book, .memo, .todo]
    }
}

