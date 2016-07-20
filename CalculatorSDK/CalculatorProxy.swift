//
//  CalculatorProxy.swift
//  CalculatorSDK
//
//  Created by Avi Cohen on 20/7/16.
//  Copyright © 2016 Avi Cohen. All rights reserved.
//

import Foundation

public class CalculatorProxy {
    
    var sum: Double = 0
    
}

extension CalculatorProxy: ICalculatorProxy {
    
    public func perform(letfNumber: Double, _ operation: (Double, Double) -> Double, _ rightNumber: Double) -> Double {
        sum = operation(letfNumber, rightNumber)
        return sum
    }
    
    public func percent(number: Double) -> Double {
        return number / 100
    }
    
    public func plusMinus(number: Double) -> Double {
        return -number
    }
    
    public func allClear() -> Double {
        sum = 0
        return 0
    }
    
}