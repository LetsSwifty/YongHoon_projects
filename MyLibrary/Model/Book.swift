//
//  Book.swift
//  MyLibrary
//
//  Created by YongHoon Lee on 2022/05/05.
//

import UIKit

struct Book: Decodable {
    var title: String?
    var link: String?
    var image: String?
    var price: String?
    var isbn: String?  //ISBN 값은 고유값이므로 id처럼 쓰이기에 적절하다
    var description: String?
}

//MyData는 책 객체에 대한 데이터 및 썸네일 이미지를 네트워크로부터 load&save하는 역할의 클래스이다
//이를 위해 네이버의 '검색 API'를 사용한다
class MyData {
    struct Books: Decodable {
        var items = [Book]()  //MainView의 테이블 뷰로 보여질 책 객체가 담길 배열
    }
    var books = Books()  //네트워크를 통해 받아올 책들에 대한 데이터가 담길 구조체
    var cachedImages = [String: UIImage]() //다운로드한 이미지는 캐싱되어 배열에 저장된다
    var delegate: ReloadDelegate?
    
    
    //API를 통해 네트워크로부터 책 정보를 fetch하는 메소드
    func loadData(queryValue: String, startNumber: Int) {
        let clientID = "a1lJiKnykL2yi685kq2o"
        let clientSecret = "PuliAFL7zT"
        
        //URL 객체 생성 과정
        let urlString = "https://openapi.naver.com/v1/search/book.json?query=\(queryValue)&display=10&start=\(startNumber)"
        let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        guard let url = URL(string: encodedURLString) else {
            fatalError("Wrong URL value: \(urlString)")
        }
        
        //HTTP 헤더 생성 과정
        //Q) Swift의 request는 GET 메소드가 디폴트??
        var request = URLRequest(url: url)
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to fetch: \(error.localizedDescription)")
                return
            } else {
                if let data = data {
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(Books.self, from: data) {
                        //네트워크의 책 객체를 Swift의 Book 객체로 변환 & 배열에 추가
                        for book in decodedData.items {
                            var title = book.title?.replacingOccurrences(of: "<b>", with: "")  //쿼리된 문자열은 볼드로 표시되기 위해 <b>~~</b>로 마킹된다. 이를 공백문자로 replace한다
                            title = title?.replacingOccurrences(of: "</b>", with: "")
                            let link = book.link ?? "N/A"
                            let image = book.image ?? "N/A"
                            let price = book.price ?? "N/A"
                            var description = book.description?.replacingOccurrences(of: "<b>", with: "") ?? "설명이 없습니다"
                            description = description.replacingOccurrences(of: "</b>", with: "")  //descriptiion은 nil coalescing으로인해 String 타입이 된다
                            self.books.items.append(Book(title: title, link: link, image: image, price: price, isbn: book.isbn, description: description))
                        }
                    } else {
                        print("Failed to decode")
                    }
                    self.delegate?.reload()  //네트워킹이 끝나면 MainView의 테이블 뷰를 reload한다
                    return
                }
            }
        }.resume()
    }
    
    //이미지의 address 값을 통해 이미지를 fetch한다
    func loadImage(isbn: String?, urlString: String) -> UIImage {
        guard let isbn = isbn else {
            print("loadImage(): ISBN value is nil")
            return UIImage()
        }
        
        //캐싱된 이미지가 있다면 해당 이미지를 return 한다
        if let savedImage = self.cachedImages[isbn] {
            return savedImage
        } else {
            guard let url = URL(string: urlString) else {
                print("loadImage(): Invalid url")
                return UIImage()
            }
            //이 부분은 좀 더 면밀히 파고들 필요가 있다. 현재 잘 쓰이는 방법인지는 모르겠다
            guard let imgData = try? Data(contentsOf: url) else {
                print("loadImage(): Invalid image source")
                return UIImage()
            }
            guard let image = UIImage(data: imgData) else {
                print("loadImage(): Failed to initialize UIImage")
                return UIImage()
            }
            self.cachedImages[isbn] = image
            return image
        }
    }
}
