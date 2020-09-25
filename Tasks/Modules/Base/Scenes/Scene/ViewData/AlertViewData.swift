//
//  AlertViewData.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit

struct AlertViewData: ViewData {
    let title: String
    let description: String
    
    // Pretend there is an action items property here.
}

extension AlertViewData {
    static func alert(from error: Error) -> AlertViewData {
        return AlertViewData(title: NSLocalizedString("Opps!", comment: ""), description: error.localizedDescription)
    }
}
