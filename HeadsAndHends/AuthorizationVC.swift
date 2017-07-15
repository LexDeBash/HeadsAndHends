//
//  AuthorizationVC.swift
//  HeadsAndHends
//
//  Created by Alexey Efimov on 12.07.17.
//  Copyright © 2017 LDB. All rights reserved.
//

import UIKit

class AuthorizationVC: UIViewController {
    
    @IBOutlet weak var bottomConstr: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideBackBarBiutton()
        didTapOnView()
        keyBoardWilShowOrHide()
    }
    
    // MARK: Методы viewDidLoad
    
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
    
    @IBAction func autorizationButton(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    @IBAction func registrationButton(_ sender: UIButton) {
        view.endEditing(true)
    }

}
