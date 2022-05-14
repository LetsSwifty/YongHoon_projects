//
//  BookCell.swift
//  MyLibrary
//
//  Created by YongHoon Lee on 2022/05/05.
//

import UIKit

class BookCell: UITableViewCell {
    var bookData: Book!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet var img: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var desc: UILabel!
    
    //♡,♥︎: 찜하기 버튼. User 객체의 appendBook(), deleteBook() 메소드를 수행한다
    @IBAction func add(_ sender: UIButton) {
        guard let isbn = bookData.isbn else {
            print("add(): ISBN value is nil")
            return
        }
        //이미 추가되어 있는 경우엔 제거 작업을 수행
        if User.shared.isExist(isbn: isbn) {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)  //♡
            if User.shared.deleteBook(bookData.isbn) {
                print("delete completed!")
            } else { print("Failed to delete...")}
        } else {    //그렇지 않으면 추가 작업을 수행
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) //♥︎
            if User.shared.appendBook(bookData) {
                print("add completed!")
            } else { print("Failed to add...") }
        }
    }
}
