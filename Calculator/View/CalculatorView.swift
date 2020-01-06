//
//  CalculatorView.swift
//  Calculator
//
//  Created by huangjian on 2019/12/23.
//  Copyright © 2019 huangjian. All rights reserved.
//

import Foundation
import SwiftUI

//MARK: - 单个按钮封装
struct CalculatorButton: View {
    let fontSize : CGFloat = ScaleFrame(float: 38)
    let title : String
    let size: CGSize
    let backgroundColorName : String
    let titleColorName : String
    let action : () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize))
                .foregroundColor(Color(titleColorName))
                .frame(width: size.width, height: size.height)
                .background(Color(backgroundColorName))
                .cornerRadius(ScaleFrame(float: 44))
        }
    }
}

//MARK: - 输入框
struct CalculatorText: View {
    @ObservedObject var model: CalculatorModel
    @State private var isShowAlert = false
    var body: some View {
        HStack(){
            Spacer()
            Text(model.brain.output)
                .font(.system(size: ScaleFrame(float: 76)))
                .minimumScaleFactor(0.5)
                .padding([.trailing,.leading],ScaleFrame(float: 18))
                .lineLimit(1)
                .foregroundColor(Color("mytextcolor"))
                .onTapGesture {
                    self.isShowAlert = true
            }.alert(isPresented: self.$isShowAlert) {  Alert.init(title: Text(model.historyDetail+model.brain.output), primaryButton: Alert.Button.cancel(Text("取消"), action: {
                    
                }), secondaryButton: Alert.Button.default(Text("复制"), action: {
                    UIPasteboard.general.string = self.model.historyDetail+self.model.brain.output
                }))
            }
        }
    }
}

struct HistoryView: View {
    ///@ObservedObject 的用处和 @State 非常相似，从名字看来它是来修饰一个对象的，这个对象可以给多个独立的 View 使用。如果你用 @ObservedObject 来修饰一个对象，那么那个对象必须要实现 ObservableObject 协议，然后用 @Published 修饰对象里属性，表示这个属性是需要被 SwiftUI 监听的
    @ObservedObject var model: CalculatorModel
    var body: some View {
        VStack {
            if model.totalCount == 0 {
                Text("没有履历")
            } else {
                HStack {
                    Text("履历").font(.headline)
                    Text("\(model.historyDetail)").lineLimit(nil)
                }
                HStack {
                    Text("显示").font(.headline)
                    Text("\(model.brain.output)")
                }
                Slider(value: $model.slidingIndex, in: 0...Float(model.totalCount), step: 1)
            }
        }.padding()
    }
}
