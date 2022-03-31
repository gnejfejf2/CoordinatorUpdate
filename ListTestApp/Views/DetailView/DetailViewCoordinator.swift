//
//  DetailViewCoordinator.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import Foundation

class DetailViewCoordinator : ChildBaseCoordinator {
    
    
    
    override func start() {
        let viewModel = DetailViewModel(builder: .init(
            coordinator: self
        ))
        let viewController = DetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
        
    }
  
    
    
}
