//
//  SendCompleteViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/20/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class SendCompleteViewController: UIViewController {
    @IBOutlet weak var completeImage: UIImageView!
    @IBOutlet weak var completeTitle: UILabel!
    @IBOutlet weak var completeSubtitle: UILabel!
    var transactionSucceeded: Bool!
    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.setTitle(NSLocalizedString("SEND_Close", comment: "Title for button to close send screen after transaction completed"), for: UIControlState())

        if transactionSucceeded {
            completeImage.image = #imageLiteral(resourceName: "checked")
            completeTitle.text = NSLocalizedString("SEND_Created_Transaction_Successfully_Title", comment: "Title to display when the transaction has successfuly been submitted to the NEO blockchain")
            completeSubtitle.text = NSLocalizedString("SEND_Created_Transaction_Successfully_Description", comment: "Description to display when the transaction has successfuly been submitted to the NEO blockchain")
        } else {
            completeImage.image = #imageLiteral(resourceName: "sad")
            completeTitle.text = NSLocalizedString("SEND_Created_Transaction_Failed_Title", comment: "Title to display when the transaction has failed to be submitted to the NEO blockchain")
            completeSubtitle.text = NSLocalizedString("SEND_Created_Transaction_Failed_Description", comment: "Description to display when the transaction has failed to be submitted to the NEO blockchain")
        }
    }
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
