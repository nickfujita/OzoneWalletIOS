//
//  OnboardingHomeViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/16/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit
import NeoSwift
import SwiftTheme
import LocalAuthentication

class OnboardingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionPageControl: UIPageControl!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createNewWalletButton: UIButton!
    @IBOutlet weak var newToO3Label: UILabel!
    var features: [OnboardingCollectionCell.Data]!

    let loginNoPassCodeError = NSLocalizedString("ONBOARDING_Login_No_Passcode_Error", comment: "Error message that is displayed when the user tries to login without a passcode")
    let createWalletNoPassCodeError = NSLocalizedString("ONBOARDING_Create_Wallet_No_Passcode_Error", comment: "Error message that is displayed when the user tries to Create a New Wallet without a passcode")

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        self.navigationController?.hideHairline()
        ThemeManager.setTheme(index: 2)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(hexString: "#0069D9FF")!
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onboardingCollectionCell", for: indexPath) as? OnboardingCollectionCell else {
            fatalError("undefined table view behavior")
        }
        let data = features[indexPath.row]
        cell.data = data
        cell.backgroundColor = UIColor(hexString: "#0069D9FF")!
        cell.onboardingImage.image = UIImage(named: data.imageName)
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        collectionPageControl.currentPage = currentPage
        // Do whatever with currentPage.
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width, height: screenSize.height * 0.6)
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        if !LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            OzoneAlert.alertDialog(message: loginNoPassCodeError, dismissTitle: OzoneAlert.okPositiveConfirmString) {}
            return
        }
        performSegue(withIdentifier: "segueToLogin", sender: nil)
    }

    @IBAction func createNewWalletButtonTapped(_ sender: Any) {
        //if user doesn't have wallet we then create one
        if !LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            OzoneAlert.alertDialog(message: createWalletNoPassCodeError, dismissTitle: OzoneAlert.okPositiveConfirmString) {}
            return
        }
        if UserDefaultsManager.o3WalletAddress == nil {
            Authenticated.account = Account()
            performSegue(withIdentifier: "segueToWelcome", sender: nil)
            return
        }
        performSegue(withIdentifier: "preCreateWallet", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToWelcome" {
            //create a new wallet
            Authenticated.account = Account()
        }
    }

    func setLocalizedStrings() {
        let titleOne = NSLocalizedString("ONBOARDING_Tutorial_Title_One", comment: "The first title in the onboarding pages")
        let titleTwo = NSLocalizedString("ONBOARDING_Tutorial_Title_Two", comment: "The second title in the onboarding pages")
        let titleThree = NSLocalizedString("ONBOARDING_Tutorial_Title_Three", comment: "The third title in the onboarding pages")

        let subtitleOne = NSLocalizedString("ONBOARDING_Tutorial_Subtitle_One", comment: "The first subtitle in the onboarding pages")
        let subtitleTwo = NSLocalizedString("ONBOARDING_Tutorial_Subtitle_Two", comment: "The second subtitle in the onboarding pages")
        let subtitleThree = NSLocalizedString("ONBOARDING_Tutorial_Subtitle_Three", comment: "The third subtitle in the onboarding pages")

        features = [
            OnboardingCollectionCell.Data(imageName: "chart", title: titleOne, subtitle: subtitleOne),
            OnboardingCollectionCell.Data(imageName: "lock", title: titleTwo, subtitle: subtitleTwo),
            OnboardingCollectionCell.Data(imageName: "exchange", title: titleThree, subtitle: subtitleThree)
        ]

        loginButton.setTitle(NSLocalizedString("ONBOARDING_Login_Title", comment: "Title for all login items in the onboarding flow"), for: UIControlState())
        createNewWalletButton.setTitle(NSLocalizedString("ONBOARDING_Create_New _Wallet", comment: "Title For Creating a New Wallet in the onboarding flow"), for: UIControlState())
        newToO3Label.text = NSLocalizedString("ONBOARDING_New To O3?", comment: "Welcome label to create a new wallet")
    }
}
