//
//  AssetInputToolbar.swift
//  O3
//
//  Created by Apisit Toompakdee on 4/17/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit

protocol AssetInputToolbarDelegate {

}

class AssetInputToolbar: UIView {
    var view: UIView!

    @IBOutlet var assetLabel: UILabel?
    @IBOutlet var assetBalance: UILabel?
    @IBOutlet var messageLabel: UILabel?
    
    var asset: TransferableAsset? {
        didSet{
            if asset == nil {
                return
            }
            assetLabel?.text = String(format:"%@ BALANCE", asset!.symbol)
            assetBalance?.text = asset!.formattedBalanceString
        }
    }
    
    var delegate: AssetInputToolbarDelegate?
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup() {
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
}

private extension AssetInputToolbar {
    
    func xibSetup() {
        backgroundColor = UIColor.clear
        view = loadNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Adding custom subview on top of our view
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
    }
}

extension UIView {
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
