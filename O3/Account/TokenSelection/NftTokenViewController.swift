//
//  NftTokenViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 5/1/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class NftSelectionViewController: UIViewController {
    @IBOutlet weak var animationView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let lottieView = LOTAnimationView(name: "empty_status")
        lottieView.frame = animationView.bounds
        lottieView.loopAnimation = true
        animationView.addSubview(lottieView)
        lottieView.play()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rotateView(targetView: animationView)
    }

    private func rotateView(targetView: UIView, duration: Double = 1.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(Double.pi / -2))
        }) { _ in
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveLinear, animations: {
                targetView.frame.origin.y = -200
                targetView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

            }) { _ in
            }
        }
    }

}
