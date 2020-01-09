//
//  ShapeComponent.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-06.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import Foundation

protocol ShapeComponent {
    func pauseRight() -> UIBezierPath
    func playRight() -> UIBezierPath
    func pauseLeft() -> UIBezierPath
    func playLeft() -> UIBezierPath
}

class RelativeShape: ShapeComponent {
    private let width: CGFloat
    private let height: CGFloat
    
    private let pointA: CGPoint
    private let pointB: CGPoint
    private let pointC: CGPoint
    
    private var pointD: CGPoint {
        return midPoint(point1: pointA, point2: pointB)
    }
    private var pointE: CGPoint {
        return midPoint(point1: pointC, point2: pointB)
    }
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        
        pointA = CGPoint(x: 0, y: 0.0555 * height)
        pointB = CGPoint(x: width, y: 0.5 * height)
        pointC = CGPoint(x: 0, y: height - 0.0555 * height)
    }
    
    private func midPoint(point1: CGPoint, point2: CGPoint) -> CGPoint {
        let newX = (point1.x + point2.x) / 2.0
        let newY = (point1.y + point2.y) / 2.0
        
        return CGPoint(x: newX, y: newY)
    }
    
    func pauseLeft() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0666 * width, y: 0))
        path.addLine(to: CGPoint(x: 0.0666 * width + 0.25 * width, y: 0))
        path.addLine(to: CGPoint(x: 0.0666 * width + 0.25 * width, y: height))
        path.addLine(to: CGPoint(x: 0.0666 * width, y: height))
        path.close()
        
        return path
    }
    
    func playLeft() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: pointA)
        path.addLine(to: pointD)
        path.addLine(to: pointE)
        path.addLine(to: pointC)
        path.close()
        
        return path
    }
    
    func pauseRight() -> UIBezierPath {
        let path = UIBezierPath()
        let xOffset = (0.0666 + 0.25 + 0.283) * width
        
        path.move(to: CGPoint(x: xOffset, y: 0))
        path.addLine(to: CGPoint(x: (0.0666 + 0.25 + 0.283 + 0.25) * width, y: 0))
        path.addLine(to: CGPoint(x: (0.0666 + 0.25 + 0.283 + 0.25) * width, y: height))
        path.addLine(to: CGPoint(x: xOffset, y: height))
        path.close()
        
        return path
    }
    
    func playRight() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: pointD)
        path.addLine(to: pointB)
        path.addLine(to: pointB)
        path.addLine(to: pointE)
        path.close()
        
        return path
    }
}
