//
//  User.swift
//  MyLibrary
//
//  Created by YongHoon Lee on 2022/05/05.
//

import Foundation

//User 객체는 Singletone 패턴으로 생성
class User {
    static let shared = User()
    var userID: String
    var name: String
    private var booksList = [Book]()  //내가 찜한 책들이 담길 배열
    private var booksDict = [String: Int]() //내가 찜한 책들의 ISBN 값에 대한 테이블. Int값은 추후 찜한 순서로 사용될 수 있다
    
    //찜한 책을 배열&테이블에 추가하는 메소드
    func appendBook(_ book: Book) -> Bool {
        guard let isbn = book.isbn else {
            print("appendBook(): invalid ISBN value")
            return false
        }
        
        //테이블에 값이 존재하지 않는 경우
        if self.booksDict[isbn] == nil {
            self.booksList.append(book)  //새로운 책 객체를 배열에 append한다
            self.booksDict[isbn] = 0    //새로운 책 객체의 isbn 값을 테이블에 추가한다
            return true
        } else {
            print("appendBook(): already exist ISBN value")
            return false
        }
    }
    
    //찜했던 책을 배열&테이블에서 제거하는 메소드
    func deleteBook(_ isbn: String?) -> Bool {
        guard let isbn = isbn else {
            print("deleteBook(): invalid ISBN value")
            return false
        }
                
        if self.booksDict[isbn] != nil {
            //배열에서 isbn에 해당하는 book 객체의 인덱스를 찾아냄
            if let index = booksList.firstIndex(where: {$0.isbn == isbn}) {
                booksList.remove(at: index)  //찾아낸 인덱스에 위치한 책 객체 제거
                self.booksDict[isbn] = nil   //테이블에서 isbn에 해당하는 항목 제거
                return true
            } else {
                print("deletebook(): cannot find \"\(isbn)\" in booksList")  //isbn에 해당하는 책 객체를 찾지 못했으므로 fail을 낸다
                self.booksDict[isbn] = nil
                return false
            }
        } else {
            print("deleteBook(): non-exist ISBN value")  //존재하지 않는 isbn값에 대한 접근을 시도하였으므로 fail을 낸다
            return false
        }
    }
    
    func isExist(isbn: String?) -> Bool {
        guard let isbn = isbn else {
            print("isExist(): invalid ISBN value")
            return false
        }
        
        if let _ = self.booksDict[isbn] {
            return true
        } else {
            return false
        }
    }
    
    func getBookInstance(index: Int) -> Book {
        return booksList[index] //인덱싱 에러에 대한 캐치를 해야한다
    }
    
    func getNumberOfBooksList() -> Int {
        return booksList.count
    }
    
    private init() {
        self.userID = "187356"
        self.name = "티코님"
    }
}
