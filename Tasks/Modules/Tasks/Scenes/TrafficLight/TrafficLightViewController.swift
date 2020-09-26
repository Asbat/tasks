//
//  TrafficLightViewController.swift
//  Tasks
//
//  Created by Alexey Stoyanov on 25.09.20.
//  Copyright © 2020 Alexey Stoyanov. All rights reserved.
//

import UIKit
import Combine

class TrafficLightViewController: ViewController {
    
    enum Layout {
        enum Stack {
            static let insets = UIEdgeInsets(top: 50.0, left: 0.0, bottom: 0.0, right: 0.0)
            static let spacing: CGFloat = 15.0
            static let size = CGSize(width: 50.0, height: 180.0)
            static let initialAlpha: CGFloat = 0.3
        }
    }
    
    // MARK: Properties
    
    private let verticalStack = UIStackView.vertical(
        views: [UIView(), UIView(), UIView()],
        distribution: .fillEqually,
        alignment: .fill,
        spacing: Layout.Stack.spacing)
    
    private var actionState: AnyCancellable?
    private var fieldsState: AnyCancellable?
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        // Stack
        verticalStack.arrangedSubviews[0].backgroundColor = .green
        verticalStack.arrangedSubviews[1].backgroundColor = .orange
        verticalStack.arrangedSubviews[2].backgroundColor = .red
        verticalStack.arrangedSubviews.forEach({
            $0.alpha = Layout.Stack.initialAlpha
            $0.pin(.width, to: verticalStack, .width)
        })
        
        self.view.add(subview: verticalStack)
            .safeAutopin([.top], edgeInsets: Layout.Stack.insets).view
            .autoSize(Layout.Stack.size).view
            .autopin(.centerX)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        verticalStack.arrangedSubviews.forEach({
            $0.layer.cornerRadius = verticalStack.bounds.size.width / 2.0
        })
    }
    
    override func bindViewModel(viewModel: ViewModelProtocol?) {
        super.bindViewModel(viewModel: viewModel)
        
        bindSceneViewData()
    }
}

// MARK: - Private

private extension TrafficLightViewController {
    func bindSceneViewData() {
        self.scene = viewModel?.scene.sink(
            receiveCompletion: { (completion) in
                
            },
            receiveValue: { [weak self] (viewData) in
                guard let self = self else { return }
                guard let viewData = viewData as? TrafficLightViewData else { return }
                
                for (index, state) in viewData.states.enumerated() {
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        self?.verticalStack.arrangedSubviews[index].layer.opacity = Float(state ? 1.0 : Layout.Stack.initialAlpha)
                    }
                }
            })
    }
}
