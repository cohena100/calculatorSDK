//
//  CalculatorCommands.swift
//  CalculatorSDK
//
//  Created by Avi Cohen on 20/7/16.
//  Copyright © 2016 Avi Cohen. All rights reserved.
//

import Foundation

public class CalculatorCommands {
    
    public enum Error: ErrorType {
        case InvalidOperation
        case InvalidNumber
    }
    
    let calculatorProxy: ICalculatorProxy
    
    public init(calculatorProxy: ICalculatorProxy) {
        self.calculatorProxy = calculatorProxy
    }
 
    public func perform(operation: String, on number: String) throws -> Double {
        guard let op = CalculatorProxyOperation(rawValue: operation) else {
            throw Error.InvalidOperation
        }
        guard let num = Double(number) else {
            throw Error.InvalidNumber
        }
        return calculatorProxy.perform(op, on: num)
    }
        
    public func equals(on number: String) throws -> Double {
        guard let num = Double(number) else {
            throw Error.InvalidNumber
        }
        return calculatorProxy.equals(on: num)
    }

}