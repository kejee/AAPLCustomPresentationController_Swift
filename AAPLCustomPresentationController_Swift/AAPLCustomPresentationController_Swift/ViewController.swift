//
//  ViewController.swift
//  AAPLCustomPresentationController_Swift
//
//  Created by HYapple on 2024/4/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didClickShowButton(_ sender: Any) {
        TestViewController.showTestViewController(from: self)
    }
    
}

