//
//  AuthorizationVC.swift
//  HeadsAndHends
//
//  Created by Alexey Efimov on 12.07.17.
//  Copyright © 2017 LDB. All rights reserved.
//

import UIKit

class AuthorizationVC: UIViewController {
    
    @IBOutlet var bottomConstr: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        // Отслеживаем тап по вью для скрытия клавиатуры
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AuthorizationVC.didTapView))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
        
        // Подписываемся на уведомления о появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Работа с клавиатурой
    // Скрываем клавиатуру по тапу на вью
    func didTapView() {
        view.endEditing(true)
    }
    
    // Поднимаем скролл вью над клавиатурой
    func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - bottomConstr.constant + 20
            }
        }
    }
    
    // Возвращаем скролл вью на место
    func keyboardWillHide(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height - bottomConstr.constant + 20
            }
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

}
