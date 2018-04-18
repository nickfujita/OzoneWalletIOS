//
//  TokenSaleSubmitViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 4/17/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit
import NeoSwift
class TokenSaleSubmitViewController: UIViewController {

    var transactionInfo: TokenSaleTableViewController.TokenSaleTransactionInfo!
    
    func setThemedElements() {
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
    }
    
    func submitTransaction() {
        #if PRIVATENET
        UserDefaultsManager.seed = "http://localhost:30333"
        UserDefaultsManager.useDefaultSeed = false
        UserDefaultsManager.network = .privateNet
        Authenticated.account?.neoClient = NeoClient(network: .privateNet)
        #endif
    
        let fee = transactionInfo.priorityIncluded == true ? Float64(0.0011) : Float64(0)
        
        Authenticated.account?.participateTokenSales(scriptHash: transactionInfo.tokenSaleContractHash, assetID: transactionInfo.assetIDUsedToPurchase, amount: transactionInfo.assetAmount, remark: "O3X", networkFee: fee) { success, error in
            
            //make delay to 10 seconds in production
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                if success == true {
                    self.performSegue(withIdentifier: "success", sender: self.transactionInfo)
                    return
                }
                self.performSegue(withIdentifier: "error", sender: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true
        setThemedElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        submitTransaction()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "success" {
            guard let vc = segue.destination as? TokenSaleSuccessViewController else {
                return
            }
            vc.transactionInfo = sender as! TokenSaleTableViewController.TokenSaleTransactionInfo?
        }
    }
}
