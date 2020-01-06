//
//  ContentView.swift
//  Calculator
//
//  Created by huangjian on 2019/12/23.
//  Copyright © 2019 huangjian. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    /// 简单做一下屏幕适配(整体进行缩放)
    //let scale: CGFloat = UIScreen.main.bounds.width/414
    @EnvironmentObject var model: CalculatorModel
    
    /// 使用 @State 修饰器我们可以关联出 View 的状态. SwiftUI 将会把使用过 @State 修饰器的属性存储到一个特殊的内存区域，并且这个区域和 View struct 是隔离的. 当 @State 装饰过的属性发生了变化，SwiftUI 会根据新的属性值重新创建视图
    @State private var editingHistory = false
    
    var body: some View {
        VStack(spacing: ScaleFrame(float: 12)) {
            Spacer()
            /// 当用户 使用手势关闭 HistoryView 时，SwiftUI 会通过 $editingHistory 这个 Binding 把值设回 false。
            Button("操作履历: \(model.history.count)") {
                self.editingHistory = true
            }.sheet(isPresented: $editingHistory) {
                HistoryView(model: self.model)
            }
            CalculatorText(model: model)
            CalculatorButtonPad()
                .padding(.bottom)

        }
        //.scaleEffect(scale)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            /// iPhone SE上跑
            //ContentView().previewDevice("iPhone SE")
        }
    }
}
//MARK: - 水平多个按钮
struct CalculatorButtonRow: View {
    let row: [CalculatorButtonItem]
    @EnvironmentObject var model: CalculatorModel
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                CalculatorButton(
                    title: item.title,
                    size: item.size,
                    backgroundColorName: item.backgroundColorName,
                    titleColorName: item.titleColorName,
                    action: {
                        self.model.apply(item: item)
                })
            }
        }
    }
    
}

//MARK: - 垂直布局
struct CalculatorButtonPad: View {
    
    let pad: [[CalculatorButtonItem]] = [ [.command(.clear), .command(.flip), .command(.percent), .op(.divide)],
        [.digit(7), .digit(8), .digit(9), .op(.multiply)],
        [.digit(4), .digit(5), .digit(6), .op(.minus)],
        [.digit(1), .digit(2), .digit(3), .op(.plus)],
        [.digit(0), .dot, .op(.equal)]
    ]
    var body: some View {
        VStack(spacing: ScaleFrame(float: 8)){
            ForEach(pad, id: \.self) { row in
                CalculatorButtonRow(row: row)
            }
        }
    }
}

