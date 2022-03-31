import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: TabBarCoordinator { get set }
    
    func start()
    func didFinish(coordinator: Coordinator)
    func removeChildCoordinators()
}

class BaseCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var parentCoordinator: TabBarCoordinator
    
    init(navigationController: UINavigationController , parentCoordinator : TabBarCoordinator) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        fatalError("Start method should be implemented.")
    }
    
    func removeChildCoordinators() {
        childCoordinators.forEach { $0.removeChildCoordinators() }
        childCoordinators.removeAll()
    }
    
    func didFinish(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}

extension BaseCoordinator{
    
    func detailViewOpen(accomodation : Accommodation){
        let coordinator : DetailViewCoordinator = DetailViewCoordinator(
            builder : .init(navigationController: navigationController,
                  parentCoordinator: self,
                  item: accomodation)
        )
        
        coordinator.start()
    }

    func tabChange(flow: TabbarFlow){
        parentCoordinator.moveTo(flow: flow)
        
    }
    
    
}
