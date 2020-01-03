//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by huangjian on 2020/1/2.
//  Copyright © 2020 huangjian. All rights reserved.
//

import Foundation
// 计算过程：左侧数字 + 计算符号 + 右侧数字 + 计算符号或等号  对应下面枚举4种状态
enum CalculatorBrain {
    /// 计算器正在输入算式左侧数字，这个状态将在用户按下计算操作按钮(加减乘 除号) 后改变为下一个状态。
    case left(String)  // 2
    /// 计算器输入了左侧数字和计算符号，等待开始输入右侧符号。
    case leftOp(left: String, op: CalculatorButtonItem.Op) // 2 +
    /// 计算器已经输入了左侧数字，计算符号，和部分右侧数字，并在等待更多右侧数字的输入。
    case leftOpRight(left: String, op: CalculatorButtonItem.Op, right: String) // 2 + 3
    /// 输入或计算结果出现了错误，无法继续。比如发生了“除以0”的操作
    case error
    
    //MARK: - 每一次点击操作
    func apply(item: CalculatorButtonItem) -> CalculatorBrain {
        switch item {
        case .digit(let num):// 0-9 数字
            return apply(num: num)
        case .dot: //小数点
            return applyDot()
        case .op(let op): // 运算符
            return apply(op: op)
        case .command(let command): // 清空 等命令
            return apply(command: command)
        }
    }
    
    /// 对外结果字符串
    var output: String {
        let result: String
        switch self {
        case .left(let left):
            result = left
        case .leftOp(let left, _):
            result = left
        case .leftOpRight(_, _, let right):
            result = right
        case .error:
            return "Error"
        }
        guard let value = Double(result) else {
            return "Error"
        }
        return formatter.string(from: NSNumber(value: value))!
    }
    //MARK: - 下面模拟 2 + 3 + 4 = 的操作
    //MARK: - 点击了数字，根据当前状态做对应操作
    private func apply(num: Int) -> CalculatorBrain{
        //根据下面4种状态作不同操作
        switch self {
        /// 1. 点击了2  ---  刚开始输入数字  比如本项目例子 默认状态是.left("0") ,所以你再点击数字会走这里。假如你点击的是2
        case .left(let left):
            /// 还没有输入运算符号，所以还是.left状态. apply里的操作会返回字符串 2(开头就是0，处理掉)。，这时候return了当前的状态为.left("2")
            return .left(left.apply(num: num))
        /// 3. 点击了3 ---  刚开始输入右侧数字 ， 当前状态会变为.leftOpRight(left: 2, op: +, right: 3)
            
        /// 5 . 点击了4 --- 当前状态会变为.leftOpRight(left: 5, op: +, right: 4)
        case .leftOp(let left, let op):
            return .leftOpRight(left: left, op: op, right: "0".apply(num: num))
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: right.apply(num: num))
        case .error:
            return .left("0".apply(num: num))
        }
    }
    //MARK: - 点击了小数点，根据当前状态做对应操作
    private func applyDot() -> CalculatorBrain {
        switch self {
        case .left(let left):
            return .left(left.applyDot())
        case .leftOp(let left, let op):
            return .leftOpRight(left: left, op: op, right: "0".applyDot())
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: right.applyDot())
        case .error:
            return .left("0".applyDot())
        }
    }
    //MARK: - 点击了运算符，根据当前状态做对应操作
    private func apply(op: CalculatorButtonItem.Op) -> CalculatorBrain {
        switch self {
        /// 2. 点击了+ 号 ---  当前状态是.left("2") 走第一个case
        case .left(let left):
            /// 根据不同的运算符 返回不同的状态，这里假如点击了+ 号   这时候的状态会变成.leftOp . 即.leftOp(left: 2, op: +)
            switch op {
            case .plus, .minus, .multiply, .divide:
                return .leftOp(left: left, op: op)
            case .equal:
                return self
            }
        case .leftOp(let left, let currentOp):
            switch op {
            case .plus, .minus, .multiply, .divide:
                return .leftOp(left: left, op: op)
            case .equal:
                if let result = currentOp.calculate(l: left, r: left) {
                    return .leftOp(left: result, op: currentOp)
                } else {
                    return .error
                }
            }
        /// 4. 点击了 + 号 --- 当前状态是.leftOpRight(left: 2, op: +, right: 3)
        case .leftOpRight(let left, let currentOp, let right):
            switch op {
            case .plus, .minus, .multiply, .divide:
                /// 根据 加减乘除 作对应的操作 并返回结果。 即calculate(l: 2, r: 3) ，把左侧的2和3相加(currentOp 是2和3之间的运算符) ，返回状态 .leftOp(left: 5, op: +)
                if let result = currentOp.calculate(l: left, r: right) {
                    return .leftOp(left: result, op: op)
                } else {
                    return .error
                }
            /// 6. .leftOpRight(left: 5, op: +, right: 4) 状态 点击了=,
            case .equal:
                /// 将 4，5相加 返回结果，状态重置为.left(9)
                if let result = currentOp.calculate(l: left, r: right) {
                    return .left(result)
                } else {
                    return .error
                }
            }
        case .error:
            return self
        }
    }
    //MARK: - 点击了命令符，根据当前状态做对应操作
    private func apply(command: CalculatorButtonItem.Command) -> CalculatorBrain {
        switch command {
        case .clear:
            return .left("0")
        case .flip:
            switch self {
            case .left(let left):
                return .left(left.flipped())
            case .leftOp(let left, let op):
                return .leftOpRight(left: left, op: op, right: "-0")
            case .leftOpRight(left: let left, let op, let right):
                return .leftOpRight(left: left, op: op, right: right.flipped())
            case .error:
                return .left("-0")
            }
        case .percent:
            switch self {
            case .left(let left):
                return .left(left.percentaged())
            case .leftOp:
                return self
            case .leftOpRight(left: let left, let op, let right):
                return .leftOpRight(left: left, op: op, right: right.percentaged())
            case .error:
                return .left("-0")
            }
        }
    }
}

