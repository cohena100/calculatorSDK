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
        var result = try! commands.perform("+", on: "5")
        XCTAssert(result == 5)
        result = try! commands.perform("+", on: "5")
        XCTAssert(result == 10)
    }
    
    func testPerformEquals_validOperationAndNumbers_OK() {
        var result = try! commands.equals(on: "5")
        XCTAssert(result == 5)
        result = try! commands.equals(on: "5")
        XCTAssert(result == 5)
    }
    
    func testPerformPlusAndEquals_validOperationAndNumbers_OK() {
        var result = try! commands.perform("+", on: "5")
        XCTAssert(result == 5)
        result = try! commands.equals(on: "5")
        XCTAssert(result == 10)
    }
    
    func testPerformPlus_invalidOperationButValidNumber_Throws() {
        XCTAssertThrowsError(try commands.perform("<", on: "5")) { (error) in
            XCTAssertEqual(error as? CalculatorCommands.Error, CalculatorCommands.Error.InvalidOperation)
        }
    }
    
    func testPerformPlus_validOperationButinvalidNumber_Throws() {
        XCTAssertThrowsError(try commands.perform("+", on: "n")) { (error) in
            XCTAssertEqual(error as? CalculatorCommands.Error, CalculatorCommands.Error.InvalidNumber)
        }
    }
    
    func testPerformEquals_invalidNumber_Throws() {
        XCTAssertThrowsError(try commands.equals(on: "d")) { (error) in
            XCTAssertEqual(error as? CalculatorCommands.Error, CalculatorCommands.Error.InvalidNumber)
        }
    }
    
}
