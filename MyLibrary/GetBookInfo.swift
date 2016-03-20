//
//  GetBookInfo.swift
//  MyLibrary
//
//  Created by 矢野篤史 on 2016/03/19.
//  Copyright © 2016年 矢野篤史. All rights reserved.
//

import Foundation

class GetBookInfo {
    let apiUrl: String = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20130522"
    let app_id: String = "1066597605805030286"
    var bookInfoArray = [BookInfo]()
    
    func getInfo (isbn: String) {
        //let isbnA: String = "9784797384512"
        //let parameter = ["applicationId":app_id, "isbn":isbnA]
        //let requestUrl = createRequestUrl(parameter)
        let requestUrl = createRequestUrl()
        request(requestUrl)
    }
    
    //リクエストURLを生成する
    //func createRequestUrl(parameter :[String:String?]) -> String {
    func createRequestUrl() -> String {
        let isbnA: String = "9784797384512"
        let parameter = ["applicationId":app_id, "isbn":isbnA]
        var parameterString = ""
        for key in parameter.keys {
            if let value = parameter[key] {
                if parameterString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                    parameterString += "&"
                }
                
                if let escapeValue = value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
                    parameterString += "\(key)=\(escapeValue)"
                }
            }
        }
        return apiUrl + "?" + parameterString
    }
 
    //APIにリクエストを送信し、結果を得る
    func request(requestUrl: String) {
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: requestUrl)
        let request = NSURLRequest(URL: url!)
        let task = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, resp:NSURLResponse?, err:NSError?) -> Void in
            if let data = data {
                do {
                    var abc = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
                    var c = abc["Items"] as! NSArray
                    var d = c[0] as! NSDictionary
                    var e = d["Item"] as! NSDictionary
                    self.parseResponseData(e)
                } catch  {
                    // エラーが起こったらここに来るのでエラー処理などをする
                }
            }
        })
        task.resume()
    }
    
    
    //結果をパースして配列に格納
    func parseResponseData(resultSet: NSDictionary) {
        //for var itemIndex = 0; itemIndex < resultSet.count; itemIndex++ {
        let bookInfo = BookInfo()
        bookInfo.bookName = resultSet["title"] as? String
        bookInfo.bookImageUrl = resultSet["mediumImageUrl"]  as? String
        bookInfoArray.append(bookInfo)
    }
    
}