//
//  Define.swift
//  TestDataOne
//
//  Created by picomax on 9/12/17.
//  Copyright © 2017 hooni.net. All rights reserved.
//

import Foundation

func dLog(_ items: Any..., file: String = #file, line: Int = #line, function: String = #function) {
    var str: String = ""
    if let f = file.components(separatedBy: "/").last {
        str = "[\(f)][\(function)][\(line)]"
    } else {
        str = "[\(function)][\(line)]"
    }
    
    for item in items {
        str = str + " " + String(describing: item)
    }
    
    #if DEBUG
        print(NSDate(), str)
    #endif
}
