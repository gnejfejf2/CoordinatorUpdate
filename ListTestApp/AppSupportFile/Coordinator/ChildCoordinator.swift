//
//  ChildCoordinator.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/31.
//

import UIKit
protocol ChildCoordinator : AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: BaseCoordinator { get set }
    
    func start()
}

class ChildBaseCoordinator: ChildCoordinator {
    var navigationController: UINavigationController
    var parentCoordinator: BaseCoordinator

    init(navigationController: UINavigationController , parentCoordinator : BaseCoordinator) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }

    func start() {
    
    }
}
