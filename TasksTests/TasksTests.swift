//
//  TasksTests.swift
//  TasksTests
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

@testable import Tasks
@testable import TasksSDK
import XCTest
import Combine

class RepositoryMock: TaskRepository {
    let queue = OperationQueue()
    
    func requestInterviewTasks(completion: ((Result<[InterviewTask], Error>) -> Void)?) -> Operation {
        let operation = BlockOperation {
            completion?(.success([]))
        }
        
        queue.addOperation(operation)
        return operation
    }
    
    func requestMastermindGameDetails(completion: ((Result<MastermindGameDetails, Error>) -> Void)?) -> Operation {
        let operation = BlockOperation {
            let details = MastermindGameDetails(characters: "ABCD", allowedCharacters: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
            
            completion?(.success(details))
        }
        
        queue.addOperation(operation)
        return operation
    }
    
    func requestTrafficLightDetails(completion: ((Result<TrafficLight, Error>) -> Void)?) -> Operation {
        let operation = BlockOperation {
            let details = TrafficLight(green: 5.0, orange: 5.0, red: 5.0)
            
            completion?(.success(details))
        }
        
        queue.addOperation(operation)
        return operation
    }
}

class TasksTests: XCTestCase {
    
    private let taskRepository = RepositoryMock()
    private var mastermindViewModel: MastermindGameViewModel?
    private var trafficLightViewModel: TrafficLightViewModel?
    
    private var scene: AnyCancellable?
    private var actionState: AnyCancellable?
    private var fieldsState: AnyCancellable?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        mastermindViewModel = MastermindGameViewModel(taskRepository: taskRepository, delegate: nil)
        bindMastermindGameViewData()
        mastermindViewModel?.load()
        
        trafficLightViewModel = TrafficLightViewModel(taskRepository: taskRepository, delegate: nil)
        bindTrafficLightViewData()
        trafficLightViewModel?.load()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssert(mastermindViewModel?.shouldUpdate(text: "1", at: 0) == false)
        XCTAssert(mastermindViewModel?.shouldUpdate(text: "A", at: 0) == true)
        XCTAssert(mastermindViewModel?.shouldUpdate(text: "ABC", at: 0) == false)
        
        mastermindViewModel?.validate()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

// MARK: - Mastermind

extension TasksTests {
    func bindMastermindGameViewData() {
        self.scene = mastermindViewModel?.scene.sink(
            receiveCompletion: { (completion) in
                
            },
            receiveValue: { (viewData) in
                guard let viewData = viewData as? MastermindGameViewData else { return }
                XCTAssert(viewData.actionButtonTitle == NSLocalizedString("Check", comment: ""))
            })
        
        self.actionState = mastermindViewModel?.actionStateObject.sink(
            receiveValue: { (viewData) in
                XCTAssert(viewData.active == false)
            })
        
        self.fieldsState = mastermindViewModel?.fieldsStateObject.sink(
            receiveValue: { (viewData) in
                XCTAssert(viewData.contains(.missing) == true)
                XCTAssert(viewData.contains(.match) == true)
                XCTAssert(viewData.contains(.closeMatch) == false)
            })
    }
}

// MARK: - Traffic light

extension TasksTests {
    func bindTrafficLightViewData() {
        self.scene = trafficLightViewModel?.scene.sink(
            receiveCompletion: { (completion) in
                
            },
            receiveValue: { [weak self] (viewData) in
                guard let self = self else { return }
                guard let viewData = viewData as? TrafficLightViewData else { return }
                
                XCTAssert(viewData.states.count == 3)
                XCTAssert(viewData.states == [true, false, false])
                self.tearDown()
            })
    }
}
