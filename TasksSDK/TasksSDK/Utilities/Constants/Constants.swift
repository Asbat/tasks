//
//  Constants.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2019 Alexey Stoyanov. All rights reserved.
//

import UIKit

enum Constants {
    #if DEBUG
    static let server = "https://debug.infosys.com"
    #else
    static let server = "https://infosys.com"
    #endif
}
