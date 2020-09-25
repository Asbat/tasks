//
//  Task.swift
//  TasksSDK
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit

public enum TaskType: Int, Codable {
    case mastermindGame
    case trafficLight
}

public protocol Task: Model {    
    var type: TaskType { get }
    var title: String { get }
    var description: String { get }
}
