import UIKit

enum TabbarFlow {
    case Main
    case Favorite
   
}

protocol TabBarCoordinatorProtocol {
    var navigationController : UINavigationController { get }
    
    var mainViewCoordinator :  MainViewCoordinator! { get set }
    var favoriteViewCoordinator :  FavoriteViewCoordinator! { get set }
    
    
    init(navigationController : UINavigationController)
    
    func start()
    func moveTo(flow: TabbarFlow)
}


class TabBarCoordinator : TabBarCoordinatorProtocol {
    let navigationController : UINavigationController
    var mainViewCoordinator : MainViewCoordinator!
  
    var favoriteViewCoordinator : FavoriteViewCoordinator!
    
    private let tabbarController = UITabBarController()
    
    required init(navigationController : UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        self.mainViewCoordinator = MainViewCoordinator(navigationController: UINavigationController(), parentCoordinator: self)
        self.favoriteViewCoordinator = FavoriteViewCoordinator(navigationController: UINavigationController(), parentCoordinator: self)
        mainViewCoordinator.start()
        favoriteViewCoordinator.start()

        
        mainViewCoordinator.navigationController.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        favoriteViewCoordinator.navigationController.tabBarItem = UITabBarItem(title: "즐겨찾기", image: UIImage(systemName: "star.fill"), tag: 1)
        
        tabbarController.viewControllers = [
            mainViewCoordinator.navigationController,
            favoriteViewCoordinator.navigationController
        ]
        
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(tabbarController, animated: false)
    }
    
    func moveTo(flow: TabbarFlow)  {
        switch flow {
        case .Main:
            tabbarController.selectedIndex = 0
        case .Favorite:
            tabbarController.selectedIndex = 1
        }
    }
}

