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
    public enum Operation: String {
        
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
    
    static let zero = "0"
    let calculatorProxy: ICalculatorProxy
    var leftNumber: String = CalculatorCommands.zero
    var operation: String?
    var rightNumber: String?
    var repeatNumber: String?
    
    public init(calculatorProxy: ICalculatorProxy) {
        self.calculatorProxy = calculatorProxy
    }
 
    public func numberChanged(number: String) throws -> String {
        guard let _ = Double(number) else {
            throw Error.InvalidNumber
        }
        repeatNumber = nil
        if operation == nil {
            leftNumber = number
            return leftNumber
        }
        rightNumber = number
        return rightNumber!
    }
    
    public func perform(operation: String) throws -> String {
        guard let _ = Operation(rawValue: operation) else {
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
        repeatNumber = nil
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
        repeatNumber = nil
        self.leftNumber = CalculatorCommands.zero
        self.operation = nil
        self.rightNumber = nil
        return String(calculatorProxy.allClear())
    }
    
    public func equals() -> String {
        if rightNumber == nil {
            if operation != nil {
                if repeatNumber != nil {
                    rightNumber = repeatNumber
                } else {
                    repeatNumber = leftNumber
                    rightNumber = leftNumber
                }
                return performBinaryOperation(keepOperation: true)
            }
            return leftNumber
        }
        assert(self.operation != nil)
        return performBinaryOperation()
    }

    // MARK: - Private
    
    private func performBinaryOperation(keepOperation keepOperation: Bool = false) -> String {
        guard let ln = Double(leftNumber), operation = operation, op = Operation(rawValue: operation), rightNumber = rightNumber, rn = Double(rightNumber) else {
            abort()
        }
        let result = calculatorProxy.perform(ln, op.performer, rn)
        if result == Double(Int(result)) {
            self.leftNumber = String(Int(result))
        } else {
            self.leftNumber = String(result)
        }
        self.operation = keepOperation ? self.operation : nil
        self.rightNumber = nil
        return leftNumber
    }
    
}