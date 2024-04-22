//
//  TestViewController.swift
//  AAPLCustomPresentationController_Swift
//
//  Created by HYapple on 2024/4/22.
//

import UIKit

class TestViewController: UIViewController {

    // MARK: -
    
    static func showTestViewController(from parent: UIViewController) {
        let vc = TestViewController()

        let presentationController = AAPLCustomPresentationController_Swift(presentedViewController: vc, presenting: parent)
        vc.transitioningDelegate = presentationController
  
        parent.present(vc, animated: true, completion: nil)
        
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredContentSizeWithTraitCollection(self.traitCollection)
        
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addRoundedCorners(corners: [.topLeft, .topRight], radius: 8)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension TestViewController {
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        updatePreferredContentSizeWithTraitCollection(newCollection)
    }
    
    
    func updatePreferredContentSizeWithTraitCollection(_ newCollection: UITraitCollection) {
        let w = getScreenWidth()
        let h = getScreenHeight()
        self.preferredContentSize = CGSize(width: w, height: h*0.7)
    }
}

