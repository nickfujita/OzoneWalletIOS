//
//  TokenSaleTableViewCell.swift
//  O3
//
//  Created by Andrei Terentiev on 4/12/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class TokenSaleTableViewCell: UITableViewCell {
    @IBOutlet weak var tokenSaleImageView: UIImageView!
    @IBOutlet weak var tokenSaleNameLabel: UILabel!
    @IBOutlet weak var tokenSaleTimeLabel: UILabel!
    override func awakeFromNib() {
        tokenSaleNameLabel.theme_textColor = O3Theme.titleColorPicker
        tokenSaleTimeLabel.theme_textColor = O3Theme.lightTextColorPicker
        contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        theme_backgroundColor = O3Theme.backgroundColorPicker
        super.awakeFromNib()
    }

    struct TokenSaleData {
        var imageURL: String
        var name: String
        var time: Int
    }
    var tokenSaleData: TokenSaleData? {
        didSet {
            tokenSaleImageView.kf.setImage(with: URL(string: tokenSaleData?.imageURL ?? ""))
            tokenSaleNameLabel.text = tokenSaleData?.name ?? ""
            tokenSaleTimeLabel.text = tokenSaleData?.time.description
        }
    }
}
