//
//  MastermindGameViewModel.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit
import Combine
import TasksSDK

protocol MastermindGameViewModelDelegate: ViewModelDelegate {
    
}

protocol MastermindGameViewModelProtocol: ViewModel {
    var actionStateObject: PassthroughSubject<MastermindGameViewData.ActionState, Never> { get }
    var fieldsStateObject: PassthroughSubject<[MastermindGameViewData.FieldState], Never> { get }
    
    func shouldUpdate(text: String, at index: Int) -> Bool
    func validate()
}

class MastermindGameViewModel: ViewModel {
    
    // MARK: Properties
    
    weak var mastermindGameDelegate: MastermindGameViewModelDelegate? {
        get {
            return delegate as? MastermindGameViewModelDelegate
        }
        
        set {
            delegate = newValue
        }
    }
    
    let taskRepository: TaskRepository
    let actionStateObject = PassthroughSubject<MastermindGameViewData.ActionState, Never>()
    let fieldsStateObject = PassthroughSubject<[MastermindGameViewData.FieldState], Never>()
    
    /// Private
    private var details: MastermindGameDetails?
    private var currentInput = [String]()
    
    private let disposeBag = DisposeBag()
    
    // MARK: Methods
    
    init(taskRepository: TaskRepository,
         delegate: MastermindGameViewModelDelegate?) {
        self.taskRepository = taskRepository
        super.init()
        
        self.mastermindGameDelegate = delegate
    }
    
    override func load() {
        // Pretend we show loading
        taskRepository.requestMastermindGameDetails(
            completion: { [weak self] (result) in
                guard let self = self else { return }
                
                // Pretend we stop loading
                
                switch result {
                case .success(let details):
                    self.details = details
                    
                    // Reset current input.
                    self.currentInput = details.characters.map({ char in "" })
                    
                    print("Hint: \(details.characters)")
                    self.scene.send(self.detailsViewData(from: details))
                    
                case .failure(let error):
                    self.details = nil
                    self.currentInput.removeAll()
                    self.alert.send(AlertViewData.alert(from: error))
                }
            }).disposed(by: disposeBag)
    }
}

// MARK: - Private

private extension MastermindGameViewModel {
    func detailsViewData(from details: MastermindGameDetails) -> MastermindGameViewData {
        return MastermindGameViewData(
            actionButtonTitle: NSLocalizedString("Check", comment: ""))
    }
    
    func update(input: String, at index: Int) {
        guard index < currentInput.count else { return }
        
        currentInput[index] = input
        actionStateObject.send(MastermindGameViewData.ActionState(active: !currentInput.contains("")))
    }
    
    func fieldState(for input: String, at index: Int) -> MastermindGameViewData.FieldState {
        guard let details = details, index < details.characters.count else { return .missing}
        
        let strIndex = details.characters.index(details.characters.startIndex, offsetBy: index)
        if input == String(details.characters[strIndex]) {
            return .match
        } else if details.characters.contains(input) {
            return .closeMatch
        } else {
            return .missing
        }
    }
}

// MARK: - MastermindGameViewModelProtocol

extension MastermindGameViewModel: MastermindGameViewModelProtocol {
    func shouldUpdate(text: String, at index: Int) -> Bool {
        guard let details = details else { return false }
        
        if text.isEmpty { // Clear the field.
            update(input: text, at: index)
            return true
        }
        
        let shouldUpdate = (text.count == 1) && details.allowedCharacters.contains(text)
        if shouldUpdate {
            update(input: text, at: index)
        }
        
        return shouldUpdate
    }
    
    func validate() {
        var fieldsState = [MastermindGameViewData.FieldState]()
        
        for (index, character) in currentInput.enumerated() {
            fieldsState.append(fieldState(for: character, at: index))
        }
        
        fieldsStateObject.send(fieldsState)
    }
}
