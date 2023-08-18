//
//  LoaderAnimation.swift
//  SwipeAssignment
//
//  Created by Ankur Baranwal on 17/08/23.
//

import Foundation
import UIKit

final class LoaderAnimation{
    static let shared = LoaderAnimation()
    private init(){}
    
    private let indicator: UIActivityIndicatorView? = UIActivityIndicatorView(style: .medium)
    private let screen = UIScreen.main.bounds
    
    private var appDelegate: SceneDelegate {
        guard let sceneDelegate = UIApplication.shared.connectedScenes
            .first!.delegate as? SceneDelegate else {
            fatalError("sceneDelegate is not UIApplication.shared.delegate")
        }
        return sceneDelegate
    }
    
    private var rootController:UIViewController? {
        guard let viewController = appDelegate.window?.rootViewController else {
            fatalError("There is no root controller")
        }
        return viewController
    }
    
    func showLoader() {
        indicator?.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        indicator?.frame.origin.x = (screen.width/2 - 20)
        indicator?.frame.origin.y = (screen.height/2 - 20)
        rootController?.view.addSubview(indicator!)
        indicator?.startAnimating()
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.indicator?.stopAnimating()
            self.indicator?.removeFromSuperview()
        }
    }
    
}
