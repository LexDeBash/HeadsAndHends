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
import Alamofire

class ViewModel {
    
//    private struct Constants {
//        static let baseURL = "http://api.openweathermap.org/data/2.5/weather?q=Moscow"
//        static let APPID = "&appid=ee9ad474d45b7f839b17b65bc4f40af3"
//    }
    
    let disposeBag = DisposeBag()
    var searchText = PublishSubject<String?>()
    var cityName = PublishSubject<String>()
    var degrees = PublishSubject<String>()
    
    var weather: Weather?
//    {
//        didSet {
//            if let name = weather?.cityName {
//                DispatchQueue.main.async() {
//                    self.cityName.onNext(name)
//                }
//            }
//            if let temp = weather?.degrees {
//                DispatchQueue.main.async() {
//                    self.degrees.onNext("\(temp)°F")
//                }
//            }
//        }
//    }
    

    init() {
        let jsonRequest = searchText
            .map { city in
                self.getURLForString(city: city!)
//                return URLSession.shared.rx.json(url: self.getURLForString(city: city!))
            }
//            .switchLatest()
        
        jsonRequest
            .subscribe(onNext: { (json) in
                self.weather = Weather(json: json as AnyObject)
            })
            .addDisposableTo(disposeBag)
    }
    
    func getURLForString(city: String) {
        let prefixURL = "http://api.openweathermap.org/data/2.5/forecast"
        let postfixURL = ["q": city, "units": "metric", "appid": "cc43de317c7b45042d6dd7d09ee12d74"]

        Alamofire.request(prefixURL, method: .get, parameters: postfixURL).validate().responseJSON { response in
            switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print(json["city"]["name"])
                        print(json["list"][0]["main"]["temp"])
                        
                        for (_,subJson):(String, JSON) in json["list"] {
                            
                            self.weather?.cityName = subJson["city"]["name"].stringValue
                            self.weather?.degrees = subJson["main"]["temp"].doubleValue
                            
                            if let name = self.weather?.cityName {
                                DispatchQueue.main.async() {
                                    self.cityName.onNext(name)
                                }
                            }
                            if let temp = self.weather?.degrees {
                                DispatchQueue.main.async() {
                                    self.degrees.onNext("\(temp)°C")
                                }
                            }
                        }
                    }
                case .failure(let error):
                print(error)
            
            }
        }
    }
    
//    func getURLForString(city: String) -> URL{
//        let url = URL(string: String(format: "%@%@%@",Constants.baseURL,city.replacingOccurrences(of: " ", with: "%20"), Constants.APPID))
//        return url!
//    }
    
    
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
