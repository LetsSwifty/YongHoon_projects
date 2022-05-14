//
//  MyBookCell.swift
//  MyLibrary
//
//  Created by YongHoon Lee on 2022/05/07.
//

import UIKit

class MyBookCell: UITableViewCell {
    var isbn: String?
    var parentVC: UIViewController!  //부모 VC는 UIViewController의 alert을 띄우기 위해 선언하는 것이다
    var delegate: ReloadDelegate?
    @IBOutlet var img: UIImageView!
    @IBOutlet var title: UILabel!
    
    //🗑: User 객체의 deleteBook() 메소드를 사용한다
    @IBAction func del(_ sender: UIButton) {
        //alert 객체 선언
        let alert = UIAlertController(title: "내 라이브러리에서 삭제", message: "정말 삭제하시나요?", preferredStyle: .alert)
        
        //삭제 버튼을 눌렀을 때
        let confirm = UIAlertAction(title: "삭제", style: .destructive) { _ in
            if User.shared.deleteBook(self.isbn) {
                print("제거 완료!")
                self.delegate?.reload()  //제거한 뒤에는 ReloadDelegate 객체의 reload() 메소드를 실행하여 테이블 뷰를 리로드 한다
            } else {
                print("제거 실패")
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        parentVC.present(alert, animated: true)
    }
}

protocol ReloadDelegate {
    func reload()
}
