//
//  BoxedInt.swift
//  Benchmark
//
//  Created by Pavel Osipov on 03/01/2019.
//  Copyright © 2019 Pavel Osipov. All rights reserved.
//

import Foundation

class BoxedInt {
    let value: Int
    
    init(value: Int) {
        self.value = value
    }
}

extension BoxedInt : Equatable {
    public static func == (lhs: BoxedInt, rhs: BoxedInt) -> Bool {
        return lhs.value == rhs.value
    }
}

extension BoxedInt : Comparable {
    public static func < (lhs: BoxedInt, rhs: BoxedInt) -> Bool {
        return lhs.value < rhs.value
    }
    
    public static func <= (lhs: BoxedInt, rhs: BoxedInt) -> Bool {
        return lhs.value <= rhs.value
    }
    
    public static func >= (lhs: BoxedInt, rhs: BoxedInt) -> Bool {
        return lhs.value >= rhs.value
    }
    
    public static func > (lhs: BoxedInt, rhs: BoxedInt) -> Bool {
        return lhs.value > rhs.value
    }
}

extension BoxedInt: CustomStringConvertible {
    var description: String {
        return "\(value)"
    }
}
