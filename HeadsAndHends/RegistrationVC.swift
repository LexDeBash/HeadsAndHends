//
//  RegistrationViewController.swift
//  HeadsAndHends
//
//  Created by Alexey Efimov on 15.07.17.
//  Copyright © 2017 LDB. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {
    
    let dataExample = DataExample()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firsPasswordTextField: UITextField!
    @IBOutlet weak var secondPasswordTextField: UITextField!
    
    @IBOutlet weak var bottomConstr: NSLayoutConstraint!
    
    var usersDict = [String: String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUsers()
        hideBackBarBiutton()
        didTapOnView()
        keyBoardWilShowOrHide()
        print(usersDict)
    }
    
    // MARK: Методы viewDidLoad
    
    // Загрузка словаря со списком пользователей
    func getUsers() {
        usersDict = dataExample.getUserLogin()
    }
    
    // Скрываем заголовок для кнопки возврата из навигейшин бара
    func hideBackBarBiutton() {
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
    // Отслеживаем тап по вью, для скрытия клавиатуры
    func didTapOnView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AuthorizationVC.didTapView))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Подписываемя на уведомления опоявлени клавиатуры
    func keyBoardWilShowOrHide() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Работа с клавиатурой
    
    // Скрываем клавиатуру по тапу на вью
    func didTapView() {
        view.endEditing(true)
    }
    
    // Скрытие клавиатуры по клавише "Готово" на текстовой клавиатуре
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Поднимаем элементы интерфейса над клавиатурой
    func keyboardWillShow(sender: Notification) {
        let userInfo = sender.userInfo
        let keyboardSize: CGRect = (userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardSizeWithPredictive: CGRect = (userInfo![UIKeyboardFrameEndUserInfoKey]! as! NSValue).cgRectValue
        if keyboardSize.height == keyboardSizeWithPredictive.height {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - self.bottomConstr.constant + 20
            }
        } else if keyboardSizeWithPredictive.height < keyboardSize.height {
            self.view.frame.origin.y += keyboardSize.height - keyboardSizeWithPredictive.height
        } else if keyboardSizeWithPredictive.height > keyboardSize.height {
            self.view.frame.origin.y -= keyboardSizeWithPredictive.height - keyboardSize.height
        }
    }
    
    // Возвращаем все элементы интерфейса на место
    func keyboardWillHide(_ notification:Notification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // Регитрация нового пользователя
    @IBAction func saveButton(_ sender: UIButton) {
        
        // Проверка на корректность введенных данных
        guard !(emailTextField.text?.isEmpty)! && !(firsPasswordTextField.text?.isEmpty)! && !(secondPasswordTextField.text?.isEmpty)! else {
            return alertController("Не заполненны поля", message: "Заполните логин и пароль для регистрации")
        }
        guard (emailTextField.text?.isValidEmail())! else {
            return alertController("Имя пользователя", message: "Не верный формат электронной почты")
        }

        guard firsPasswordTextField.text == secondPasswordTextField.text else {
            return alertController("Не верный пароль", message: "Повторный пароль не совпадает с первоначальным.")
        }
        
        // Проверка имени пользователя
        if usersDict.isEmpty {
            usersDict[emailTextField.text!] = firsPasswordTextField.text
            dataExample.setUserLogin(usersDict as [String: String])
        } else {
            for login in usersDict.keys {
                if login == emailTextField.text {
                    alertController("Имя пользователя уже существует", message: "")
                } else {
                    usersDict[emailTextField.text!] = firsPasswordTextField.text
                    dataExample.setUserLogin(usersDict as [String: String])
                }
            }
        }
        
        let numberInPassword = Int((firsPasswordTextField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())!)
        let upperCase: String = (firsPasswordTextField.text?.components(separatedBy: CharacterSet.uppercaseLetters.inverted).joined())!
        let lowerCase: String = (firsPasswordTextField.text?.components(separatedBy: CharacterSet.lowercaseLetters.inverted).joined())!
        
        guard (firsPasswordTextField.text?.characters.count)! >= 6
            && numberInPassword != nil
            && upperCase.characters.count != 0
            && lowerCase.characters.count != 0
            else {
            return alertController("Не верный пароль",
                                   message: "Пароль должен быть не короче 6 символов должен обязательно содержать минимум 1 строчную букву, 1 заглавную и 1 цифру")
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func alertController(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

}

extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
                                             options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count)) != nil
    }
}
