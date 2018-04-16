//
//  TokenSalesList.swift
//  O3
//
//  Created by Andrei Terentiev on 4/12/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit

class TokenSalesListTableViewController: UITableViewController {
    var tokenSales: TokenSales?
    var selectedSale: TokenSales.SaleInfo?
    func setupNavigationBar() {
        self.navigationController?.hideHairline()
        self.navigationItem.title = "Token Sales"
    }

    func setThemedElements() {
        tableView.theme_separatorColor = O3Theme.tableSeparatorColorPicker
        tableView.theme_backgroundColor = O3Theme.backgroundColorPicker
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setThemedElements()
        O3Client().getTokenSales { result in
            switch result {
            case .failure:
                return
            case .success(let tokenSales):
                self.tokenSales = tokenSales
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tokenSales?.live.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tokenSaleTableViewCell") as? TokenSaleTableViewCell,
            let sale = tokenSales?.live[indexPath.row] else {
                return UITableViewCell()
        }
        let data = TokenSaleTableViewCell.TokenSaleData(imageURL: sale.imageURL, name: sale.name, time: sale.endTime)
        cell.tokenSaleData = data
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedSale = tokenSales?.live[indexPath.row] else {
            return
        }
        self.selectedSale = selectedSale
        self.performSegue(withIdentifier: "segueToTokenSale", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? TokenSaleTableViewController else {
            return
        }
        dest.saleInfo = self.selectedSale
    }
}
