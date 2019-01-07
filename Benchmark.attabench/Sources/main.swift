//
//  main.swift
//  BinaryHeap
//
//  Created by Pavel Osipov on 03/01/2019.
//  Copyright © 2019 Pavel Osipov. All rights reserved.
//

import Foundation
import QuartzCore
import Benchmarking

//
// Performance Benchmark Section
//

let prefixCount = 20

let benchmark = Benchmark<[Int]>(title: "New Year Challange")
benchmark.descriptiveTitle = "Minimal elements lookup"
benchmark.descriptiveAmortizedTitle = "Average time spent on a minimal elements lookup"

benchmark.addTask(title: "Sort using CFBinaryHeap (by Pavel Osipov)") { input in
    let numbers = input.map { BoxedInt(value: $0) }
    return { timer in
        guard numbers.minObjects(prefixCount).count > 0 else { fatalError() }
    }
}

benchmark.addTask(title: "Insertion Sort (by Soroush Khanlou)") { input in
    let numbers = input.map { BoxedInt(value: $0) }
    return { timer in
        guard numbers.smallest(prefixCount, usingTest: <).count > 0 else { fatalError() }
    }
}

benchmark.addTask(title: "Sort using Recursion-Free Heap (by Pavel Osipov)") { input in
    let numbers = input.map { BoxedInt(value: $0) }
    return { timer in
        guard numbers.topElements(prefixCount, by: <).count > 0 else { fatalError() }
    }
}

benchmark.addTask(title: "Sort using Recursion-Based Heap (by Tim Vermuelen)") { input in
    let numbers = input.map { BoxedInt(value: $0) }
    return { timer in
        guard numbers.min(prefixCount).count > 0 else { fatalError() }
    }
}

benchmark.start()

//
// Performance Debug Section
//
/*
func measure<T>(numbers: [T], _ body: ([T]) -> [T]) -> CFTimeInterval {
    let start = CACurrentMediaTime()
    let prefix = body(numbers)
    let end = CACurrentMediaTime()
    guard prefix.count > 0 else {
        fatalError()
    }
    return end - start
}

for _ in 0...9 {
    let prefixCount = 20
    let numbers = (0..<327680).randomized().map { BoxedInt(value: $0) }
    
    // CFBinaryHeap (POBH)
    let pobh = measure(numbers: numbers) { (numbers) in
        return numbers.minObjects(prefixCount)
    }
    
    // Optimized Insertion Sort (SKIS)
    let skis = measure(numbers: numbers) { (numbers) in
        return numbers.smallest(prefixCount, usingTest: <)
    }

    // Recursion-Free Heap Sort (POHS)
    let pohs = measure(numbers: numbers) { (numbers) in
        return numbers.topElements(prefixCount, by: <)
    }
    
    // Recursive Heap Sort (TVHS)
    let tvhs = measure(numbers: numbers) { (numbers) in
        return numbers.min(prefixCount, by: <)
    }
    
    print("pobh(\(pobh))\tskis(\(skis))\tpohs(\(pohs))\ttvhs(\(tvhs))")
}
*/
