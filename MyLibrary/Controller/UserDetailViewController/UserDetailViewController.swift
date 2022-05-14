//
//  UserDetailViewController.swift
//  MyLibrary
//
//  Created by YongHoon Lee on 2022/05/06.
//

import UIKit

class UserDetailViewController: UIViewController {
    var myData = MyData()
    @IBOutlet var tableView: UITableView!  //User.shared.booksList가 보여진다
}

extension UserDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if User.shared.getNumberOfBooksList() == 0 {
            tableView.setEmptyMessage("읽은 책 목록이 없습니다")
        } else {
            tableView.restore()
        }
        return User.shared.getNumberOfBooksList()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = User.shared.getBookInstance(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "myBookCell") as! MyBookCell
        DispatchQueue.main.async {
            cell.img.image = self.myData.loadImage(isbn: book.isbn, urlString: book.image!)
        }
        cell.parentVC = self
        cell.delegate = self  //registration
        cell.title?.text = book.title
        cell.isbn = book.isbn
        
        return cell
    }
}

extension UserDetailViewController: UITableViewDelegate {
}

//[Extension] : 빈 테이블 뷰일 때를 보여줄 메시지
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

//[Extension] : 리로드
extension UserDetailViewController: ReloadDelegate {
    func reload() {
        print("리로드 실행")
        self.tableView.reloadData()
    }
}
