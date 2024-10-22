//
//  PriorityQueue.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/22/24.
// 

import Foundation

struct PriorityQueue<T: Comparable> {
    private var heap: Heap<T>
    
    init(_ elements: [T] = [], _ sortBy: @escaping (T, T) -> Bool) {
        heap = Heap(elements: elements, sortBy: sortBy)
    }
    
    var isEmpty: Bool { heap.isEmpty }
    var count: Int { heap.count }
    
    mutating func dequeue() -> T? {
        return heap.remove()
    }
    
    mutating func enqueue(_ element: T) {
        heap.insert(element)
    }
    
    mutating func clear() {
        while !isEmpty {
            _ = heap.remove()
        }
    }
}
