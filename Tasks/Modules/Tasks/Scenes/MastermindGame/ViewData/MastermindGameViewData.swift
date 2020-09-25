//
//  MastermindGameViewData.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit

struct MastermindGameViewData: ViewData {
    enum FieldState {
        case match
        case closeMatch
        case missing
    }
    
    struct ActionState {
        let active: Bool
    }
    
    let actionButtonTitle: String?
}
