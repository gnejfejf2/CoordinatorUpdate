//
//  MockBaseProtocol.swift
//  ListTestAppTests
//
//  Created by 강지윤 on 2022/04/01.
//

import UIKit

@testable import ListTestApp


class MockBaseCoordinator : BaseCoordinatorProtocol{
    var navigationController: UINavigationController
    var parentCoordinator: TabBarCoordinator
    
    var detailViewOpen : Bool = false
    var tap : TabbarFlow = .Favorite
    
    init(navigationController: UINavigationController = UINavigationController() , parentCoordinator : TabBarCoordinator = TabBarCoordinator(navigationController: UINavigationController())) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        fatalError("Start method should be implemented.")
    }
    
    func detailViewOpen(accomodation: Accommodation) {
        
        detailViewOpen = true
    }
    func tabChange(flow: TabbarFlow) {
        tap = flow
    }
    
}
