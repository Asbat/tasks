//
//  TasksSceneFactory.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit
import TasksSDK

class TasksSceneFactory: SceneFactory {
    func makeTasksScene(taskRepository: TaskRepository, delegate: TasksViewModelDelegate?) -> TasksViewController {
        let viewModel = TasksViewModel(taskRepository: taskRepository, delegate: delegate)
        return TasksViewController(viewModel: viewModel)
    }
    
    func makeMastermindGameScene(taskRepository: TaskRepository, delegate: MastermindGameViewModelDelegate?) -> MastermindGameViewController {
        let viewModel = MastermindGameViewModel(taskRepository: taskRepository, delegate: delegate)
        return MastermindGameViewController(viewModel: viewModel)
    }
    
    func makeTrafficLightScene(taskRepository: TaskRepository, delegate: TrafficLightViewModelDelegate?) -> TrafficLightViewController {
        let viewModel = TrafficLightViewModel(taskRepository: taskRepository, delegate: delegate)
        return TrafficLightViewController(viewModel: viewModel)
    }
}
