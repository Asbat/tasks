//
//  ApplicationManager.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import TasksSDK

protocol ApplicationProvider: class {
    var screen: ScreenProvider { get }
}

class ApplicationManager: ApplicationProvider {
    
    // MARK: Properties
    
    private(set) var screen: ScreenProvider
    
    private var providers: [Provider]
    
    // MARK: Methods
    
    init() {
        screen = ScreenManager()
        
        providers = [
            screen
        ]
    }

    func reset() {
        for provider in providers {
            provider.reset()
        }
    }
}
