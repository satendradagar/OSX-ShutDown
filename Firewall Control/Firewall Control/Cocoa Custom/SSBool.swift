//
//  SSBool.swift
//  ThinPrint
//
//  Created by Satendra Singh on 02/03/18.
//  Copyright © 2018 TP. All rights reserved.
//

import Foundation

extension Bool{
    
    func stringNumberValue() -> String {
        switch self {
        case true:
            return "1"
        case false:
            return "0"
        }
    }
}
