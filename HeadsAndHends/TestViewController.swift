//
//  TestViewController.swift
//  HeadsAndHends
//
//  Created by Alexey Efimov on 13.07.17.
//  Copyright © 2017 LDB. All rights reserved.
//

import UIKit
import RxSwift

class TestViewController: UIViewController {

    let viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.cityName.bind(to: cityNameLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.degrees.bind(to: degreesLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        cityNameTextField.rx.text.subscribe(onNext: { text in
            self.viewModel.searchText.onNext(text)
        })
            .addDisposableTo(disposeBag)
    }
}
