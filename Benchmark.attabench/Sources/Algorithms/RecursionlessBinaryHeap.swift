//
//  RecursionlessBinaryHeap.swift
//  Benchmark
//
//  Created by Pavel Osipov on 04/01/2019.
//  Copyright © 2019 Pavel Osipov. All rights reserved.
//

import Foundation

class RecursionlessBinaryHeap<Element> {
    private var elements: [Element]
    private let greaterThan: (Element, Element) -> Bool
    
    public var top: Element? {
        return elements.first
    }
    
    public var count: Int {
        return elements.count
    }
    
    public var sortedElements: [Element] {
        let heap = RecursionlessBinaryHeap(self)
        var srt = [Element]()
        srt.reserveCapacity(heap.count)
        while 0 < heap.count {
            let e = heap.top!
            heap.pop()
            srt.append(e)
        }
        return srt
    }

    init(capacity: Int, comparator: @escaping (Element, Element) -> Bool) {
        elements = [Element]()
        elements.reserveCapacity(capacity)
        greaterThan = comparator
    }
    
    private init(_ heap: RecursionlessBinaryHeap<Element>) {
        elements = heap.elements
        greaterThan = heap.greaterThan
    }
    
    public func add(element e: Element) {
        let cnt = elements.count
        elements.append(e)
        var idx = cnt
        var pidx = (idx - 1) >> 1
        while 0 < idx {
            let pe = elements[pidx]
            if !greaterThan(pe, e) {
                break
            }
            elements[idx] = pe
            idx = pidx
            pidx = (idx - 1) >> 1
        }
        elements[idx] = e;
    }
    
    public func pop() {
        guard !elements.isEmpty else { return }
        var idx = 0
        let te = elements.removeLast()
        guard !elements.isEmpty else { return }
        var cidx = (idx << 1) + 1
        while cidx < elements.count {
            var e = elements[cidx]
            if cidx + 1 < elements.count {
                let e2 = elements[cidx + 1]
                if greaterThan(e, e2) {
                    cidx += 1;
                    e = e2;
                }
            }
            if greaterThan(e, te) {
                break
            }
            elements[idx] = e;
            idx = cidx;
            cidx = (idx << 1) + 1;
        }
        elements[idx] = te;
    }
    
    public func replaceTop(element: Element) {
        var idx = 0
        let te = element
        var cidx = (idx << 1) + 1
        while cidx < elements.count {
            var e = elements[cidx]
            if cidx + 1 < elements.count {
                let e2 = elements[cidx + 1]
                if greaterThan(e, e2) {
                    cidx += 1;
                    e = e2;
                }
            }
            if greaterThan(e, te) {
                break
            }
            elements[idx] = e;
            idx = cidx;
            cidx = (idx << 1) + 1;
        }
        elements[idx] = te;
    }
}

extension Sequence {
    func topElements(_ n: Int, by areInIncreasingOrder: (Self.Element, Self.Element) -> Bool) -> [Self.Element] {
        return withoutActuallyEscaping(areInIncreasingOrder) { areInIncreasingOrder in
            let heap = RecursionlessBinaryHeap<Self.Element>(capacity: n + 1, comparator: areInIncreasingOrder)
            for e in self.prefix(n) {
                heap.add(element: e)
            }
            for e in self.dropFirst(n) {
                if areInIncreasingOrder(e, heap.top!) {
                    heap.replaceTop(element: e)
                }
            }
            return heap.sortedElements
        }
    }
}
