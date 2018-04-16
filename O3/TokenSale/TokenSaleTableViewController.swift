//
//  TokenSaleTableViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 4/12/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit
import M13Checkbox

class TokenSaleTableViewController: UITableViewController, ContributionCellDelegate {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var priorityCheckboxContainer: UIView!
    @IBOutlet weak var participateButton: ShadowedButton!
    @IBOutlet weak var priorityInfoButton: UIButton!

    var saleInfo: TokenSales.SaleInfo!
    var selectedAsset: TransferableAsset? = TransferableAsset.NEO()
    var neoRateInfo: TokenSales.SaleInfo.AcceptingAsset?
    var gasRateInfo: TokenSales.SaleInfo.AcceptingAsset?
    var amountString: String?
    let checkboxPriority = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0))

    public struct TokenSaleTransactionInfo {
        var priorityIncluded: Bool
        var assetIDUsedToPurchase: String
        var assetNameUsedToPurchase: String
        var assetAmount: Double
        var tokenSaleContractHash: String
        var tokensToRecieveAmount: Double
        var tokensToReceiveName: String
    }

    func setThemedElements() {
        tableView.theme_separatorColor = O3Theme.tableSeparatorColorPicker
        tableView.theme_backgroundColor = O3Theme.backgroundColorPicker
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
        priorityInfoButton.theme_setTitleColor(O3Theme.lightTextColorPicker, forState: UIControlState())
        checkboxPriority.secondaryTintColor = Theme.light.accentColor
        checkboxPriority.tintColor = Theme.light.accentColor
        checkboxPriority.checkmarkLineWidth = 2.0
        priorityCheckboxContainer.addSubview(checkboxPriority)
    }

    func setAssetRateInfo() {
        guard let neoIndex = saleInfo.acceptingAssets.index (where: {$0.asset.lowercased() == "neo" }),
            let gasIndex = saleInfo.acceptingAssets.index (where: {$0.asset.lowercased() == "gas" }) else {
                return
        }
        neoRateInfo = saleInfo.acceptingAssets[neoIndex]
        gasRateInfo = saleInfo.acceptingAssets[gasIndex]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        participateButton.isEnabled = false
        setThemedElements()
        logoImageView.kf.setImage(with: URL(string: saleInfo.imageURL))
        setAssetRateInfo()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == saleInfo.info.count {
            return 200
        }
        return 44
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saleInfo.info.count + 1
    }

    func amountStringToNumber(amountString: String) -> NSNumber? {
        let amountFormatter = NumberFormatter()
        amountFormatter.minimumFractionDigits = 0
        amountFormatter.maximumFractionDigits = self.selectedAsset!.decimal
        amountFormatter.numberStyle = .decimal
        return amountFormatter.number(from: amountString)

    }

    func validateAmount(amountString: String) -> Bool {
        let assetId: String! = self.selectedAsset!.assetID!
        let assetName: String! = self.selectedAsset?.name!
        var amount = amountStringToNumber(amountString: amountString)

        if amount == nil {
            OzoneAlert.alertDialog(message: "Invalid amount", dismissTitle: "OK") {}
            return false
        }

        //validate amount
        if amount!.decimalValue > self.selectedAsset!.balance! {
            let balanceDecimal = self.selectedAsset!.balance
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = self.selectedAsset!.decimal
            formatter.numberStyle = .decimal
            let balanceString = formatter.string(for: balanceDecimal)
            let message = String(format: "You don't have enough %@. Your balance is %@", assetName, balanceString!)
            OzoneAlert.alertDialog(message: message, dismissTitle: "OK") {}
            return false
        } else if selectedAsset?.name.lowercased() == "gas" && self.selectedAsset!.balance! - amount!.decimalValue <= 0.00000001 {
            OzoneAlert.alertDialog(message: "When sending all GAS, please subtract 0.00000001 from the total amount. This prevents rounding errors which can cause the transaction to not process", dismissTitle: "Ok") {}
            return false
        }
        return true
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == saleInfo.info.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "contributionTableViewCell") as? ContributionTableViewCell else {
                return UITableViewCell()
            }

            cell.delegate = self
            cell.neoRateInfo = neoRateInfo
            cell.gasRateInfo = gasRateInfo
            cell.tokenName = saleInfo.name
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tokenSaleInfoRowTableViewCell") as? TokenSaleInfoRowTableViewCell else {
            return UITableViewCell()
        }
        let infoRow = saleInfo.info[indexPath.row]
        let infoRowData = TokenSaleInfoRowTableViewCell.InfoData(title: infoRow.label, subtitle: infoRow.value)
        cell.infoData = infoRowData
        return cell
    }

    @IBAction func particpateTapped(_ sender: Any) {
        DispatchQueue.main.async {
            if self.validateAmount(amountString: self.amountString ?? "") {
                self.performSegue(withIdentifier: "showReviewTokenSale", sender: nil)
            }
        }
    }

    @IBAction func partcipateInfoTapped(_ sender: Any) {
        DispatchQueue.main.async {
            OzoneAlert.alertDialog(message: "Priority allows you to get on blocks first. In periods of high traffic increasing priority will improve your chances of getting on an ICO.", dismissTitle: "OK") {}
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // TODO: MAKE THESE THE PROPER VALUES FOR RECIEVING
        let tx = TokenSaleTransactionInfo (
            priorityIncluded: checkboxPriority.checkState == .checked,
            assetIDUsedToPurchase: selectedAsset?.assetID ?? "",
            assetNameUsedToPurchase: selectedAsset?.name ?? "",
            assetAmount: Double(truncating: amountStringToNumber(amountString: amountString!)!),
            tokenSaleContractHash: "INSERT TOKEN CONTRACT HASH HERE",
            tokensToRecieveAmount: 0.0,
            tokensToReceiveName: "TOKEN NAME"
        )
        guard let tokenSaleVC = segue.destination as? TokenSaleReviewTableViewController else {
            return
        }
        tokenSaleVC.logoURL = saleInfo.imageURL
        tokenSaleVC.transactionInfo = tx
    }

    func setContributionAmount(amountString: String) {
        self.amountString = amountString
        if amountString != "" {
            participateButton.isEnabled = true
        } else {
            participateButton.isEnabled = false
        }
    }

    func setContributionAsset(asset: TransferableAsset) {
        self.selectedAsset = asset
    }
}
