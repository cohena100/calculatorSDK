//
//  ICalculatorProxy.swift
//  CalculatorSDK
//
//  Created by Avi Cohen on 20/7/16.
//  Copyright © 2016 Avi Cohen. All rights reserved.
//

import Foundation

public enum CalculatorProxyOperation: String {
    
    case plus = "+"
    
    var perform: (Double, Double) -> Double {
        get {
            switch self {
            case .plus:
                return { $0 + $1 }
            }
        }
    }

}

public protocol ICalculatorProxy: class {
    
    func perform(operation: CalculatorProxyOperation, on number: Double) -> Double
    func equals(on number: Double) -> Double

}