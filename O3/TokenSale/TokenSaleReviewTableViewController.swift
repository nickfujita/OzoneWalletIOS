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
    
    @IBOutlet weak var readSaleAgreementLabel: UILabel! {
        didSet{
            let tap = UITapGestureRecognizer(target: self, action: #selector(readSaleAgreementTapped(_:)))
            readSaleAgreementLabel?.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var iUnderstandLabel: UILabel! {
        didSet{
            let tap = UITapGestureRecognizer(target: self, action: #selector(iUnderStandTapped(_:)))
            iUnderstandLabel?.addGestureRecognizer(tap)
        }
    }
    
    
    @objc func readSaleAgreementTapped(_ sender: Any) {
        if checkBoxIssuer.checkState == .checked {
            checkBoxIssuer.checkState = .unchecked
        } else {
            checkBoxIssuer.checkState = .checked
        }
    }
    @objc func iUnderStandTapped(_ sender: Any) {
        if checkBoxO3.checkState == .checked {
            checkBoxO3.checkState = .unchecked
        } else {
            checkBoxO3.checkState = .checked
        }
    }
    
    @IBOutlet var topSpaceConstraint: NSLayoutConstraint!
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
        
        let amountFormatter = NumberFormatter()
        amountFormatter.minimumFractionDigits = 0
        amountFormatter.numberStyle = .decimal
        amountFormatter.locale = Locale.current
        amountFormatter.usesGroupingSeparator = true
        
        if transactionInfo.assetNameUsedToPurchase.lowercased() == TransferableAsset.GAS().name.lowercased() {
            amountFormatter.maximumFractionDigits = 8
        }
        
        if transactionInfo.priorityIncluded == false {
            priorityLabel.isHidden = true
            topSpaceConstraint.constant = -8
        }
        
        assetToSendLabel.text = String(format:"%@ %@",amountFormatter.string(from: NSNumber(value: transactionInfo.assetAmount))!, transactionInfo.assetNameUsedToPurchase)
        
        assetToRecieveLabel.text = String(format:"%@ %@", amountFormatter.string(from: NSNumber(value: transactionInfo.tokensToRecieveAmount))!, transactionInfo.tokensToReceiveName)
    }
    
    @IBAction func partcipateTapped(_ sender: Any) {
        
        if checkBoxO3.checkState == .checked && checkBoxIssuer.checkState == .checked {
            
            //ask for authentication
            //if authenticated then call "submit"
            self.performSegue(withIdentifier: "submit", sender: transactionInfo)
        } else {
            OzoneAlert.alertDialog(message: "Please aggree to the disclaimers", dismissTitle: "OK") { }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "submit" {
            if let vc = segue.destination as? TokenSaleSubmitViewController {
                vc.transactionInfo = sender as! TokenSaleTableViewController.TokenSaleTransactionInfo
            }
        }
    }
    
}
