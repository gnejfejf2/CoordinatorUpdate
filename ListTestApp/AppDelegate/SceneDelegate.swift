//
//  SceneDelegate.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appMainCoordinator : AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        appMainCoordinator = AppCoordinator(window: self.window!)
        appMainCoordinator?.start()
    }


}

