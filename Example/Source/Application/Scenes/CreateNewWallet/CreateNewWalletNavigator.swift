//
//  CreateNewWalletNavigator.swift
//  ZilliqaSDKiOSExample
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

public protocol CreateNewWalletNavigator {
    func toOpenWallet()
}

public final class DefaultCreateNewWalletNavigator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - CreateNewWalletNavigator
extension DefaultCreateNewWalletNavigator: CreateNewWalletNavigator {}
public extension DefaultCreateNewWalletNavigator {
    func toOpenWallet() {
        navigationController.dismiss(animated: true)
    }
}
