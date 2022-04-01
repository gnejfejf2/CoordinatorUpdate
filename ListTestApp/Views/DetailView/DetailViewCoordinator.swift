//
//  DetailViewCoordinator.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import UIKit

class DetailViewCoordinator : ChildCoordinator {
    struct Builder {
        let navigationController : UINavigationController
        let parentCoordinator : BaseCoordinatorProtocol
        let item : Accommodation
    }
    
    
    var builder: Builder
    var navigationController: UINavigationController
    var parentCoordinator: BaseCoordinatorProtocol

    init(builder : Builder) {
        self.builder = builder
        self.navigationController = builder.navigationController
        self.parentCoordinator = builder.parentCoordinator
    }

   
    func start() {
        let viewModel = DetailViewModel(builder: .init(
            accommodation: builder.item,
            userDefalutManager: UserDefaultsManager.shared ,
            coordinator: self
        ))
        let viewController = DetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
        
    }
  
    
    
}
