//
//  Nep5SearchHeader.swift
//  O3
//
//  Created by Andrei Terentiev on 5/1/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit

class NEP5SearchHeader: UICollectionReusableView {
    @IBOutlet weak var searchBar: UISearchBar!

    override func awakeFromNib() {
        searchBar.setBackgroundImage(UIImage(color: .white), for: .any, barMetrics: UIBarMetrics.default)
        super.awakeFromNib()
    }
}
