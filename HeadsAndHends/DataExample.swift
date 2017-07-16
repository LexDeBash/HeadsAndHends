//
//  DataExample.swift
//  HeadsAndHends
//
//  Created by Alexey Efimov on 15.07.17.
//  Copyright © 2017 LDB. All rights reserved.
//

import Foundation

open class DataExample{
    
    // this needs to match what you set up for app group names on your targets' capabilities app group
    let suiteName = "group.LDB.HeadsAndHends"
    
    public init(){
        
    }
    
    // Сетторы для сохранения данных
    open func setUserLogin(_ login: [String: String]) {
        if let defaults = UserDefaults(suiteName: self.suiteName) {
            defaults.set(login, forKey: "userLogin")
            defaults.synchronize()
        }
    }
    
    // Геттеры для загрузки данных
    open func getUserLogin() -> [String: String] {
        if let defaults = UserDefaults(suiteName: self.suiteName){
            let login = defaults.dictionary(forKey: "userLogin") as? [String: String] ?? [String: String]()
            defaults.synchronize()
            return login
        }
        let login: [String: String] = [:]
        return login
    }
}

