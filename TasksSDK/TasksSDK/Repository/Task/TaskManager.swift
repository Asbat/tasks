//
//  TaskManager.swift
//  TasksSDK
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit

public class TaskManager: Manager {
    
    private enum Constants {
        enum MastermindGame {
            static let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            static let letterCount = 4
        }
        
        enum TrafficLight {
            static let redDuration = 4.0
            static let orangeDuration = 1.0
            static let greenDuration = 4.0
        }
    }
    
    // MARK: Properties
    
    private let taskQueue = OperationQueue()
    
    // MARK: Methods
}

// MARK: - Private

private extension TaskManager {
    func tasks() -> [InterviewTask] {
        // Task1
        let task1 = InterviewTask(
            type: .mastermindGame,
            title: NSLocalizedString("Mastermind game", comment: ""),
            description: NSLocalizedString("Create a mastermind game!", comment: ""))
        
        // Task2
        let task2 = InterviewTask(
            type: .trafficLight,
            title: NSLocalizedString("Traffic light", comment: ""),
            description: NSLocalizedString("Create a traffic light!", comment: ""))
        
        return  [
            task1,
            task2
        ]
    }
    
    func mastermindGameDetails() -> MastermindGameDetails {
        let characters = String((0..<Constants.MastermindGame.letterCount).compactMap{ _ in Constants.MastermindGame.letters.randomElement() })
        
        return MastermindGameDetails(
            characters: characters,
            allowedCharacters: Constants.MastermindGame.letters)
    }
    
    func trafficLightDetails() -> TrafficLight {
        return TrafficLight(
            green: Constants.TrafficLight.greenDuration,
            orange: Constants.TrafficLight.orangeDuration,
            red: Constants.TrafficLight.redDuration)
    }
}

// MARK: - TaskRepository

extension TaskManager: TaskRepository {
    public func requestInterviewTasks(completion: ((Result<[InterviewTask], Error>) -> Void)?) -> Operation {
        let operation = BlockOperation(block: { [weak self] in
            guard let self = self else { return }
            
            // Do some hard work here.
            let tasks = self.tasks()
            
            DispatchQueue.main.async {
                completion?(.success(tasks))
            }
        })
        
        taskQueue.addOperation(operation)
        return operation
    }
    
    public func requestMastermindGameDetails(completion: ((Result<MastermindGameDetails, Error>) -> Void)?) -> Operation {
        let operation = BlockOperation(block: { [weak self] in
            guard let self = self else { return }
            
            // Do some hard work here.
            let details = self.mastermindGameDetails()
            
            DispatchQueue.main.async {
                completion?(.success(details))
            }
        })
        
        taskQueue.addOperation(operation)
        return operation
    }
    
    public func requestTrafficLightDetails(completion: ((Result<TrafficLight, Error>) -> Void)?) -> Operation {
        let operation = BlockOperation(block: { [weak self] in
            guard let self = self else { return }
            
            // Do some hard work here.
            let details = self.trafficLightDetails()
            
            DispatchQueue.main.async {
                completion?(.success(details))
            }
        })
        
        taskQueue.addOperation(operation)
        return operation
    }
}
