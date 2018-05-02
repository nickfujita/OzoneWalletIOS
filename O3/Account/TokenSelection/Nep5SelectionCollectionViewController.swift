//
//  Nep5SelectionCollectionViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 5/1/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

class Nep5SelectionCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    let numberOfTokensPerRow: CGFloat = 2
    let gridSpacing: CGFloat = 8
    var supportedTokens = [NEP5Token]()
    var filteredTokens = [NEP5Token]()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    func loadTokens() {
        O3Client().getTokens { result in
            switch result {
            case .failure:
                return
            case .success(let tokens):
                self.supportedTokens = tokens
                self.filteredTokens = self.supportedTokens
                DispatchQueue.main.async { self.collectionView?.reloadData() }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        self.hideKeyboardWhenTappedAround()
        searchBar.setBackgroundImage(UIImage(color: .white), for: .any, barMetrics: UIBarMetrics.default)
        loadTokens()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTokens.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tokenGridCell", for: indexPath) as? TokenGridCell else {
            fatalError("Undefined cell grid behavior")
        }

        cell.data = filteredTokens[indexPath.row]
        if (UserDefaultsManager.selectedNEP5Token![filteredTokens[indexPath.row].tokenHash]) != nil {
            cell.inWalletImageView.isHidden = false
        } else {
            cell.inWalletImageView.isHidden = true
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return gridSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = ((view.frame.width - 16 - (CGFloat(max(0, numberOfTokensPerRow - 1)) * gridSpacing)) / numberOfTokensPerRow)
        return CGSize(width: cellWidth, height: cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TokenGridCell,
            let token = cell.data else {
                fatalError("Undefined Collection view behavior")
        }
        DispatchQueue.main.async {
            if cell.inWalletImageView.isHidden {
                cell.inWalletImageView.isHidden = false
                UserDefaultsManager.selectedNEP5Token![token.tokenHash] = token
                NotificationCenter.default.post(name: Notification.Name("AddedNewToken"), object: nil)
                    Answers.logCustomEvent(withName: "Added New Token",
                                           customAttributes: ["Token Name": token.name,
                                                              "Num Tokens": UserDefaultsManager.selectedNEP5Token?.keys.count,
                                                              "Which Tokens": UserDefaultsManager.selectedNEP5Token?.description])
            } else {
                cell.inWalletImageView.isHidden = true
                UserDefaultsManager.selectedNEP5Token?.removeValue(forKey: token.tokenHash)
                NotificationCenter.default.post(name: Notification.Name("AddedNewToken"), object: nil)
                Answers.logCustomEvent(withName: "Removed Token",
                                       customAttributes: ["Token Name": token.name,
                                                          "Num Tokens": UserDefaultsManager.selectedNEP5Token?.keys.count,
                                                          "Which Tokens": UserDefaultsManager.selectedNEP5Token?.description])
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTokens = searchText.isEmpty ? supportedTokens : supportedTokens.filter { (item: NEP5Token) -> Bool in
            return item.name.lowercased().hasPrefix(searchText.lowercased()) ||
                item.symbol.lowercased().hasPrefix(searchText.lowercased())
        }
        collectionView.reloadData()
    }

    func setLocalizedStrings() {

    }
}
