//
//  CalculatorButtonItem.swift
//  Calculator
//
//  Created by huangjian on 2019/12/23.
//  Copyright © 2019 huangjian. All rights reserved.
//

import Foundation
import UIKit

//MARK: - 按钮Model类
enum CalculatorButtonItem {
    
    enum Op: String {
        case plus = "+"
        case minus = "-"
        case divide = "÷"
        case multiply = "×"
        case equal = "="
    }
    
    enum Command: String {
        case clear = "AC"
        case flip = "+/-"
        case percent = "%"
        
    }
    ///  0 至 9 的数字
    case digit(Int)
    /// 小数点
    case dot
    /// 加减乘除等号这样的操作
    case op(Op)
    /// 清空、符号翻转等这类命令
    case command(Command)
    
}

extension CalculatorButtonItem: Hashable {
    var title: String {
        switch self {
        case .digit(let value):
            return String(value)
        case .dot:
            return "."
        case .op(let op):
            return op.rawValue
        case .command(let command):
            return command.rawValue
            
        }
    }
    var size: CGSize {
        if case .digit(let value) = self, case value = 0 { //按钮是0 调整宽度
            return CGSize(width: ScaleFrame(float: 88)*2 + ScaleFrame(float: 8), height: ScaleFrame(float: 88))
        }
        return CGSize(width: ScaleFrame(float: 88), height: ScaleFrame(float: 88))
    }
    
    var backgroundColorName: String {
        
        switch self {
        case .digit,.dot:
            return "digitBackground"
        case .op:
            return "operatorBackground"
        case .command:
            return "commandBackground"
        }
    }
    
    var titleColorName: String {
        switch self {
        case .digit,.dot,.op:
            return "titlewhite"
        case .command:
            return "titleblack"
        }
    }
    
}

//MARK: - 方便输出打印
extension CalculatorButtonItem: CustomStringConvertible{
    var description: String {
        switch self {
        case .digit(let num): return String(num)
        case .dot: return "."
        case .op(let op): return op.rawValue
        case .command(let command): return command.rawValue
        }
    }
}
