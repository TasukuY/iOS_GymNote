//
//  StringExtension.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/14/22.
//

import Foundation

extension String {
    
    struct NumFormatter {
        static let instance = NumberFormatter()
    }

    var doubleValue: Double? {
        return NumFormatter.instance.number(from: self)?.doubleValue
    }

    var integerValue: Int? {
        return NumFormatter.instance.number(from: self)?.intValue
    }
    
}//End of extension
