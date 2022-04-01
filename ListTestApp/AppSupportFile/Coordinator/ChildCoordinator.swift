//
//  ChildCoordinator.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/31.
//

import UIKit
//빌더에 navigationController , parentCoordinator 전달해서 넣어주지만
//다시 내부값으로 가져가는 이유는 햇갈리지 않기위해 사용
protocol ChildCoordinator : AnyObject {
    associatedtype Builder
    var builder : Builder { get }
    
    var navigationController: UINavigationController { get set }
    var parentCoordinator: BaseCoordinatorProtocol { get set }
    
    func start()
}
