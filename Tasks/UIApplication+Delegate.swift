//
//  UIApplication+Delegate.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 25.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit

extension UIApplication {
    var app: ApplicationManager? {
        return (delegate as? AppDelegate)?.application
    }
}
