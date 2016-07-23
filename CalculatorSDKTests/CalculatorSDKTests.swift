//
//  CalculatorSDKTests.swift
//  CalculatorSDKTests
//
//  Created by Avi Cohen on 20/7/16.
//  Copyright © 2016 Avi Cohen. All rights reserved.
//

import XCTest
@testable import CalculatorSDK

class CalculatorSDKTests: XCTestCase {
    
    static let minusTen = "-10"
    static let tenPercent = "0.1"
    static let zero = "0"
    static let one = "1"
    static let two = "2"
    static let five = "5"
    static let fivePoint = "5."
    static let seven = "7"
    static let ten = "10"
    static let tenPoint5 = "10.5"
    static let fifteen = "15"
    static let twenty = "20"
    static let plusOp = "+"
    static let minusOp = "-"
    static let multiplyOp = "*"
    static let divideOp = "/"
    
    var commands: CalculatorCommands!
    var proxy: ICalculatorProxy!
    
    override func setUp() {
        super.setUp()
        proxy = CalculatorProxy()
        commands = CalculatorCommands(calculatorProxy: proxy)
    }
    
    override func tearDown() {
        commands = nil
        proxy = nil
        super.tearDown()
    }
    
    func test5Plus5equals10() {
        commands.keyAction(.five)
        XCTAssert(commands.display == CalculatorSDKTests.five)
        commands.keyAction(.plus)
        XCTAssert(commands.display == CalculatorSDKTests.five)
        commands.keyAction(.two)
        XCTAssert(commands.display == CalculatorSDKTests.two)
        commands.keyAction(.equals)
        XCTAssert(commands.display == CalculatorSDKTests.seven)
    }

    func test5Plus5Plus5Equals15() {
        commands.keyAction(.five)
        commands.keyAction(.plus)
        commands.keyAction(.five)
        commands.keyAction(.plus)
        commands.keyAction(.five)
        commands.keyAction(.equals)
        XCTAssert(commands.display == CalculatorSDKTests.fifteen)
    }

    func test5Point5Plus5Equals10Point5() {
        commands.keyAction(.five)
        commands.keyAction(.point)
        commands.keyAction(.five)
        commands.keyAction(.plus)
        commands.keyAction(.five)
        commands.keyAction(.equals)
        XCTAssert(commands.display == CalculatorSDKTests.tenPoint5)
    }
    
    func testMinus5Plus5Equals0() {
        commands.keyAction(.five)
        commands.keyAction(.plusMinus)
        commands.keyAction(.plus)
        commands.keyAction(.five)
        commands.keyAction(.equals)
        XCTAssert(commands.display == CalculatorSDKTests.zero)
    }
    
    func test5Point() {
        commands.keyAction(.five)
        commands.keyAction(.point)
        XCTAssert(commands.display == CalculatorSDKTests.fivePoint)
    }
    
}
