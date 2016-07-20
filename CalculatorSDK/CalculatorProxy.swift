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
    var operation: CalculatorProxyOperation?
    
}

extension CalculatorProxy: ICalculatorProxy {
    
    public func perform(operation: CalculatorProxyOperation, on number: Double) -> Double {
        guard let op = self.operation else {
            self.operation = operation
            sum = number
            return sum
        }
        sum = op.perform(sum, number)
        self.operation = operation
        return sum
    }
    
    public func equals(on number: Double) -> Double {
        guard let op = self.operation else {
            sum = number
            return sum
        }
        sum = op.perform(sum, number)
        return sum
    }
}