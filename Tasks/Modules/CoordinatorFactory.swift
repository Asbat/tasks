//
//  CoordinatorFactory.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit
import TasksSDK

class CoordinatorFactory {
    func tasks(container: UIViewController?, delegate: TasksCoordinatorDelegate?) -> TasksCoordinator {
        let tasksApi = TasksApi()
        return TasksCoordinator(container: container, taskRepository: tasksApi.task(), delegate: delegate)
    }
}
