//
//  CalculatorCommands.swift
//  CalculatorSDK
//
//  Created by Avi Cohen on 20/7/16.
//  Copyright © 2016 Avi Cohen. All rights reserved.
//

import Foundation

public class CalculatorCommands {
    
    public enum Action: String {
        case plus = "+"
        case minus = "-"
        case multiply = "x"
        case divide = "/"
        case equals = "="
        case point = "."
        case zero = "0"
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case c = "C"
        case ac = "AC"
        case plusMinus = "⏈"
        case percent = "%"
    }
    
    let calculatorProxy: ICalculatorProxy
    var leftNumber: Double = 0
    var operation: Operation?
    var rightNumber: Double?
    var pointActionDone = false
    
    public init(calculatorProxy: ICalculatorProxy) {
        self.calculatorProxy = calculatorProxy
    }
 
    public func keyAction(action: Action) -> (display: String, showAC: Bool) {
        switch action {
        case .plus:
            return (display: toString(actionOnOperation({ $0 + $1 })), showAC: false)
        case .minus:
            return (display: toString(actionOnOperation({ $0 - $1 })), showAC: false)
        case .multiply:
            return (display: toString(actionOnOperation({ $0 * $1 })), showAC: false)
        case .divide:
            return (display: toString(actionOnOperation({ $0 / $1 })), showAC: false)
        case .equals:
            return (display: toString(equals()), showAC: false)
        case .point:
            return (display: toString(point()), showAC: false)
        case .zero:
            return (display: toString(actionOnNumber(0)), showAC: false)
        case .one:
            return (display: toString(actionOnNumber(1)), showAC: false)
        case .two:
            return (display: toString(actionOnNumber(2)), showAC: false)
        case .three:
            return (display: toString(actionOnNumber(3)), showAC: false)
        case .four:
            return (display: toString(actionOnNumber(4)), showAC: false)
        case .five:
            return (display: toString(actionOnNumber(5)), showAC: false)
        case .six:
            return (display: toString(actionOnNumber(6)), showAC: false)
        case .seven:
            return (display: toString(actionOnNumber(7)), showAC: false)
        case .eight:
            return (display: toString(actionOnNumber(8)), showAC: false)
        case .nine:
            return (display: toString(actionOnNumber(9)), showAC: false)
        case .c:
            return (display: toString(clear()), showAC: true)
        case .ac:
            return (display: toString(allClear()), showAC: true)
        case .plusMinus:
            return (display: toString(plusMinus()), showAC: false)
        case .percent:
            return (display: toString(percent()), showAC: false)
        }
    }
    
    private func actionOnNumber(number: Double) -> Double {
        if rightNumber != nil {
            rightNumber = newValFrom(rightNumber!, with: number)
            return rightNumber!
        }
        if operation != nil {
            rightNumber = number
            return rightNumber!
        }
        leftNumber = newValFrom(leftNumber, with: number)
        return leftNumber
    }
    
    private func actionOnOperation(operation: Operation) -> Double {
        let result = equals()
        self.operation = operation
        return result
    }
    
    private func equals() -> Double {
        guard let _ = self.operation, _ = self.rightNumber else {
            return leftNumber
        }
        let result = perform()
        return result
    }
    
    private func clear() -> Double {
        pointActionDone = false
        if rightNumber != nil {
            rightNumber = nil
        } else if operation != nil {
            operation = nil
        } else {
            leftNumber = 0
        }
        return leftNumber
    }
    
    private func allClear() -> Double {
        pointActionDone = false
        leftNumber = 0
        operation = nil
        rightNumber = nil
        return calculatorProxy.allClear()
    }
    
    private func percent() -> Double {
        if rightNumber != nil {
            rightNumber = calculatorProxy.percent(rightNumber!)
            return rightNumber!
        }
        leftNumber = calculatorProxy.percent(leftNumber)
        return leftNumber
    }
    
    private func plusMinus() -> Double {
        if rightNumber != nil {
            rightNumber = calculatorProxy.plusMinus(rightNumber!)
            return rightNumber!
        }
        leftNumber = calculatorProxy.plusMinus(leftNumber)
        return leftNumber
    }
    
    private func point() -> Double {
        let checkNumber: Double
        if rightNumber != nil {
            checkNumber = rightNumber!
        } else {
            checkNumber = leftNumber
        }
        if !pointActionDone && isInt(checkNumber) {
            pointActionDone = true
        }
        return checkNumber
    }

    private func perform() -> Double {
        guard let operation = self.operation, rightNumber = self.rightNumber else {
            abort()
        }
        let result = calculatorProxy.perform(leftNumber, operation, rightNumber)
        pointActionDone = false
        leftNumber = result
        self.operation = nil
        self.rightNumber = nil
        return leftNumber
    }
    
    private func newValFrom(from: Double, with: Double) -> Double {
        var newVal: Double = 0
        if pointActionDone {
            newVal = from + with / 10
            pointActionDone = false
        } else {
            let afterPointCount = afterPoint(from)
            if afterPointCount > 0 {
                newVal = from + with * pow(10, -afterPointCount - 1)
            } else {
                newVal = 10 * from + with
            }
        }
        return newVal
    }
    
    private func toString(number: Double) -> String {
        let formatted = isInt(number) ? String(Int(number)) : String(number)
        return pointActionDone ? formatted + "." : formatted
    }
    
    private func isInt(number: Double) -> Bool {
        return number == Double(Int(number))
    }
    
    private func afterPoint(number: Double) -> Double {
        var calcNumber = number
        var count: Double = 0
        while !isInt(calcNumber) {
            count += 1
            calcNumber *= 10
        }
        return count
    }
    
}