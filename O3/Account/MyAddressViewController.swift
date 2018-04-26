//
//  MyAddressViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 9/30/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit

class MyAddressViewController: UIViewController {

    @IBOutlet var qrImageView: UIImageView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var qrCodeContainerView: UIView!
    @IBOutlet weak var addressInfoLabel: UILabel!

    let saveQRActionString = NSLocalizedString("WALLET_Save_Qr_Action", comment: "An Action Title for saving your QR code")
    let copyAddressActionString = NSLocalizedString("WALLET_Copy_Address", comment: "An action title for copying our address")
    let shareActionString = NSLocalizedString("WALLET_Share", comment: "An action title for sharing O3")
    let savedTitle = NSLocalizedString("WALLET_Saved_Title", comment: "A title to display when you've successfully saved your wallet address qr code")
    let savedMessage = NSLocalizedString("WALLET_Saved_Description", comment: "A description to give more information about saving the address")

    func configureView() {
        applyNavBarTheme()
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
        addressLabel.text = Authenticated.account?.address
        qrImageView.image = UIImage.init(qrData: (Authenticated.account?.address)!, width: qrImageView.bounds.size.width, height: qrImageView.bounds.size.height)
    }

    func saveQRCodeImage() {
        let qrWithBranding = UIImage.imageWithView(view: self.qrCodeContainerView)
        UIImageWriteToSavedPhotosAlbum(qrWithBranding, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    func share() {
        let shareURL = URL(string: "https://o3.network/")
        let qrWithBranding = UIImage.imageWithView(view: self.qrCodeContainerView)
        let activityViewController = UIActivityViewController(activityItems: [shareURL, qrWithBranding], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        self.present(activityViewController, animated: true, completion: nil)
    }

    @IBAction func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveQR = UIAlertAction(title: saveQRActionString, style: .default) { _ in
            self.saveQRCodeImage()
        }
        alert.addAction(saveQR)
        let copyAddress = UIAlertAction(title: copyAddressActionString, style: .default) { _ in
            UIPasteboard.general.string = Authenticated.account?.address
            //maybe need some Toast style to notify that it's copied
        }
        alert.addAction(copyAddress)
        let share = UIAlertAction(title: shareActionString, style: .default) { _ in
            self.share()
        }
        alert.addAction(share)

        let cancel = UIAlertAction(title: OzoneAlert.cancelNegativeConfirmString, style: .cancel) { _ in

        }
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = addressLabel
        present(alert, animated: true, completion: nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: OzoneAlert.errorTitle, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: OzoneAlert.okPositiveConfirmString, style: .default))
            present(alert, animated: true)
        } else {
            //change it to Toast style.
            let alert = UIAlertController(title: savedTitle, message: savedMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: OzoneAlert.okPositiveConfirmString, style: .default))
            present(alert, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        configureView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
        self.view.addGestureRecognizer(tap)
    }

    @IBAction func tappedLeftBarButtonItem(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    func setLocalizedStrings() {
        addressInfoLabel.text = NSLocalizedString("WALLET_My_Address_Explanation", comment: "Informative text explaining you can store neo, gas, and nep-5 tokens using this address")
        self.title = NSLocalizedString("WALLET_My_Address_Title", comment: "Title of the My Address Page")
    }

}
