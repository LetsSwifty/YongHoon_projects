//
//  UserDetailViewController.swift
//  MyLibrary
//
//  Created by YongHoon Lee on 2022/05/06.
//

import UIKit

class UserDetailViewController: UIViewController {
    var books = Books()
    var booksList = [Book]() //테이블 뷰에 보여질 책 리스트
    @IBOutlet weak var tableViewDB: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.booksList = [Book]()
        for bookID in User.shared.myBooks.keys {
            if let book = books.data[bookID] {
                self.booksList.append(book)
            }
        }
        self.booksList.sort {
            $0.title > $1.title
        }
    }
}

extension UserDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.booksList.count == 0 {
            tableView.setEmptyMessage("읽은 책 목록이 없습니다")
        } else {
            tableView.restore()
        }

        return self.booksList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = booksList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "myBookCell") as! MyBookCell
        cell.parentVC = self
        cell.title?.text = book.title
        cell.desc?.text = book.desc
        cell.id = book.id
        
        return cell
    }
}

extension UserDetailViewController: UITableViewDelegate {
}

//빈 테이블 뷰일 때를 보여줄 메시지
extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.label
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
