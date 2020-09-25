//
//  TasksApi.swift
//  TasksSDK
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import Foundation

public class TasksApi: Manager {
    
    // MARK: Properties
    
    // MARK: Methods
    
    public init() {
        
    }
}

// MARK: - Builder

extension TasksApi {
    public func task() -> TaskRepository {
        return TaskManager() // Provide some initial private data if needed.
    }
}
