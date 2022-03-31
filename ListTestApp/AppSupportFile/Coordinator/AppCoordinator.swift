import UIKit



class AppCoordinator {
    private let window : UIWindow
    
    let navigationController : UINavigationController = UINavigationController()


    init(window : UIWindow){
        self.window = window
    }
    
    func start() {
        window.makeKeyAndVisible()
        tabBar()
    }
    
    private func tabBar() {
        
        
        let coordinator = TabBarCoordinator(navigationController: navigationController)
        coordinator.start()
        window.rootViewController = coordinator.navigationController
    }
    
}
