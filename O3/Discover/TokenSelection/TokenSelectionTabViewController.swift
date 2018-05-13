//
//  TokenSelectionViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 5/1/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import Tabman
import Pageboy
import SwiftTheme

class TokenSelectionTabViewController: TabmanViewController, PageboyViewControllerDataSource {
    var viewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let nep5TokensViewController = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(withIdentifier: "nep5SelectionCollectionViewController")
        let newsFeedViewController = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(withIdentifier: "NewsFeedViewController")
        self.viewControllers.append(newsFeedViewController)
        self.viewControllers.append(nep5TokensViewController)
        self.dataSource = self
        applyNavBarTheme()
        setTabmanAppearance()
        setLocalizedStrings()

    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    // MARK: Theming and Localizations
    func setTabmanAppearance() {
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            appearance.state.selectedColor = UserDefaultsManager.theme.primaryColor
            appearance.state.color = UserDefaultsManager.theme.lightTextColor
            appearance.text.font = O3Theme.topTabbarItemFont
            appearance.layout.edgeInset = 16
            appearance.style.background = .solid(color: UserDefaultsManager.theme.backgroundColor)
        })
        self.bar.location = .top
        self.bar.style = .buttonBar
    }

    @objc func tappedClose(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "tokenSelectorDismissed"), object: nil)
        DispatchQueue.main.async { self.dismiss(animated: true) }
    }

    func setLocalizedStrings() {
        bar.items = [Item(title: DiscoverStrings.newsTitle),
                     Item(title: DiscoverStrings.NEP5)]
    }
}
