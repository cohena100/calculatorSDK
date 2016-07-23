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
    
    public var display = "0"
    public var acOrC = Action.c

    let calculatorProxy: ICalculatorProxy
    var leftNumber: Double = 0
    var operation: Operation?
    var rightNumber: Double?
    var pointActionDone = false
    
    public init(calculatorProxy: ICalculatorProxy) {
        self.calculatorProxy = calculatorProxy
    }
 
    public func keyAction(action: Action) {
        switch action {
        case .plus:
            display = toString(actionOnOperation({ $0 + $1 }))
            acOrC = Action.c
        case .minus:
            display = toString(actionOnOperation({ $0 - $1 }))
            acOrC = Action.c
        case .multiply:
            display = toString(actionOnOperation({ $0 * $1 }))
            acOrC = Action.c
        case .divide:
            display = toString(actionOnOperation({ $0 / $1 }))
            acOrC = Action.c
        case .equals:
            display = toString(equals())
            acOrC = Action.c
        case .point:
            display = toString(point())
            acOrC = Action.c
        case .zero:
            display = toString(actionOnNumber(0))
            acOrC = Action.c
        case .one:
            display = toString(actionOnNumber(1))
            acOrC = Action.c
        case .two:
            display = toString(actionOnNumber(2))
            acOrC = Action.c
        case .three:
            display = toString(actionOnNumber(3))
            acOrC = Action.c
        case .four:
            display = toString(actionOnNumber(4))
            acOrC = Action.c
        case .five:
            display = toString(actionOnNumber(5))
            acOrC = Action.c
        case .six:
            display = toString(actionOnNumber(6))
            acOrC = Action.c
        case .seven:
            display = toString(actionOnNumber(7))
            acOrC = Action.c
        case .eight:
            display = toString(actionOnNumber(8))
            acOrC = Action.c
        case .nine:
            display = toString(actionOnNumber(9))
            acOrC = Action.c
        case .c:
            display = toString(clear())
            acOrC = Action.ac
        case .ac:
            display = toString(allClear())
            acOrC = Action.ac
        case .plusMinus:
            display = toString(plusMinus())
            acOrC = Action.c
        case .percent:
            display = toString(percent())
            acOrC = Action.c
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