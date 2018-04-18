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
import WebBrowser

class TokenSaleTableViewController: UITableViewController, ContributionCellDelegate {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var priorityCheckboxContainer: UIView!
    @IBOutlet weak var participateButton: ShadowedButton!
    @IBOutlet weak var priorityInfoButton: UIButton!
    @IBOutlet var priorityLabel: UILabel?
    
    var saleInfo: TokenSales.SaleInfo!
    var selectedAsset: TransferableAsset? = TransferableAsset.NEO()
    var neoRateInfo: TokenSales.SaleInfo.AcceptingAsset?
    var gasRateInfo: TokenSales.SaleInfo.AcceptingAsset?
    var amountString: String?
    var totalTokens: Double = 0.0
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
        self.title = saleInfo.name
        self.navigationItem.largeTitleDisplayMode = .never
        participateButton.isEnabled = false
        self.tableView.keyboardDismissMode = .onDrag
        setThemedElements()
        logoImageView.kf.setImage(with: URL(string: saleInfo.imageURL))
        setAssetRateInfo()
        let tap = UITapGestureRecognizer(target: self, action: #selector(priorityTapped(_:)))
        priorityLabel?.addGestureRecognizer(tap)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "external-link-alt"), style: .plain, target: self, action: #selector(externalLinkTapped(_:)))
    }
    
    @objc func externalLinkTapped(_ sender: Any) {
        let webBrowserViewController = WebBrowserViewController()
        webBrowserViewController.isToolbarHidden = false
        webBrowserViewController.title = saleInfo.name
        webBrowserViewController.isShowURLInNavigationBarWhenLoading = true
        webBrowserViewController.barTintColor = UserDefaultsManager.themeIndex == 0 ? Theme.light.backgroundColor: Theme.dark.backgroundColor
        webBrowserViewController.tintColor = Theme.light.primaryColor
        webBrowserViewController.isShowPageTitleInNavigationBar = true
        webBrowserViewController.loadURLString(saleInfo.webURL)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.pushViewController(webBrowserViewController, animated: true)
        }
    }
    
    @objc func priorityTapped(_ sender: Any) {
        if checkboxPriority.checkState == .checked {
            checkboxPriority.checkState = .unchecked
        } else {
            checkboxPriority.checkState = .checked
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 218.0
        }
        return 35
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //sales info section
        if section == 0 {
            return saleInfo.info.count
        }
        //contribution cell
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func amountStringToNumber(amountString: String) -> NSNumber? {
        let amountFormatter = NumberFormatter()
        amountFormatter.minimumFractionDigits = 0
        amountFormatter.numberStyle = .decimal
        amountFormatter.maximumFractionDigits = self.selectedAsset!.decimal
        amountFormatter.locale = Locale.current
        amountFormatter.usesGroupingSeparator = true
        return amountFormatter.number(from: amountString)
    }
    
    func validateAmount(amountString: String) -> Bool {
        let contributionIndexPath = IndexPath(row: 0, section: 1)
        guard let cell = tableView.cellForRow(at: contributionIndexPath) as? ContributionTableViewCell else {
            return false
        }
        //clear error message label
        cell.errorLabel.text = ""
    
        if amountString.count == 0 {
            return false
        }
        //never alert inside a validation method that return bool
        let assetId: String! = self.selectedAsset!.assetID!
        let assetName: String! = self.selectedAsset?.name!
        let amount = amountStringToNumber(amountString: amountString)
        
        if amount == nil {
            OzoneAlert.alertDialog(message: "Invalid amount", dismissTitle: "OK") {}
            return false
        }
       
        //validation
        //1. check balance first
        //2. check min/max contribution
        
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
        
        
        let filteredResults = saleInfo.acceptingAssets.filter { (asset) -> Bool in
            return asset.asset.lowercased() == self.selectedAsset?.name.lowercased()
        }
        
        //TODO make this validation better
        //showing a message instead of an alert
        if filteredResults.count == 1 {
            let contributingAsset = filteredResults.first!
            if amount!.doubleValue > contributingAsset.max {
                cell.errorLabel.shakeToShowError()
                let message = String(format: "Maximum contribution for %@ is %@",contributingAsset.asset.uppercased(), contributingAsset.max.string(0, removeTrailing: true))
                cell.errorLabel.text = message
                return false
            }
            
            if amount!.doubleValue < contributingAsset.min {
                cell.errorLabel.shakeToShowError()
                let message = String(format: "Minimum contribution for %@ is %@",contributingAsset.asset.uppercased(), contributingAsset.min.string(8, removeTrailing: true))
                cell.errorLabel.text = message
                return false
            }
        }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //contribution section
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "contributionTableViewCell") as? ContributionTableViewCell else {
                return UITableViewCell()
            }
            
            cell.delegate = self
            cell.neoRateInfo = neoRateInfo
            cell.gasRateInfo = gasRateInfo
            cell.tokenName = saleInfo.symbol
            //init with 0
            cell.tokenAmountLabel.text = String(format: "0 %@", saleInfo.symbol)
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
        let tx = TokenSaleTransactionInfo (
            priorityIncluded: checkboxPriority.checkState == .checked,
            assetIDUsedToPurchase: selectedAsset?.assetID ?? "",
            assetNameUsedToPurchase: selectedAsset?.name ?? "",
            assetAmount: Double(truncating: amountStringToNumber(amountString: amountString!)!),
            tokenSaleContractHash: saleInfo.scriptHash,
            tokensToRecieveAmount: totalTokens,
            tokensToReceiveName: saleInfo.symbol
        )
        guard let tokenSaleVC = segue.destination as? TokenSaleReviewTableViewController else {
            return
        }
        tokenSaleVC.logoURL = saleInfo.imageURL
        tokenSaleVC.transactionInfo = tx
    }
    
    func setContributionAmount(amountString: String) {
        self.amountString = amountString
        let valid = validateAmount(amountString: amountString)
        if amountString != "" && valid == true {
            participateButton.isEnabled = true
        } else {
            participateButton.isEnabled = false
        }
    }
    
    func setTokenAmount(totalTokens: Double) {
        self.totalTokens = totalTokens
    }
    
    func setContributionAsset(asset: TransferableAsset) {
        self.selectedAsset = asset
    }
}
