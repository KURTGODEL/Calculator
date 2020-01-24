//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Student on 2020-01-24.
//  Copyright © 2020 Student. All rights reserved.
//

import Foundation

struct CalculatorBrain {

    private var accumulator: String?;
    private var display: String?;
    private var operations: Dictionary<String, Operation> = [
       "π" : Operation.constant(Double.pi),
       "e": Operation.constant(Darwin.M_E),
       "AC": Operation.constant(0.0),
       "√": Operation.unaryOperation(sqrt),
       "|x|": Operation.unaryOperation(abs),
       "+/-": Operation.negateOperation(Double.negateC),
       "cos": Operation.trigOperation(cos),
       "sin": Operation.trigOperation(sin),
       "tan": Operation.trigOperation(tan),
       "log": Operation.logOperation(Double.logC),
       
    ];
    
    private enum Operation{
        case constant(Double);
        case unaryOperation((Double) -> Double);
        case binaryOperation((Double, Double) -> Double);
        case logOperation((Double) -> (Double) -> Double);
        case negateOperation((Double) -> () -> Double);
        case trigOperation((Double) -> Double);
        case equal;
    }
    
    

    mutating func performBinaryOperation(_ chain: String){
        var accN:Double?;
        var i = 0;
        
        for v in chain {
            if(["*", "-", "/", "+", "%"].contains(v)){
                let nChain:String = chain.replacingOccurrences(of: String(v), with: " ");
                var numbers: [String] = nChain.components(separatedBy: " ");
                
                let left: Double = Double(numbers[0])!;
                let right: Double = Double(numbers[1])!;
                
                switch (v) {
                    case "*":
                        accN = left * right;
                        break;
                    case "+":
                        accN = left + right;
                        break;
                    case "-":
                        accN = left - right;
                        break;
                    case "/":
                        accN = left / right;
                        break;
                    default:
                        break;
                }
            }
            
            i = i + 1;
        }
        
        setOperand(String(accN!));
    }
    
    mutating func performOperation(_ chain: String){
        if(chain == "="){
            performBinaryOperation(self.display!);
        }else{
            if(!isNumeric(accumulator!)){
                setOperand(String(0.0));
                return;
            }
            
            var accN:Double?;
            let accO:Double = Double(accumulator!)!;
            
            if let operation = operations[chain]{
                switch (operation) {
                    case .constant(let value):
                        accN = value;
                    case .unaryOperation(let function):
                        accN = function(accO);
                    case .binaryOperation(let function):
                        accN = function(accO, accO);
                    case .logOperation(let function):
                        accN = function(accO)(10.0);
                    case .negateOperation(let function):
                        accN = function(accO)();
                    case .trigOperation(let function):
                        accN = function(accO.degreesToRadians());
                    default:
                        break;
                }
                
                setOperand(String(accN!));
            }
        }
    }
    
    mutating func setDisplay(_ display: String){
        self.display = display;
    }
    
    mutating func setOperand(_ operand: String){
        accumulator = operand;
    }
    
    var result: String?{
        get { return accumulator }
    }
    
    private func isNumeric(_ a: String) -> Bool {
        return Double(a) != nil
    }
    
    func isEmpty(_ display: String) -> Bool{
        if(isNumeric(display) && Double(display) == 0.0){
            return true;
        }else{
            return false;
        }
    }
}

extension Double{
    func logC(_ base: Double) -> Double {
        return log(self) / log(base);
    }
    
    func negateC() -> Double {
        var num: Double = self;
        num.negate();
        return num;
    }
    
    func degreesToRadians() -> Double {
        return self * Double.pi / 180;
    }
    
    func radiansToDegress() -> Double {
        return self * 180 / Double.pi;
    }
}
