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
    
    let disposeBag = DisposeBag()
    
    var searchText = PublishSubject<String?>()
    var cityName = PublishSubject<String>()
    var degrees = PublishSubject<String>()
    
    var weather: Weather?

    init() {
        let jsonRequest = searchText
            .map { city in
                self.getURLForString(city: city!)
            }
        
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
                        if let name = self.weather?.cityName {
                            self.weather?.cityName = json["city"]["name"].stringValue
                            DispatchQueue.main.async() {
                                self.cityName.onNext(name)
                            }
                        }
                        if let temp = self.weather?.degrees {
                            self.weather?.degrees = json["list"][0]["main"]["temp"].doubleValue
                            DispatchQueue.main.async() {
                                self.degrees.onNext("\(temp)°C")
                            }
                        }
                        
                    }
                case .failure(let error):
                print(error)
            
            }
        }
    }

}
