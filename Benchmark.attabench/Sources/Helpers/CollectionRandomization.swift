//
//  CollectionRandomization.swift
//  Benchmark
//
//  Created by Pavel Osipov on 03/01/2019.
//  Copyright © 2019 Pavel Osipov. All rights reserved.
//

import Foundation
import Benchmarking

extension RandomAccessCollection where Self: MutableCollection {
    public mutating func randomize() {
        for i in indices {
            let offset = Int.random(below: self.distance(from: i, to: self.endIndex))
            let j = self.index(i, offsetBy: offset)
            if i != j {
                self.swapAt(i, j)
            }
        }
    }
}

extension Sequence {
    public func randomized() -> [Iterator.Element] {
        var array = Array(self)
        array.randomize()
        return array
    }
}
