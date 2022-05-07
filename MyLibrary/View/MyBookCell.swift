//
//  MyBookCell.swift
//  MyLibrary
//
//  Created by YongHoon Lee on 2022/05/07.
//

import UIKit

class MyBookCell: UITableViewCell {
    var id = ""
    var parentVC: UIViewController!
    @IBOutlet var title: UILabel!
    @IBOutlet var desc: UILabel!
    @IBAction func del(_ sender: UIButton) {
        let alert = UIAlertController(title: "내 라이브러리에서 삭제", message: "정말 삭제하시나요?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "삭제", style: .destructive) { _ in
            if User.shared.myBooks.removeValue(forKey: self.id) == nil {
                print("제거 실패")
            } else {
                print("제거 완료!")
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        parentVC.present(alert, animated: true)
    }
}
