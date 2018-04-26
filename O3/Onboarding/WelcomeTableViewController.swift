//
//  WelcomeTableViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/16/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess
import PKHUD
import NeoSwift
import SwiftTheme

class WelcomeTableViewController: UITableViewController {
    @IBOutlet weak var privateKeyQR: UIImageView!
    @IBOutlet weak var privateKeyLabel: UILabel!
    @IBOutlet weak var pleaseBackupWarning: UILabel!
    @IBOutlet weak var privateKeyTitle: UILabel!
    @IBOutlet weak var startButton: ShadowedButton!

    let keychainFailureError = NSLocalizedString("ONBOARDING_Keychain_Failure_Error", comment: "Error message to display when the system fails to retrieve the private key from the keychain")
    let haveSavedPrivateKeyConfirmation =
        NSLocalizedString("ONBARDING_Confirmed_Private_Key_Saved_Prompt", comment: "A prompt asking the user to please confirm that they have indeed backed up their private key in a secure location before continuing")
    let selectingBestNodeTitle = NSLocalizedString("ONBOARDING_Selecting_Best_Node", comment: "Displayed when the app is waiting to connect to the network. It is finding the best NEO node to connect to")

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 1))
        self.privateKeyQR.image = UIImage(qrData: Authenticated.account?.wif ?? "", width: self.privateKeyQR.frame.width, height: self.privateKeyQR.frame.height)
        self.privateKeyLabel.text = Authenticated.account?.wif ?? ""

        let keychain = Keychain(service: "network.o3.neo.wallet")
        DispatchQueue.global().async {
            do {
                try keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                    .authenticationPrompt("")
                    .set((Authenticated.account?.wif)!, key: "ozonePrivateKey")
            } catch _ {
                DispatchQueue.main.async {
                    OzoneAlert.alertDialog(message: self.keychainFailureError, dismissTitle: OzoneAlert.okPositiveConfirmString) {
                        Authenticated.account = nil
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func startTapped(_ sender: Any) {
        OzoneAlert.confirmDialog(message: haveSavedPrivateKeyConfirmation, cancelTitle: OzoneAlert.notYetNegativeConfirmString, confirmTitle: OzoneAlert.confirmPositiveConfirmString, didCancel: {}) {
            DispatchQueue.main.async {
                HUD.show(.labeledProgress(title: nil, subtitle: self.selectingBestNodeTitle))
                DispatchQueue.global(qos: .background).async {
                    let bestNode = NEONetworkMonitor.autoSelectBestNode()
                    DispatchQueue.main.async {
                        HUD.hide()
                        if bestNode != nil {
                            UserDefaultsManager.seed = bestNode!
                            UserDefaultsManager.useDefaultSeed = false
                        }
                        ThemeManager.setTheme(index: UserDefaultsManager.themeIndex)
                        UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                    }
                }
            }
        }
    }

    func setLocalizedStrings() {
        pleaseBackupWarning.text = NSLocalizedString("ONBOARDING_Please_Backup Warning", comment: "A warning given to the user to make sure that they have backed up their private key in a secure location. Also states that deletibg the passcode will delete the key from the device")
        privateKeyTitle.text = NSLocalizedString("ONBOARDING_Private_Key_title", comment: "A title presented over the top of the private key, specifies WIF format. e.g. Your Private Key (WIF)")
        self.title = NSLocalizedString("ONBOARDING_Welcome", comment: "Title Welciming the user after successful wallet creation")
        startButton.setTitle(NSLocalizedString("ONBOARDING_Start_Action_Title", comment: "Title to start the app after completing the onboarding"), for: UIControlState())
    }
}
