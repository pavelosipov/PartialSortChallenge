# Partial Sort Holiday Challenge

Soroush Khanlou wrote a fascinating article [Analyzing Complexity](http://khanlou.com/2018/12/analyzing-complexity/) where he demonstrates how to gain a performance boost by combining several operations instead of their serial execution. As an example, he provided a solution for finding top N elements (min or max) in the collection using O(N) additional memory. Additional exciting point for me there was the fact that Soroush's optimized version of insertion sort algorithm bet the heap-based sort. I was very curious about the efficiency of heap-based sorting implementation and wrote two implementations in addition to the one provided by Tim Vermeulen. The result is one the picture below.
![payload](https://raw.github.com/pavelosipov/PartialSortChallenge/master/.results/partial_sort_challenge.png)

## Considerations
* CFBinaryHeap based implementation is the best option if you work with reference types. I didn't find the safe way to integrate it with Swift's structs. Another annoying restriction is the absence of comparison predicate in the collection's method which provides top elements. When I tried to capture arbitrary one by CFBinaryHeap's compare closure, then performance degraded significantly.
* Soroush's algorithm is the best in pure Swift implementation. It can work with both value and reference types. Moreover, it is more flexible because any ad-hoc comparison predicate may be used.
* Recursion and type of collection matters. I reimplement Tim Vermeulen's binary heap without recursion and declare it as a class instead of struct. Both optimizations pitch in statistically noticeable performance boost.

## Reproducing Experiment using Attabench

1. Install and launch [Attabench](https://github.com/attaswift/Attabench).
2. Clone that repository `git clone https://github.com/pavelosipov/PartialSortChallenge.git`
3. Use Benchmark.attabench as a data source for the Attabench

## Reproducing Experiment without Attabench
1. Clone that repository `git clone https://github.com/pavelosipov/PartialSortChallenge.git`
2. Uncomment `Performance Debug Section`
3. Run the code in Release mode.
