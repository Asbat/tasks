//
//  TrafficLightViewModel.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 25.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import Foundation
import Combine
import TasksSDK

protocol TrafficLightViewModelDelegate: ViewModelDelegate {
    
}

protocol TrafficLightViewModelProtocol: ViewModel {
}

class TrafficLightViewModel: ViewModel {
    
    // MARK: Properties
    
    weak var trafficLightDelegate: TrafficLightViewModelDelegate? {
        get {
            return delegate as? TrafficLightViewModelDelegate
        }
        
        set {
            delegate = newValue
        }
    }
    
    let taskRepository: TaskRepository
    
    /// Private
    private var details: TrafficLight?
    private var timer: RepeatingTimer?
     
    private let disposeBag = DisposeBag()
    
    // MARK: Methods
    
    init(taskRepository: TaskRepository,
         delegate: TrafficLightViewModelDelegate?) {
        self.taskRepository = taskRepository
        super.init()
        
        self.trafficLightDelegate = delegate
    }
    
    override func load() {
        // Pretend we show loading
        taskRepository.requestTrafficLightDetails(
            completion: { [weak self] (result) in
                guard let self = self else { return }
                
                // Pretend we stop loading
                
                switch result {
                case .success(let details):
                    self.details = details
                    self.setupTrafficLightTimeout()
                    
                case .failure(let error):
                    self.details = nil
                    self.alert.send(AlertViewData.alert(from: error))
                }
            }).disposed(by: disposeBag)
    }
}

// MARK: - Private

private extension TrafficLightViewModel {
    func setupTrafficLightTimeout() {
        guard let details = details else { return }
        
        scene.send(TrafficLightViewData(states: [true, false, false]))
        
        let now = DispatchTime.now()
        let downloadGroup = DispatchGroup()
        
        downloadGroup.enter()
        DispatchQueue.global().asyncAfter(
            deadline: now + details.green,
            execute: { [weak self] in
                DispatchQueue.main.async {
                    self?.scene.send(TrafficLightViewData(states: [false, true, false]))
                }
                
                downloadGroup.leave()
            })
        
        downloadGroup.enter()
        DispatchQueue.global().asyncAfter(
            deadline: now + details.green + details.orange,
            execute: { [weak self] in
                DispatchQueue.main.async {
                    self?.scene.send(TrafficLightViewData(states: [false, false, true]))
                }
                
                downloadGroup.leave()
            })
        
        downloadGroup.enter()
        DispatchQueue.global().asyncAfter(
            deadline: now + details.green + details.orange + details.red,
            execute: {
                downloadGroup.leave()
            })

        downloadGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.setupTrafficLightTimeout()
        }
    }
}

// MARK: - TrafficLightViewModelProtocol

extension TrafficLightViewModel: TrafficLightViewModelProtocol {
    
}
