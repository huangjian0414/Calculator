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
    var body: some View {
        HStack(){
            Spacer()
            Text("0")
                .font(.system(size: ScaleFrame(float: 76)))
            .minimumScaleFactor(0.5)
                .padding([.trailing,.leading],ScaleFrame(float: 18))
            .lineLimit(1)
            .foregroundColor(Color("mytextcolor"))
        }
    }
}
