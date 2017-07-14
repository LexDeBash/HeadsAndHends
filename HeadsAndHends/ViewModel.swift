//
//  ViewModel.swift
//  HeadsAndHends
//
//  Created by Alexey Efimov on 13.07.17.
//  Copyright © 2017 LDB. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

class ViewModel {
    
    private struct Constants {
        static let baseURL = "http://api.openweathermap.org/data/2.5/weather?q=Moscow"
        static let APPID = "&appid=ee9ad474d45b7f839b17b65bc4f40af3"
    }
    
    let disposeBag = DisposeBag()
    var searchText = PublishSubject<String?>()
    var cityName = PublishSubject<String>()
    var degrees = PublishSubject<String>()
    
    var weather: Weather? {
        didSet {
            if let name = weather?.cityName {
                DispatchQueue.main.async() {
                    self.cityName.onNext(name)
                }
            }
            if let temp = weather?.degrees {
                DispatchQueue.main.async() {
                    self.degrees.onNext("\(temp)°F")
                }
            }
        }
    }
    
    init() {
        let jsonRequest = searchText
            .map { text in
                return URLSession.shared.rx.json(url: self.getURLForString(text: text!))
            }
            .switchLatest()
        
        jsonRequest
            .subscribe(onNext: { (json) in
                self.weather = Weather(json: json as AnyObject)
            })
            .addDisposableTo(disposeBag)
    }
    
    
    func getURLForString(text: String) -> URL{
        let url = URL(string: String(format: "%@%@%@",Constants.baseURL,text.replacingOccurrences(of: " ", with: "%20"), Constants.APPID))
        return url!
    }
    
    
//    init() {
//        let searchTextObservable: Observable<String?> = self.searchText
//        searchTextObservable
//            .filter { query in
//                guard let query = query else {
//                    return false
//                }
//                return query.characters.count > 2
//            }
//            .debounce(0.5, scheduler: MainScheduler.instance)
//            .map { query in
//                let apiUrl = self.getURLForString(query?.replacingOccurrences(of: " ", with: "%20"), Constants.URLPostfix)
//                return URLRequest(url: apiUrl)
//            }
//            .flatMapLatest { request in
//                return URLSession.shared.rx.json(request: request)
//                    .catchErrorJustReturn([])
//            }
//            .map { json ->  [String: Any] in
//                guard let json = json as? [String: Any] else {
//                    return ["json error": "on no!"]
//                }
//                return json
//            }
//            .subscribe(onNext: { (json) in
//                print("json: \(json)")
//                self.weather = Weather(json: json as AnyObject)
//            })
//            .addDisposableTo(disposeBag)
//    }
    
//    func getURLForString(_ string: String) -> URL? {
//        
//        guard let plistPath = Bundle.main.path(forResource: "Keys", ofType: "plist", inDirectory: "Secrets") else {
//            return nil
//        }
//        
//        guard let keys = NSDictionary(contentsOfFile: plistPath) else {
//            return nil
//        }
//        
//        guard let key = keys["weather"] as? String else {
//            return nil
//        }
//
//        
//        let urlString = "\(Constants.URLPrefix)\(string)&appid=\(key)"
//        return URL(string: urlString)
//    }
}