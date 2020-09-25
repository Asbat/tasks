//
//  TasksViewModel.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit
import TasksSDK

protocol TasksViewModelDelegate: ViewModelDelegate {
    func tasksViewModelDidRequestMastermindGame(_ vm: TasksViewModel)
    func tasksViewModelDidRequestTrafficLight(_ vm: TasksViewModel)
}

protocol TasksViewModelProtocol: ViewModel {
    func didRequestTask(at index: Int)
}

class TasksViewModel: ViewModel {
    
    // MARK: Properties
    
    weak var tasksDelegate: TasksViewModelDelegate? {
        get {
            return delegate as? TasksViewModelDelegate
        }
        
        set {
            delegate = newValue
        }
    }
    
    let taskRepository: TaskRepository
    
    private var tasks = [InterviewTask]()
    private let disposeBag = DisposeBag()
    
    // MARK: Methods
    
    init(taskRepository: TaskRepository,
         delegate: TasksViewModelDelegate?) {
        self.taskRepository = taskRepository
        super.init()
        
        self.tasksDelegate = delegate
    }
    
    override func load() {
        // Pretend we show loading
        taskRepository.requestInterviewTasks(
            completion: { [weak self] (result) in
                guard let self = self else { return }
                
                // Pretend we stop loading
                
                switch result {
                case .success(let tasks):
                    self.tasks = tasks
                    self.scene.send(self.tasksViewData(from: tasks))
                    
                case .failure(let error):
                    self.tasks.removeAll()
                    self.alert.send(AlertViewData.alert(from: error))
                }
            }).disposed(by: disposeBag)
    }
}

// MARK: - Private

private extension TasksViewModel {
    func tasksViewData(from tasks: [InterviewTask]) -> TasksViewData {
        return TasksViewData(tasks: tasks.map({ TasksViewData.Task(title: $0.title, description: $0.description) }))
    }
}

// MARK: - TasksViewModelProtocol

extension TasksViewModel: TasksViewModelProtocol {
    func didRequestTask(at index: Int) {
        guard let type = TaskType(rawValue: index) else { return }
        
        switch type {
        case .mastermindGame:
            tasksDelegate?.tasksViewModelDidRequestMastermindGame(self)
            
        case .trafficLight:
            tasksDelegate?.tasksViewModelDidRequestTrafficLight(self)
        }
    }
}
