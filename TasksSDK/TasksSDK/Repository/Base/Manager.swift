//
//  Manager.swift
//  TasksSDK
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit

public protocol Manager: class {
    func cacheData()
    func clearCache()
}

public extension Manager {
    func cacheData() {
        
    }
    
    func clearCache() {
        
    }
}
