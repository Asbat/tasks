//
//  ScreenManager.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit
import TasksSDK

class ScreenManager {

    // MARK: Properties

    var window = UIWindow(frame: UIScreen.main.bounds)

    /// Root
    weak var root: UINavigationController?

    private var coordinators = [Coordinator]()

    // MARK: Methods

}

// MARK: - Private

private extension ScreenManager {

}

// MARK: - ScreenProvider

extension ScreenManager: ScreenProvider {
    func reset() {
        
    }
}

// MARK: - Public

extension ScreenManager {
    func setup(_ scene: UIWindowScene, launchOptions: UIScene.ConnectionOptions) {
        window.windowScene = scene
        window.backgroundColor = .white
        
        let factory = CoordinatorFactory()
        let coordinator = factory.tasks(container: nil, delegate: self)
        coordinators.append(coordinator)
        
        if let viewController = coordinator.start() {
            let root = UINavigationController(rootViewController: viewController)
            self.root = root
        }
        
        window.rootViewController = root
        window.makeKeyAndVisible()
    }
}

// MARK: - TasksCoordinatorDelegate

extension ScreenManager: TasksCoordinatorDelegate {
    func coordinatorDidRequestDismiss(coordinator: Coordinator) {
        // TODO: remove coordinator
//        coordinators.remove
    }
}
