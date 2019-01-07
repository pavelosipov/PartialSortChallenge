//
//  FoundationHeapSort.swift
//  Benchmark
//
//  Created by Pavel Osipov on 03/01/2019.
//  Copyright © 2019 Pavel Osipov. All rights reserved.
//

import Foundation

typealias ComparableObject = AnyObject & Comparable

fileprivate class BinaryHeapComparator {
    let apply: (UnsafeRawPointer?, UnsafeRawPointer?) -> CFComparisonResult
    init(_ comparator: @escaping (UnsafeRawPointer?, UnsafeRawPointer?) -> CFComparisonResult) {
        apply = comparator
    }
}

class BinaryHeap<Element> where Element: ComparableObject {
    private let heap: CFBinaryHeap
    private let comparator: BinaryHeapComparator
    
    var topElement: Element {
        return Unmanaged<Element>.fromOpaque(CFBinaryHeapGetMinimum(heap)).takeUnretainedValue()
    }
    
    var sortedElements: [Element] {
        let count = CFBinaryHeapGetCount(heap)
        let unsafeElements = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: count)
        CFBinaryHeapGetValues(heap, unsafeElements)
        let unsafeElementsBuffer = UnsafeBufferPointer(start: unsafeElements, count: count)
        let elements = unsafeElementsBuffer.map { Unmanaged<Element>.fromOpaque($0!).takeUnretainedValue() }
        unsafeElements.deallocate()
        return elements.reversed()
    }

    init(capacity: CFIndex) {
        var heapCallbacks = CFBinaryHeapCallBacks()
        heapCallbacks.compare = { unsafeLeft, unsafeRight, unsafeContext in
            let context = Unmanaged<AnyObject>.fromOpaque(unsafeContext!).takeUnretainedValue()
            let comparator = context as! BinaryHeapComparator
            return comparator.apply(unsafeLeft, unsafeRight)
        }
        comparator = BinaryHeapComparator({ (unsafeLeft, unsafeRight) -> CFComparisonResult in
            let left = Unmanaged<Element>.fromOpaque(unsafeLeft!).takeUnretainedValue()
            let right = Unmanaged<Element>.fromOpaque(unsafeRight!).takeUnretainedValue()
            if (left > right) {
                return .compareLessThan
            } else if (left < right) {
                return .compareGreaterThan
            } else {
                return .compareEqualTo
            }
        })
        var heapCompareContext = CFBinaryHeapCompareContext()
        heapCompareContext.info = Unmanaged.passUnretained(comparator).toOpaque()
        heap = CFBinaryHeapCreate(nil, 0, &heapCallbacks, &heapCompareContext)
    }
    
    func insert(_ element: Element) {
        CFBinaryHeapAddValue(heap, Unmanaged.passUnretained(element).toOpaque())
    }
    
    func replaceTop(element: Element) {
        CFBinaryHeapRemoveMinimumValue(heap)
        insert(element)
    }
}

extension Sequence where Self.Element: ComparableObject {
    func minObjects(_ n: Int) -> [Self.Element] {
        let heap = BinaryHeap<Self.Element>(capacity: n + 1)
        for e in self.prefix(n) {
            heap.insert(e)
        }
        var topElement = heap.topElement
        for element in self.dropFirst(n) {
            if element < topElement {
                heap.replaceTop(element: element)
                topElement = heap.topElement
            }
        }
        return heap.sortedElements
    }
}
