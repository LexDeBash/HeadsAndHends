//
//  AuthorizationVC.swift
//  HeadsAndHends
//
//  Created by Alexey Efimov on 12.07.17.
//  Copyright © 2017 LDB. All rights reserved.
//

import UIKit

class AuthorizationVC: UIViewController {
    
    let dataExample = DataExample()
    
    var login: String?
    var password: String?
    var usersDict = [String: String]()
    
    
    @IBOutlet weak var bottomConstr: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login = ""
        password = ""
        
        dataExample.setLogin(login!)
        dataExample.setPassword(password!)
        getUsers()
        hideBackBarBiutton()
        didTapOnView()
        keyBoardWilShowOrHide()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getValues()
        getUsers()
    }
    
    // MARK: viewDidLoad
    
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
    
    func getValues() {
        if let loginValue = dataExample.getLogin() {
            login = loginValue
        }
        
        if let passwordValue = dataExample.getPassword() {
            password = passwordValue
        }
    }
    
    // MARK: Keyboard
    
    // Скрываем клавиатуру по тапу на вью
    func didTapView() {
        view.endEditing(true)
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
    
    // Удаление наблюдателей
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    //Удаляем уведомления после закрытия вьюконтроллера
    deinit {
        removeKeyboardNotification()
    }
    
    //MARK: Autorization
    
    @IBAction func autorizationPressed(_ sender: UIButton) {
        viewDidAppear(true)
        print(login!)
        print(password!)
        print("userDict \(usersDict)")
        guard login?.characters.count != 0 && password?.characters.count != 0 else {
            return alertController("Авторизация", message: "Введите логин и пароль")
        }
        
        // Проверка имени пользователя
        guard usersDict.isEmpty == false else {
            return alertController("Авторизация", message: "Не верное имя пользователя или пароль")
        }
        var loginIsTrue = false
        var passwordIsTrue = false
        
        for userLogin in usersDict.keys {
            if userLogin == login {
                loginIsTrue = true
            }
        }
        
        for userPassword in usersDict.values {
            if userPassword == password {
                passwordIsTrue = true
            }
        }
        guard loginIsTrue && passwordIsTrue else {
            return alertController("Авторизация", message: "Не верное имя пользователя или пароль")
        }
        
        performSegue(withIdentifier: "Weather", sender: sender)
        view.endEditing(true)
    }
    
    @IBAction func registrationPressed(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    func alertController(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    

}
