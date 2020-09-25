//
//  TasksViewController.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 24.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit

class TasksViewController: ViewController {
    
    enum Layout {
        enum Stack {
            static let insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
            static let spacing: CGFloat = 5.0
        }
    }
    
    // MARK: Properties
    
    weak var tasksViewModel: TasksViewModelProtocol? {
        get {
            return viewModel as? TasksViewModelProtocol
        }
        
        set {
            viewModel = newValue
        }
    }
    
    private let verticalStack = UIStackView.vertical(
        views: [],
        distribution: .fillProportionally,
        alignment: .fill,
        spacing: Layout.Stack.spacing)
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.add(subview: verticalStack)
            .safeAutopin([.top, .left, .bottom, .right], edgeInsets: Layout.Stack.insets)
    }
    
    override func bindViewModel(viewModel: ViewModelProtocol?) {
        super.bindViewModel(viewModel: viewModel)
        
        bindSceneViewData()
    }
}

// MARK: - Private

private extension TasksViewController {
    func bindSceneViewData() {
        self.scene = viewModel?.scene.sink(
            receiveCompletion: { (completion) in
                
            },
            receiveValue: { (viewData) in
                guard let viewData = viewData as? TasksViewData else { return }
                
                viewData.tasks.forEach({ (task) in
                    let button = UIButton()
                    button.setTitle(task.title, for: .normal)
                    button.setTitleColor(.black, for: .normal)
                    button.addTarget(self, action: #selector(TasksViewController.buttonHandler), for: UIControl.Event.touchUpInside)
                    self.verticalStack.addArrangedSubview(button)
                })
            })
    }
    
    @objc func buttonHandler(sender: UIButton) {
        guard let index = verticalStack.arrangedSubviews.firstIndex(of: sender) else { return }
        tasksViewModel?.didRequestTask(at: index)
    }
}
