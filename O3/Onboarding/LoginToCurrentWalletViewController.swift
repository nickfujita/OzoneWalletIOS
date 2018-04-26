//
//  LoginToCurrentWalletViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 10/28/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit
import KeychainAccess
import NeoSwift
import LocalAuthentication
import SwiftTheme

class LoginToCurrentWalletViewController: UIViewController {

    @IBOutlet var loginButton: UIButton?
    @IBOutlet var mainImageView: UIImageView?
    @IBOutlet weak var cancelButton: UIButton!
    let authenticationPrompt = NSLocalizedString("ONBOARDING_Existing_Wallet_Authentication_Prompt", comment: "Prompt asking the user to authenticate themselves when they already have a wallet stored on device.")

    func login() {
        let keychain = Keychain(service: "network.o3.neo.wallet")
        DispatchQueue.global().async {
            do {
                let key = try keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                    .authenticationPrompt(self.authenticationPrompt)
                    .get("ozonePrivateKey")
                if key == nil {
                    return
                }

                guard let account = Account(wif: key!) else {
                    return
                }
                O3HUD.start()
                Authenticated.account = account
                DispatchQueue.global(qos: .background).async {
                    let bestNode = NEONetworkMonitor.autoSelectBestNode()
                    DispatchQueue.main.async {
                        if bestNode != nil {
                            UserDefaultsManager.seed = bestNode!
                            UserDefaultsManager.useDefaultSeed = false
                        }
                        O3HUD.stop {
                            SwiftTheme.ThemeManager.setTheme(index: UserDefaultsManager.themeIndex)
                            DispatchQueue.main.async { self.performSegue(withIdentifier: "loggedin", sender: nil) }
                        }
                    }
                }
            } catch _ {

            }
        }
    }
    override func viewDidLoad() {
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
        super.viewDidLoad()
        setLocalizedStrings()
        login()
    }

    @IBAction func didTapLogin(_ sender: Any) {
        login()
    }

    @IBAction func didTapCancel(_ sender: Any) {
        SwiftTheme.ThemeManager.setTheme(index: 2)
        UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController()
    }

    func setLocalizedStrings() {
        cancelButton.setTitle(NSLocalizedString("ONBOARDING_Cancel_Action", comment: "String in onboarding that specifies a cancel action"), for: UIControlState())
        if #available(iOS 8.0, *) {
            var error: NSError?
            let hasTouchID = LAContext().canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
            //if touchID is unavailable.
            //change the caption of the button here.
            if hasTouchID == false {
                loginButton?.setTitle(NSLocalizedString("ONBOARDING Login_Button_Specifying_PassCode", comment: "On authentication screen, when wallet already exists. Ask them to login using the specific type of authentication they have, e.g Login using Passcode"), for: .normal)
            } else {
                loginButton?.setTitle(NSLocalizedString("ONBOARDING Login_Button_Specifying_Biometric", comment: "On authentication screen, when wallet already exists. Ask them to login using the specific type of authentication they have, e.g Login using TouchID"), for: .normal)
            }
        }
    }
}
