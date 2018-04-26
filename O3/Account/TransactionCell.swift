//
//  transactionCell.swift
//  O3
//
//  Created by Andrei Terentiev on 9/13/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

protocol TransactionHistoryDelegate: class {
    func getWatchAddresses() -> [WatchAddress]
    func getContacts() -> [Contact]
}

class TransactionCell: UITableViewCell {
    weak var delegate: TransactionHistoryDelegate?

    enum TransactionType: String {
        case send = "Sent"
        case claim = "Claimed"
        case recieved = "Recieved"

    }
    struct TransactionData {
        var type: TransactionType
        var date: UInt64 // Use block number for now
        var asset: String
        var toAddress: String
        var fromAddress: String
        var amount: Double
        var precision: Int = 0
    }

    @IBOutlet weak var transactionTimeLabel: UILabel?
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    let fromPrefix = NSLocalizedString("WALLET_From_Prefix", comment: "Prefix used in the transaction history to indicate where the transaction came from")
    let toPrefix = NSLocalizedString("WALLET_To_Prefix", comment: "Prefix used in the transaction history to indicate where the transaction went to")
    let blockPrefix = NSLocalizedString("WALLET_Block_Prefix", comment: "Prefix used to indicate the block number in the transaction history")
    let claim = NSLocalizedString("WALLET_Claim", comment: "Indicated that the transation in history originated from claim")
    let o3Wallet = NSLocalizedString("WALLET_O3_Wallet", comment: "String in transaction history indicating O3 Wallet")

    override func awakeFromNib() {
        assetLabel.theme_textColor = O3Theme.titleColorPicker
        toAddressLabel.theme_textColor = O3Theme.primaryColorPicker
        fromAddressLabel.theme_textColor = O3Theme.accentColorPicker
        transactionTimeLabel?.theme_textColor = O3Theme.lightTextColorPicker
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        super.awakeFromNib()
    }

    func getAddressAlias(address: String) -> String {
        if address == Authenticated.account?.address ?? "" {
            return o3Wallet
        } else if let contactIndex = delegate?.getContacts().index(where: {$0.address == address}) {
            return delegate?.getContacts()[contactIndex].nickName ?? address
        } else if let watchAddressIndex = delegate?.getWatchAddresses().index(where: {$0.address == address}) {
            return delegate?.getWatchAddresses()[watchAddressIndex].nickName ?? address
        } else if address == "claim" {
            return claim
        }
        return address
    }

    var data: TransactionData? {
        didSet {
            if data?.toAddress ?? "" == Authenticated.account?.address ?? "" {
                amountLabel.theme_textColor = O3Theme.positiveGainColorPicker
                amountLabel.text = data?.amount.stringWithSign((data?.precision)!)
            } else {
                amountLabel.theme_textColor = O3Theme.negativeLossColorPicker
                amountLabel.text = data?.amount.stringWithSign((data?.precision)! * -1)
            }
            assetLabel.text = data?.asset.uppercased()
            transactionTimeLabel?.text = blockPrefix + String(data?.date ?? 0)
            toAddressLabel.text = toPrefix + getAddressAlias(address: data?.toAddress ?? "")
            fromAddressLabel.text = fromPrefix + getAddressAlias(address: data?.fromAddress ?? "")
        }
    }
}
