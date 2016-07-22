//
//  ICalculatorProxy.swift
//  CalculatorSDK
//
//  Created by Avi Cohen on 20/7/16.
//  Copyright © 2016 Avi Cohen. All rights reserved.
//

import Foundation

public typealias Operation = (Double, Double) -> Double

public protocol ICalculatorProxy: class {
    
    func perform(letfNumber: Double, _ operation: Operation, _ rightNumber: Double) -> Double
    func percent(number: Double) -> Double
    func plusMinus(number: Double) -> Double
    func allClear() -> Double
    
}