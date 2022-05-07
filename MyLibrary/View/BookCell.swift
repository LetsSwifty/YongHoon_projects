//
//  BookCell.swift
//  MyLibrary
//
//  Created by YongHoon Lee on 2022/05/05.
//

import UIKit

class BookCell: UITableViewCell {
    var id: String = ""
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet var title: UILabel!
    @IBOutlet var desc: UILabel!
    @IBAction func add(_ sender: UIButton) {
        let count = User.shared.myBooks.count
        if let _ = User.shared.myBooks[self.id] {
            print("이미 존재함")
        } else {
            User.shared.myBooks[self.id] = count + 1
            addButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            addButton?.isEnabled = false
        }
    }
}