//MARK: - 格式化(小数点后位数限定在八位)
var formatter: NumberFormatter = {
    let f = NumberFormatter()
    f.minimumFractionDigits = 0
    f.maximumFractionDigits = 8
    f.numberStyle = .decimal
    return f
}()


extension String {
    //MARK: - 是否已经有了小数点
    var containsDot: Bool {
        return contains(".")
    }
    //MARK: - 是否以-号开头
    var startWithNegative: Bool {
        return starts(with: "-")
    }
    //MARK: - 添加数字
    func apply(num: Int) -> String {
        return self == "0" ? "\(num)" : "\(self)\(num)"
    }
    //MARK: - 添加小数点
    func applyDot() -> String {
        return containsDot ? self : "\(self)."
    }
    //MARK: - 加减号
    func flipped() -> String {
        if startWithNegative {
            var s = self
            s.removeFirst()
            return s
        } else {
            return "-\(self)"
        }
    }
    //MARK: - 除100
    func percentaged() -> String {
        return String(Double(self)! / 100)
    }
    
    //MARK: - 去除小数点后无效0
    func decimalNumber() -> String? {
        let conversionValue = Double(self)
        let doubleString = String(format: "%lf", conversionValue!)
        let decNumber = NSDecimalNumber(string: doubleString)
        return decNumber.stringValue
    }

}
//MARK: - 根据左右的数 进行加减乘除操作 并返回结果
extension CalculatorButtonItem.Op {
    func calculate(l: String, r: String) -> String? {

        guard let left = Double(l), let right = Double(r) else {
            return nil
        }
        let result: Double?
        switch self {
        case .plus: result = left + right
        case .minus: result = left - right
        case .multiply: result = left * right
        case .divide: result = right == 0 ? nil : left / right
        case .equal: fatalError()
        }
        return result.map { String($0) }?.decimalNumber()
    }
}
