//
//  CalculatorCommands.swift
//  CalculatorSDK
//
//  Created by Avi Cohen on 20/7/16.
//  Copyright © 2016 Avi Cohen. All rights reserved.
//

import Foundation

public class CalculatorCommands {
    
    static let zero = "0"
    
    public enum Error: ErrorType {
        case InvalidOperation
        case InvalidNumber
    }
    
    public enum CalculatorProxyOperation: String {
        
        case plus = "+"
        case minus = "-"
        case multiply = "*"
        case divide = "/"
        
        var performer: (Double, Double) -> Double {
            get {
                switch self {
                case .plus:
                    return { $0 + $1 }
                case .minus:
                    return { $0 - $1 }
                case .multiply:
                    return { $0 * $1 }
                case .divide:
                    return { $0 / $1 }
                }
            }
        }
        
    }
    
    let calculatorProxy: ICalculatorProxy
    
    var leftNumber: String = CalculatorCommands.zero
    var operation: String?
    var rightNumber: String?
    
    public init(calculatorProxy: ICalculatorProxy) {
        self.calculatorProxy = calculatorProxy
    }
 
    public func numberChanged(number: String) throws -> String {
        guard let _ = Double(number) else {
            throw Error.InvalidNumber
        }
        if operation == nil {
            leftNumber = number
            return leftNumber
        }
        rightNumber = number
        return rightNumber!
    }
    
    public func perform(operation: String) throws -> String {
        guard let _ = CalculatorProxyOperation(rawValue: operation) else {
            throw Error.InvalidOperation
        }
        if self.rightNumber == nil {
            self.operation = operation
            return leftNumber
        }
        assert(self.operation != nil)
        return performBinaryOperation()
    }
    
    public func clear() -> String {
        if rightNumber != nil {
            rightNumber = nil
            return leftNumber
            
        }
        if operation != nil {
            operation = nil
            return leftNumber
        }
        leftNumber = CalculatorCommands.zero
        return leftNumber
    }
    
    public func allClear() -> String {
        self.leftNumber = CalculatorCommands.zero
        self.operation = nil
        self.rightNumber = nil
        return String(calculatorProxy.allClear())
    }
    
    public func equals() -> String {
        if rightNumber == nil {
            if operation != nil {
                rightNumber = leftNumber
                return performBinaryOperation()
            }
            return leftNumber
        }
        assert(self.operation != nil)
        return performBinaryOperation()
    }

    // MARK: - Private
    
    private func performBinaryOperation() -> String {
        guard let ln = Double(leftNumber), operation = operation, op = CalculatorProxyOperation(rawValue: operation), rightNumber = rightNumber, rn = Double(rightNumber) else {
            abort()
        }
        let result = calculatorProxy.perform(ln, op.performer, rn)
        if result == Double(Int(result)) {
            self.leftNumber = String(Int(result))
        } else {
            self.leftNumber = String(result)
        }
        self.operation = nil
        self.rightNumber = nil
        return leftNumber
    }
    
}