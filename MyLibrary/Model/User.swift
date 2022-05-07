//
//  User.swift
//  MyLibrary
//
//  Created by YongHoon Lee on 2022/05/05.
//

import Foundation

class User {
    static let shared = User()
    var id: String
    var name: String
    var membership: Membership
    var myBooks = [String: Int]()   //[ISBN: count]
    
    private init() {
        self.id = "187356"
        self.name = "티코님"
        self.membership = .Bronze
    }
}

enum Membership {
    case Bronze
    case Silver
    case Gold
}
