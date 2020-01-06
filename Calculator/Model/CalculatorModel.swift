//
//  CalculatorModel.swift
//  Calculator
//
//  Created by huangjian on 2020/1/2.
//  Copyright © 2020 huangjian. All rights reserved.
//

import Foundation

class CalculatorModel: ObservableObject {
    //ObservableObject 协议要求实现类型是 class，它只有一个需要实现的属性:objectWillChange。在数据将要发生改变时，这个属性用来向外进行 “广播”， 它的订阅者 (一般是 View 相关的逻辑) 在收到通知后，对 View 进行刷新
    // @Published，编译器将会帮我们自动完成ObservableObject 需要实现的事情
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
