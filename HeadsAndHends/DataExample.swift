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
    open func setUserName(_ name: String) {
        if let defaults = UserDefaults(suiteName: self.suiteName){
            defaults.set(results, forKey: "userName")
            defaults.synchronize()
        }
    }
    
    open func setUserPassword(_ password: String) {
        if let defaults = UserDefaults(suiteName: self.suiteName){
            defaults.set(results, forKey: "userPassword")
            defaults.synchronize()
        }
    }
    
    // Геттеры для загрузки данных
    open func getUserName() -> String {
        if let defaults = UserDefaults(suiteName: self.suiteName){
            defaults.synchronize()
            return defaults.object(forKey: "userName") as? String
        }
        return nil
    }
    
    open func getUserPassword() -> String {
        if let defaults = UserDefaults(suiteName: self.suiteName){
            defaults.synchronize()
            return defaults.object(forKey: "userPassword") as? String
        }
        return nil
    }
}

