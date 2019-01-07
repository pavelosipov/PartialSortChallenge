//
//  InsertionSort.swift
//  Benchmark
//
//  Created by Soroush Khanlou
//  Copyright © 2018 Soroush Khanlou. All rights reserved.
//  Original source location – https://gist.github.com/khanlou/770c24d5141e52e117642c4b03498966
//

import Foundation

extension Array {
    func insertionIndex(of element: Element, by areInIncreasingOrder: (Element, Element) -> Bool) -> Index? {
        if isEmpty { return nil }
        if let last = self.last, areInIncreasingOrder(last, element) { return nil }
        var start = startIndex
        var end = endIndex
        while start < end {
            let middle = start / 2 + end / 2
            if areInIncreasingOrder(self[middle], element) {
                start = middle + 1
            } else if areInIncreasingOrder(element, self[middle]) {
                end = middle
            } else {
                return middle
            }
        }
        return start
    }
}

extension Sequence {
    
    func smallest(_ m: Int, usingTest areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        var result = self.prefix(m).sorted(by: areInIncreasingOrder)
        
        for e in self.dropFirst(m) {
            if let insertionIndex = result.insertionIndex(of: e, by: areInIncreasingOrder) {
                result.insert(e, at: insertionIndex)
                result.removeLast()
            }
        }
        
        return result
    }
    
}
