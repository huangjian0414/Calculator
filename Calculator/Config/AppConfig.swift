//
//  AppConfig.swift
//  Calculator
//
//  Created by huangjian on 2019/12/23.
//  Copyright © 2019 huangjian. All rights reserved.
//

import Foundation
import UIKit

func ScaleFrame(float: CGFloat) -> CGFloat {
    let scale = UIScreen.main.bounds.width / 414
    
    return scale * float
}
