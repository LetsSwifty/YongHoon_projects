//
//  ViewController.swift
//  MyLibrary
//
//  Created by YongHoon Lee on 2022/05/04.
//

import UIKit

class MainViewController: UIViewController {
    var myData = MyData()
    var startNumber = 1
    var queryValue = "건축 이야기"
    
    @IBOutlet weak var tableViewDB: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myData.delegate = self  //registration
        myData.loadData(queryValue: queryValue, startNumber: startNumber)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewDB.reloadData()    //찜하기 버튼의 상태를 업데이트하기 위해 사용한다. Q) reloadData()는 테이블 뷰 전체를 리로드 할까 아니면 변화된 부분만 리로드 할까?? 만일 후자의 경우라면 비용소모가 크므로 다른 방법으로 업데이트 해야만 한다
    }
    
    //UserDetailView로 넘어가는 버튼의 액션 메소드
    @IBAction func nextPage(_ sender: UIBarButtonItem) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "userDetailView") as? UserDetailViewController else {
            return
        }
        vc.myData = myData  //Q) 여기서 값을 복사해서 넘겨줄까 아니면 참조값만을 넘겨줄까?? 전자라면 비용소모가 크므로 다른 방법으로 참조하게끔 해야한다
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //더 보기 버튼
    @IBAction func more(_ sender: UIButton) {
        startNumber += 10
        myData.loadData(queryValue: queryValue, startNumber: startNumber)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myData.books.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = self.myData.books.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell") as! BookCell
        //썸네일 이미지 로드는 오래걸리는 작업이므로 async하게 동작시켜야 한다
        DispatchQueue.main.async {
            cell.img.image = self.myData.loadImage(isbn: book.isbn, urlString: book.image!)
        }
        cell.title?.text = book.title
        cell.desc?.text = book.description
        cell.bookData = book
        
        guard let isbn = book.isbn else {
            print("Invalid ISBN value")
            cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            return cell
        }
        
        if User.shared.isExist(isbn: isbn) {
            cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        print("cell 생성")
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
}

extension MainViewController: ReloadDelegate {
    func reload() {
        //(중요)왜 여기서 DispatchQueue.main.async를 사용해야만 하는지를 잘 생각해볼 것!
        DispatchQueue.main.async {
            self.tableViewDB.reloadData()
        }
    }
}
