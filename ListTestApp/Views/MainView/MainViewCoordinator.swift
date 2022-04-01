//
//  MainViewCoordinator.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import UIKit

class MainViewCoordinator : BaseCoordinator {
    
    override func start() {
        let viewModel = MainViewModel(builder: .init(
            userDefalutManager: UserDefaultsManager.shared,
            coordinator: self
        ))
        let viewController = MainViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
 
}
