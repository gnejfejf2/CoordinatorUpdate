//
//  FavoriteViewCoordinator.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import Foundation

import UIKit

class FavoriteViewCoordinator: BaseCoordinatorProtocol {
    
    var navigationController: UINavigationController
    var parentCoordinator: TabBarCoordinator
    
    init(navigationController: UINavigationController , parentCoordinator : TabBarCoordinator) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let viewModel = FavortieViewModel(builder: .init(
            userDefalutManager: UserDefaultsManager.shared,
            coordinator: self
        ))
        let viewController = FavoriteViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
        
    }
  
}
