//
//  TokenSaleSubmitViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 4/17/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit
class TokenSaleSubmitViewController: UIViewController {

    var transactionInfo: TokenSaleTableViewController.TokenSaleTransactionInfo!
    @IBOutlet weak var sendingProgressLabel: UILabel!

    func setThemedElements() {
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
    }

    func submitTransaction() {
        let fee = transactionInfo.priorityIncluded == true ? Float64(0.0011) : Float64(0)
        let remark = String(format: "O3X%@", transactionInfo.saleInfo.name)
        Authenticated.account?.participateTokenSales(network: AppState.network, seedURL: AppState.bestSeedNodeURL, scriptHash: transactionInfo.tokenSaleContractHash, assetID: transactionInfo.assetIDUsedToPurchase, amount: transactionInfo.assetAmount, remark: remark, networkFee: fee) { success, txID, _ in

            //make delay to 5 seconds in production
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if success == true {
                    self.transactionInfo.txID = txID
                    self.performSegue(withIdentifier: "success", sender: self.transactionInfo)
                    return
                }
                self.performSegue(withIdentifier: "error", sender: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true
        setThemedElements()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let bestNode = NEONetworkMonitor.autoSelectBestNode(network: AppState.network) {
            AppState.bestSeedNodeURL = bestNode
        }
        submitTransaction()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "success" {
            guard let vc = segue.destination as? TokenSaleSuccessViewController,
                let info = sender as? TokenSaleTableViewController.TokenSaleTransactionInfo? else {
                return
            }

            vc.transactionInfo = info
        }
    }

    func setLocalizedStrings() {
        sendingProgressLabel.text = TokenSaleStrings.sendingInProgress
    }
}
