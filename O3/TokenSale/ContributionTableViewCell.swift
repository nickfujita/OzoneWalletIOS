//
//  ContributionTableViewCell.swift
//  O3
//
//  Created by Andrei Terentiev on 4/13/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit
import NeoSwift

protocol ContributionCellDelegate: class {
    func setContributionAmount(amountString: String)
    func setContributionAsset(asset: TransferableAsset)
}

class ContributionTableViewCell: UITableViewCell {
    weak var delegate: ContributionCellDelegate?

    @IBOutlet weak var neoSelectorContainerView: UIView!
    @IBOutlet weak var gasSelectorContainerView: UIView!
    @IBOutlet weak var neoContainerLabel: UILabel!
    @IBOutlet weak var gasContainerLabel: UILabel!
    @IBOutlet weak var neoRateLabel: UILabel!
    @IBOutlet weak var gasRateLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var tokenAmountLabel: UILabel!

    var neoRateInfo: TokenSales.SaleInfo.AcceptingAsset!
    var gasRateInfo: TokenSales.SaleInfo.AcceptingAsset!
    var tokenName: String!
    var selectedAsset: TransferableAsset = TransferableAsset.NEO()

    func setThemedElements() {
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        theme_backgroundColor = O3Theme.backgroundColorPicker
        amountTextField.theme_backgroundColor = O3Theme.textFieldBackgroundColorPicker
        amountTextField.theme_textColor = O3Theme.textFieldTextColorPicker
        amountTextField.theme_keyboardAppearance = O3Theme.keyboardPicker
    }

    @IBAction func contributionAmountChanged(_ sender: Any) {
        guard let tokenSaleController = delegate as? TokenSaleTableViewController else {
            return
        }
        let amountString = amountTextField.text ?? ""
        if tokenSaleController.validateAmount(amountString: amountString) {
            let rate = selectedAsset.symbol.lowercased() == "neo" ? neoRateInfo : gasRateInfo
            let totalTokens = tokenSaleController.amountStringToNumber(amountString: amountString)!.doubleValue * (rate?.basicRate ?? 0)
            tokenAmountLabel.text = totalTokens.description + tokenName
            delegate?.setContributionAmount(amountString: amountString)
        }
    }

    @objc func setContributionAsset(_ sender: UITapGestureRecognizer) {
        if sender.view == neoSelectorContainerView {
            neoSelectorContainerView.borderColor = Theme.light.primaryColor
            neoContainerLabel.textColor = Theme.light.primaryColor
            neoRateLabel.textColor = Theme.light.primaryColor

            gasSelectorContainerView.borderColor = Theme.light.lightTextColor
            gasContainerLabel.textColor = Theme.light.lightTextColor
            gasRateLabel.textColor = Theme.light.lightTextColor

            delegate?.setContributionAsset(asset: TransferableAsset.NEO())
            selectedAsset = TransferableAsset.NEO()
        } else {
            gasSelectorContainerView.borderColor = Theme.light.primaryColor
            gasContainerLabel.textColor = Theme.light.primaryColor
            gasRateLabel.textColor = Theme.light.primaryColor

            neoSelectorContainerView.borderColor = Theme.light.lightTextColor
            neoContainerLabel.textColor = Theme.light.lightTextColor
            neoRateLabel.textColor = Theme.light.lightTextColor

            delegate?.setContributionAsset(asset: TransferableAsset.GAS())
            selectedAsset = TransferableAsset.GAS()
        }
    }

    override func awakeFromNib() {
        setThemedElements()
        neoSelectorContainerView.isUserInteractionEnabled = true
        gasSelectorContainerView.isUserInteractionEnabled = true
    neoSelectorContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.setContributionAsset(_:))))
    gasSelectorContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.setContributionAsset(_:))))

        neoRateLabel.text = "1 NEO = " + neoRateInfo.basicRate.description
        gasRateLabel.text = "1 GAS = " + gasRateInfo.basicRate.description
        super.awakeFromNib()
    }

}
