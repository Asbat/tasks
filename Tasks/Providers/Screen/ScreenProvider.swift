//
//  ScreenProvider.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit

protocol ScreenProvider: Provider {
    var window: UIWindow { get }
    
    func setup(_ scene: UIWindowScene, launchOptions: UIScene.ConnectionOptions)
}
