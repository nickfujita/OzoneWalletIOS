//
//  UnclaimedGASTableViewCell.swift
//  O3
//
//  Created by Apisit Toompakdee on 1/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit

protocol UnclaimGASDelegate {
    func claimButtonTapped()
}

class UnclaimedGASTableViewCell: UITableViewCell {

    var delegate: UnclaimGASDelegate?
    @IBOutlet weak var cardView: CardView!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var claimButton: ShadowedButton! {
        didSet {
            claimButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet var headerLabel: UILabel!
    override func awakeFromNib() {
        setLocalizedStrings()
        amountLabel.theme_textColor = O3Theme.titleColorPicker
        cardView.theme_backgroundColor = O3Theme.backgroundColorPicker
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        super.awakeFromNib()
    }

    @objc func buttonTapped(_ sender: Any) {
        if delegate != nil {
            delegate?.claimButtonTapped()
        }
    }

    override func layoutSubviews() {
        cardView.theme_backgroundColor = O3Theme.backgroundColorPicker
        super.layoutSubviews()
    }

    func setLocalizedStrings() {
        headerLabel.text = NSLocalizedString("WALLET_Unclaimed_Gas Title", comment: "A title for Unclaimed Gas in the wallet")
        claimButton.setTitle(NSLocalizedString("WALLET_Claim", comment: "A Title for the claim Action"), for: UIControlState())
    }
}
