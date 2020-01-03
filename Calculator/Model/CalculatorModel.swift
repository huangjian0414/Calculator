//
//  CalculatorModel.swift
//  Calculator
//
//  Created by huangjian on 2020/1/2.
//  Copyright © 2020 huangjian. All rights reserved.
//

import Foundation

class CalculatorModel: ObservableObject {
    
    @Published var brain: CalculatorBrain = .left("0") //默认状态
    @Published var history: [CalculatorButtonItem] = [] //存储操作
    
    private var temporaryKept: [CalculatorButtonItem] = []//存储slider 滑动后右边的item
    
    
    func apply(item: CalculatorButtonItem) {
        brain = brain.apply(item: item) // 点击操作
        history.append(item)
        
        temporaryKept.removeAll()
        slidingIndex = Float(totalCount)
    }
    //MARK: - 历史操作详细 显示字符串
    var historyDetail: String {
        /// 数组中每个元素通过某个方法进行转换，最后返回一个新的数组 ,joined 转为字符串
        history.map{ $0.description }.joined()
    }
    //MARK: - 根据滑块index 进行对应操作
    func keepHistory(upTo index: Int) {
        precondition(index <= totalCount, "Out of index.")

        let total = history + temporaryKept

        history = Array(total[..<index])
        temporaryKept = Array(total[index...])

        /// reduce 对数组的元素进行计算
        brain = history.reduce(CalculatorBrain.left("0")) {
            result, item in
            result.apply(item: item)
        }
    }
    //MARK: - 总操作数
    var totalCount: Int {
        history.count + temporaryKept.count
    }
    //MARK: - 滑块操作
    var slidingIndex: Float = 0 {
        didSet {
            keepHistory(upTo: Int(slidingIndex))
        }
    }
}
