//
//  Book.swift
//  MyLibrary
//
//  Created by YongHoon Lee on 2022/05/05.
//

import Foundation

struct Book: Identifiable {
    var id: String  //ISBN
    var title: String
    var desc: String
    var imageName: String
}

class Books {
    var data = [String: Book]()    //key의 타입은 Book.id의 타입과 항상 일치해야 한다
    
    init() {
        var temp = [String: Book]()
        
        //will: JSON parsing 코드로 대체 & 네트워킹 코드
        for i in 0..<10 {
            let book = Book(id: "\(i)\(i)", title: "name\(i)", desc: "desc\(i)", imageName: "imageName\(i)")
            temp[book.id] = book
        }
        self.data = temp
    }
}
