//
//  TasksViewData.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit

struct TasksViewData: ViewData {
    struct Task: ViewData {
        let title: String
        let description: String
    }
    
    let tasks: [Task]
}
