//
//  TaskRepository.swift
//  TasksSDK
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit

public protocol TaskRepository: Repository {
    func requestInterviewTasks(completion: ((Result<[InterviewTask], Error>) -> Void)?) -> Operation
    func requestMastermindGameDetails(completion: ((Result<MastermindGameDetails, Error>) -> Void)?) -> Operation
    func requestTrafficLightDetails(completion: ((Result<TrafficLight, Error>) -> Void)?) -> Operation
}
