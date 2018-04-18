//
//  TokenSaleSuccessViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 4/16/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit
import Lottie

class TokenSaleSuccessViewController: UIViewController {
    
    @IBOutlet var animationView: UIView!
    
    func setThemedElements() {
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setThemedElements()
        let lottieView = LOTAnimationView(name: "success-blue")
        lottieView.frame = animationView.bounds
        animationView.addSubview(lottieView)
        lottieView.play{ (finished) in
            
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
