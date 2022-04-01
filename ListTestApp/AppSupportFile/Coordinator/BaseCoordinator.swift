import UIKit

protocol BaseCoordinatorProtocol : AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: TabBarCoordinator { get set }
    
    func start()
    
    
    func detailViewOpen(accomodation : Accommodation)
    func tabChange(flow: TabbarFlow)
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
