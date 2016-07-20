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
    
    static let one = "1"
    static let two = "2"
    static let five = "5"
    static let seven = "7"
    static let ten = "10"
    static let plusOp = "+"
    static let multiplyOp = "*"
    static let divideOp = "/"
    static let errorOp = "<"
    static let errorNum = "s"
    
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
    
    func testPerformPlus_validOperationAndNumbers_OK() {
        var result = try! commands.numberChanged(CalculatorSDKTests.five)
        result = try! commands.perform(CalculatorSDKTests.plusOp)
        XCTAssert(result == CalculatorSDKTests.five)
        result = try! commands.numberChanged(CalculatorSDKTests.two)
        XCTAssert(result == CalculatorSDKTests.two)
        result = try! commands.perform(CalculatorSDKTests.plusOp)
        XCTAssert(result == CalculatorSDKTests.seven)
    }
    
    func testPerformPlusAndEquals_validOperationAndNumbers_OK() {
        var result = try! commands.numberChanged(CalculatorSDKTests.five)
        result = try! commands.perform(CalculatorSDKTests.plusOp)
        XCTAssert(result == CalculatorSDKTests.five)
        result = commands.equals()
        XCTAssert(result == CalculatorSDKTests.ten)
    }
    
    func testPerformPlus_invalidOperationButValidNumber_Throws() {
        XCTAssertThrowsError(try commands.perform(CalculatorSDKTests.errorOp)) { (error) in
            XCTAssertEqual(error as? CalculatorCommands.Error, CalculatorCommands.Error.InvalidOperation)
        }
    }
    
    func testPerformPlus_validOperationButinvalidNumber_Throws() {
        XCTAssertThrowsError(try commands.numberChanged(CalculatorSDKTests.errorNum)) { (error) in
            XCTAssertEqual(error as? CalculatorCommands.Error, CalculatorCommands.Error.InvalidNumber)
        }
    }
    
    func testPerformDevideAndEquals_validOperationAndNumbers_OK() {
        var result = try! commands.numberChanged(CalculatorSDKTests.ten)
        result = try! commands.perform(CalculatorSDKTests.divideOp)
        result = commands.equals()
        XCTAssert(result == CalculatorSDKTests.one)
    }
    
    func testClear_validOperationAndNumbers_OK() {
        var result = try! commands.numberChanged(CalculatorSDKTests.five)
        result = try! commands.perform(CalculatorSDKTests.divideOp)
        XCTAssert(result == CalculatorSDKTests.five)
        result = commands.clear()
        XCTAssert(result == CalculatorSDKTests.five)
        result = try! commands.perform(CalculatorSDKTests.multiplyOp)
        result = try! commands.numberChanged(CalculatorSDKTests.two)
        XCTAssert(result == CalculatorSDKTests.two)
        result = commands.equals()
        XCTAssert(result == CalculatorSDKTests.ten)
    }
    
}
