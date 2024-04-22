//
//  Utils.swift
//  AAPLCustomPresentationController_Swift
//
//  Created by HYapple on 2024/4/22.
//

import UIKit

func getScreenWidth() -> CGFloat {
    if #available(iOS 13.0, *) {
        if let currentScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let kWidth = currentScene.coordinateSpace.bounds.size.width
            return kWidth
        }
    }
    return UIScreen.main.bounds.size.width
}


func getScreenHeight() -> CGFloat {
    if #available(iOS 13.0, *) {
        if let currentScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let kHeight = currentScene.coordinateSpace.bounds.size.height
            return kHeight
        }
    }
    return UIScreen.main.bounds.size.height
}



extension UIView {
    func addRoundedCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}
