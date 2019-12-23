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
    
    var body: some View {
        VStack(spacing: ScaleFrame(float: 12)) {
            Spacer()
            CalculatorText()
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
    
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                CalculatorButton(
                    title: item.title,
                    size: item.size,
                    backgroundColorName: item.backgroundColorName,
                    titleColorName: item.titleColorName,
                    action: {
                        
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

