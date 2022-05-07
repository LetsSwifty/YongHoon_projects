//
//  ViewController.swift
//  MyLibrary
//
//  Created by YongHoon Lee on 2022/05/04.
//

import UIKit

class ViewController: UIViewController {
    var books = Books()
    var booksList = [Book]() //테이블 뷰에 보여질 책 리스트
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for book in books.data.values {
            self.booksList.append(book)
        }
        self.booksList.sort {
            $0.id < $1.id
        }
    }
    
    @IBAction func nextPage(_ sender: UIBarButtonItem) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "userDetailView") as? UserDetailViewController else {
            return
        }
        vc.books = self.books
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = booksList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell") as! BookCell
        cell.title?.text = book.title
        cell.desc?.text = book.desc
        cell.id = book.id
        
        //현재 셀의 book.id가 user.myBooks에 존재한다면 disabled된 체크표시 버튼으로 세팅한다
        if let _ = User.shared.myBooks[book.id] {
            print("이미 추가된 책: \(book.title)")
            cell.addButton?.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            //option) tint color를 green으로 할 것
            cell.addButton?.isEnabled = false
        } else {
            cell.addButton?.setImage(UIImage(systemName: "plus.circle"), for: .normal)
            cell.addButton?.isEnabled = true
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        print("asdasd")
    }
}
