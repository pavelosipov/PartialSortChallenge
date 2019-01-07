//
//  RecursiveHeapSort.swift
//  Benchmark
//
//  Created by Tim Vermeulen
//  Copyright © 2018 Tim Vermeulen. All rights reserved.
//  Original source location – https://gist.github.com/timvermeulen/2174f84ade2d1f97c4d994b7a3156454
//

extension Sequence {
    func min(_ n: Int, by areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        var iterator = makeIterator()
        guard let first = iterator.next() else { return [] }
        
        return withoutActuallyEscaping(areInIncreasingOrder) { areInIncreasingOrder in
            var heap = NonEmptyMaxHeap(root: first, by: areInIncreasingOrder)
            var heapSize = 1
            
            while heapSize < n, let element = iterator.next() {
                heap.insert(element)
                heapSize += 1
            }
            
            while let element = iterator.next() {
                if areInIncreasingOrder(element, heap.root) {
                    heap.replaceRoot(with: element)
                }
            }
            
            return heap.elements.sorted(by: areInIncreasingOrder)
        }
    }
    
    func max(_ n: Int, by areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        return min(n, by: { !areInIncreasingOrder($0, $1) })
    }
}

extension Sequence where Element: Comparable {
    func min(_ n: Int) -> [Element] {
        return min(n, by: <)
    }
    
    func max(_ n: Int) -> [Element] {
        return max(n, by: <)
    }
}

struct NonEmptyMaxHeap<Element> {
    private(set) var elements: [Element]
    private let areInIncreasingOrder: (Element, Element) -> Bool
    
    init(root: Element, by areInIncreasingOrder: @escaping (Element, Element) -> Bool) {
        self.elements = [root]
        self.areInIncreasingOrder = areInIncreasingOrder
    }
}

extension NonEmptyMaxHeap {
    private subscript(safe index: Int) -> Element? {
        return elements.indices.contains(index) ? elements[index] : nil
    }
    
    private mutating func upHeap(_ element: Element, at index: Int) {
        guard index != 0 else { return }
        
        let parentIndex = (index - 1) / 2
        let parent = elements[parentIndex]
        guard areInIncreasingOrder(parent, element) else { return }
        
        elements.swapAt(index, parentIndex)
        upHeap(element, at: parentIndex)
    }
    
    private mutating func downHeap(_ element: Element, at index: Int) {
        let element = elements[index]
        let leftIndex = index * 2 + 1
        guard let left = self[safe: leftIndex] else { return }
        
        let rightIndex = leftIndex + 1
        
        if let right = self[safe: rightIndex], areInIncreasingOrder(element, right) && areInIncreasingOrder(left, right) {
            elements.swapAt(index, rightIndex)
            downHeap(right, at: rightIndex)
        } else if areInIncreasingOrder(element, left) {
            elements.swapAt(index, leftIndex)
            downHeap(left, at: leftIndex)
        }
    }
    
    mutating func insert(_ element: Element) {
        elements.append(element)
        upHeap(element, at: elements.count - 1)
    }
    
    var root: Element {
        return elements.first!
    }
    
    mutating func replaceRoot(with element: Element) {
        elements[0] = element
        downHeap(element, at: 0)
    }
}
