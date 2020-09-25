//
//  RepeatingTimer.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import Foundation

enum State {
    case suspended
    case resumed
}

class RepeatingTimer {
    
    // MARK: Properties
    
    let timeInterval: TimeInterval
    var counter: Int = 0
    var eventHandler: ((_ repeatingTimer: RepeatingTimer) -> Void)?

    /// Private
    private var timer: DispatchSourceTimer?
    private(set) var state: State = .suspended

    // MARK: Methods
    
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }

    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed

        timer = createTimer(timeInterval: timeInterval)
        timer?.resume()
    }

    func suspend() {
        if state == .suspended {
            return
        }

        counter = 0
        state = .suspended
        timer?.cancel()
        timer = nil
    }
}

// MARK: - Private

private extension RepeatingTimer {
    func createTimer(timeInterval: TimeInterval) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now(), repeating: timeInterval)
        timer.setEventHandler(handler: { [weak self] in
            guard let self = self else { return }

            self.eventHandler?(self)
            self.counter = self.counter + 1
        })
        return timer
    }
}
