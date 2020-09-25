//
//  TasksCoordinator.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit
import TasksSDK

protocol TasksCoordinatorDelegate: CoordinatorDelegate {
    
}

class TasksCoordinator: Coordinator {
    
    // MARK: Properties
    
    weak var tasksDelegate: TasksCoordinatorDelegate? {
        get {
            return delegate as? TasksCoordinatorDelegate
        }
        
        set {
            delegate = newValue
        }
    }
    
    let taskRepository: TaskRepository
    
    // MARK: Init methods
    
    init(container: UIViewController?,
         taskRepository: TaskRepository,
         delegate: TasksCoordinatorDelegate?) {
        self.taskRepository = taskRepository
        
        super.init(container: container)
        
        self.tasksDelegate = delegate
    }
    
    // MARK: Override methods
    
    override func start() -> UIViewController? {
        let viewController = TasksSceneFactory().makeTasksScene(taskRepository: taskRepository, delegate: self)
        self.initialViewController = viewController
        
        if let container = container as? UINavigationController {
            container.pushViewController(viewController, animated: true)
        }
        
        return viewController
    }
}

// MARK: - TasksViewModelDelegate

extension TasksCoordinator: TasksViewModelDelegate {
    func tasksViewModelDidRequestMastermindGame(_ vm: TasksViewModel) {
        let viewController = TasksSceneFactory().makeMastermindGameScene(taskRepository: taskRepository, delegate: self)

        
        initialViewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tasksViewModelDidRequestTrafficLight(_ vm: TasksViewModel) {
        let viewController = TasksSceneFactory().makeTrafficLightScene(taskRepository: taskRepository, delegate: self)

        
        initialViewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - MastermindGameViewModelDelegate

extension TasksCoordinator: MastermindGameViewModelDelegate {
    
}

// MARK: - TrafficLightViewModelDelegate

extension TasksCoordinator: TrafficLightViewModelDelegate {
    
}
