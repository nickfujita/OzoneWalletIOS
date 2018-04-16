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

    var transactionInfo: TokenSaleTableViewController.TokenSaleTransactionInfo!
    var logoURL: String = ""

    func setThemedElements() {
        let checkboxIssuer = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0))
        checkboxIssuer.secondaryTintColor = Theme.light.primaryColor
        checkboxIssuer.tintColor = Theme.light.primaryColor
        checkboxIssuer.checkmarkLineWidth = 2.0
        issueAgreementCheckboxContainer.addSubview(checkboxIssuer)
        let checkboxO3 = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0))
        checkboxO3.secondaryTintColor = Theme.light.accentColor
        checkboxO3.tintColor = Theme.light.accentColor
        checkboxO3.checkmarkLineWidth = 2.0
        o3AgreementCheckboxContainer.addSubview(checkboxO3)

        tableView.theme_separatorColor = O3Theme.tableSeparatorColorPicker
        tableView.theme_backgroundColor = O3Theme.backgroundColorPicker
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
        sendTitleLabel.theme_textColor = O3Theme.titleColorPicker
        receiveTitleLabel.theme_textColor = O3Theme.titleColorPicker
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        participateButton.isEnabled = false
        setThemedElements()
        logoImageView.kf.setImage(with: URL(string: logoURL))
        assetToSendLabel.text = transactionInfo.assetAmount.description +
            transactionInfo.assetNameUsedToPurchase.description
        assetToRecieveLabel.text = transactionInfo.tokensToRecieveAmount.description + transactionInfo.tokensToReceiveName
    }

    @IBAction func partcipateTapped(_ sender: Any) {
        // TODO: PERFORM TRANSACTION AND FIGURE OUT IF IT SUCCEEDED OR NOT
        // SEGUE TO THE RELEVANT SCREEN
        self.performSegue(withIdentifier: "transactionCompletedSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? SendCompleteViewController else {
            return
        }
        dest.transactionSucceeded = true
    }

}
