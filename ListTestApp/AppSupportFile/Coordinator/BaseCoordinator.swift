import UIKit

protocol BaseCoordinatorProtocol : AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: TabBarCoordinator { get set }
    
    func start()
    
    
    func detailViewOpen(accomodation : Accommodation)
    func tabChange(flow: TabbarFlow)
}

class BaseCoordinator: BaseCoordinatorProtocol  {
    var navigationController: UINavigationController
    var parentCoordinator: TabBarCoordinator
    
    init(navigationController: UINavigationController , parentCoordinator : TabBarCoordinator) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        fatalError("Start method should be implemented.")
    }
    
    
}


protocol BaseCoordinatorViewChangeProtocl {
    func detailViewOpen(accomodation : Accommodation)
    func tabChange(flow: TabbarFlow)
}

extension BaseCoordinatorProtocol{
    
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
