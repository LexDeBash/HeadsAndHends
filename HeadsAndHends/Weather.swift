//
//  Weather.swift
//  HeadsAndHends
//
//  Created by Alexey Efimov on 13.07.17.
//  Copyright © 2017 LDB. All rights reserved.
//

import Foundation
import SwiftyJSON

class Weather {
    var cityName: String?
    var degrees: Double?
    
    init(json: AnyObject) {
        let data = JSON(json)
        self.cityName = data["name"].stringValue
        self.degrees = data["main"]["temp"].doubleValue
    }
}
