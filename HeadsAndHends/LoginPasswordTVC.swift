//
//  LoginPasswordTVC.swift
//  HeadsAndHends
//
//  Created by Alexey Efimov on 13.07.17.
//  Copyright © 2017 LDB. All rights reserved.
//

import UIKit

class LoginPasswordTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: Работа с клавиатурой

    // Скрытие клавиатуры по клавише "Готово" на текстовой клавиатуре
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
