//
//  FavoriteViewCoordinator.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import Foundation

import UIKit

class FavoriteViewCoordinator: BaseCoordinator {
    
    
    
    override func start() {
        let viewModel = FavortieViewModel(builder: .init(
            userDefalutManager: UserDefaultsManager.shared,
            coordinator: self
        ))
        let viewController = FavoriteViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
        
    }
  
    
    
}
