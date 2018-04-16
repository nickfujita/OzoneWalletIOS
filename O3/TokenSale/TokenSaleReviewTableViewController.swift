//
//  TokenSaleReviewTableViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 4/13/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit
import M13Checkbox
import Kingfisher
import NeoSwift

class TokenSaleReviewTableViewController: UITableViewController {
    @IBOutlet weak var issueAgreementCheckboxContainer: UIView!
    @IBOutlet weak var o3AgreementCheckboxContainer: UIView!
    @IBOutlet weak var participateButton: ShadowedButton!
    @IBOutlet weak var assetToSendLabel: UILabel!
    @IBOutlet weak var assetToRecieveLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var sendTitleLabel: UILabel!
    @IBOutlet weak var receiveTitleLabel: UILabel!
    
    let checkBoxO3 = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0))
    let checkBoxIssuer = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0))
    
    var transactionInfo: TokenSaleTableViewController.TokenSaleTransactionInfo!
    var logoURL: String = ""
    
    func setThemedElements() {
        checkBoxIssuer.secondaryTintColor = Theme.light.primaryColor
        checkBoxIssuer.tintColor = Theme.light.primaryColor
        checkBoxIssuer.checkmarkLineWidth = 2.0
        issueAgreementCheckboxContainer.addSubview(checkBoxIssuer)
        checkBoxO3.secondaryTintColor = Theme.light.accentColor
        checkBoxO3.tintColor = Theme.light.accentColor
        checkBoxO3.checkmarkLineWidth = 2.0
        o3AgreementCheckboxContainer.addSubview(checkBoxO3)
        
        tableView.theme_separatorColor = O3Theme.tableSeparatorColorPicker
        tableView.theme_backgroundColor = O3Theme.backgroundColorPicker
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
        sendTitleLabel.theme_textColor = O3Theme.titleColorPicker
        receiveTitleLabel.theme_textColor = O3Theme.titleColorPicker
    }
    
    @objc func checkParticipateEnabledState() {
        if checkBoxO3.state == .selected && checkBoxO3.state == .selected {
            participateButton.isEnabled = true
        }
        participateButton.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setThemedElements()
        logoImageView.kf.setImage(with: URL(string: logoURL))
        assetToSendLabel.text = transactionInfo.assetAmount.description +
            transactionInfo.assetNameUsedToPurchase.description
        assetToRecieveLabel.text = transactionInfo.tokensToRecieveAmount.description + transactionInfo.tokensToReceiveName
    }
    
    @IBAction func partcipateTapped(_ sender: Any) {
        
        #if PRIVATENET
        UserDefaultsManager.seed = "http://localhost:30333"
        UserDefaultsManager.useDefaultSeed = false
        UserDefaultsManager.network = .privateNet
        Authenticated.account?.neoClient = NeoClient(network: .privateNet)
        #endif
        
        
        if checkBoxO3.checkState == .checked && checkBoxIssuer.checkState == .checked {
            
            
            let fee = transactionInfo.priorityIncluded == true ? Float64(0.0011) : Float64(0)
            
            Authenticated.account?.participateTokenSales(scriptHash: transactionInfo.tokenSaleContractHash, assetID: transactionInfo.assetIDUsedToPurchase, amount: transactionInfo.assetAmount, remark: "O3X", networkFee: fee) { success, error in
            
                if success == true {
                    self.performSegue(withIdentifier: "success", sender: nil)
                    return
                }
                self.performSegue(withIdentifier: "error", sender: nil)
            }
            
        } else {
            OzoneAlert.alertDialog(message: "Please aggree to the disclaimers", dismissTitle: "OK") { }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "success" {
            //send info
        }
    }
    
}
