//
//  SettingsCoordinator.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-09.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame

protocol SettingsNavigator: AnyObject {
    func toSettings()
    func toChooseWallet()
}

final class SettingsCoordinator: AnyCoordinator {

    private weak var navigationController: UINavigationController?

    private weak var navigation: AppNavigation?
    private let wallet: Observable<Wallet>

    init(navigationController: UINavigationController?, navigation: AppNavigation, wallet: Observable<Wallet>) {
        self.navigationController = navigationController
        self.navigation = navigation
        self.wallet = wallet
    }
}

// MARK: - Navigator
extension SettingsCoordinator: SettingsNavigator {

    func toChooseWallet() {
        Unsafe︕！Cache.deleteWallet()
        navigation?.toChooseWallet()
    }

    func start() {
        toSettings()
    }

    func toSettings() {
        navigationController?.pushViewController(
            Settings(
                viewModel: SettingsViewModel(navigation: self, wallet: wallet, service: AppDelegate.zilliqaSerivce.rx)
            ),
            animated: true
        )
    }
}
