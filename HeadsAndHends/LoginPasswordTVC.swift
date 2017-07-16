//
//  LoginPasswordTVC.swift
//  HeadsAndHends
//
//  Created by Alexey Efimov on 13.07.17.
//  Copyright © 2017 LDB. All rights reserved.
//

import UIKit

class LoginPasswordTVC: UITableViewController {
    
    let dataExamle = DataExample()
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Работа с клавиатурой

    // Скрытие клавиатуры по клавише "Готово" на текстовой клавиатуре
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: DataExample
    @IBAction func autorizationLogin(_ sender: UITextField) {
        if sender.text?.isEmpty == false {
            dataExamle.setLogin(sender.text!)
        }
    }
    
    @IBAction func autorizationPassword(_ sender: UITextField) {
        if sender.text?.isEmpty == false {
            dataExamle.setPassword(sender.text!)
        }
    }
    
}
