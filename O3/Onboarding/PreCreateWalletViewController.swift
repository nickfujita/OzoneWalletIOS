//
//  PreCreateWalletViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 10/28/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit
import NeoSwift

class PreCreateWalletViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var createNewWalletButton: ShadowedButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setNeedsStatusBarAppearanceUpdate()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToWelcome" {
            Authenticated.account = Account()
        }
    }

    func setLocalizedStrings() {
        self.title = NSLocalizedString("ONBOARDING_Create_New_Wallet", comment: "Title For Creating a New Wallet in the onboarding flow")
        createNewWalletButton.setTitle(NSLocalizedString("ONBOARDING_Create_New_Wallet", comment: "Title For Creating a New Wallet in the onboarding flow"), for: UIControlState())
        titleLabel.text = NSLocalizedString("ONBOARDING_Already_Have_Wallet_Explanation", comment: "When the user tries to create a new wallet, but they already have one saved on the devicve, this explanation/warning is given to the user")

    }
}
