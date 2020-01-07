//
//  Animator.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-07.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

struct AnimationBlock {
    let duration: Double
    var delay: Double = 0.0
    let time: UIView.AnimationOptions
    var before: (() -> Void)? = nil
    let after: () -> Void
}

class Animator {
    typealias CompletionBlock = () -> Void
    private var blocks: [AnimationBlock] = []
    private var completion: [String: CompletionBlock] = [:]
    private var _isAnimating: Bool = false
    
    var isAnimating: Bool {
        get {
            return _isAnimating
        }
    }
    
    init(_ block: AnimationBlock? = nil) {
        if let block = block {
            blocks.append(block)
        }
    }
    
    private func animateSequentially(blocks: [AnimationBlock], completion: [String: CompletionBlock], index: Int) {
        guard index < blocks.count else {
            completion.forEach { $0.value() }
            _isAnimating = false
            return
        }
        let currentBlock = blocks[index]
        currentBlock.before?()
        
        UIView.animate(withDuration: currentBlock.duration, delay: currentBlock.delay, options: currentBlock.time, animations: {
            currentBlock.after()
        }, completion: { done in
            self.animateSequentially(blocks: blocks, completion: completion, index: index + 1)
        })
    }
    
    func then(_ block: AnimationBlock) -> Animator {
        blocks.append(block)
        return self
    }
    
    func finally(key: String? = nil, _ completion: @escaping () -> Void) -> Animator {
        self.completion[key ?? UUID().uuidString] = completion
        
        return self
    }
    
    func animate() {
        _isAnimating = true
        animateSequentially(blocks: blocks, completion: completion, index: 0)
    }
}
