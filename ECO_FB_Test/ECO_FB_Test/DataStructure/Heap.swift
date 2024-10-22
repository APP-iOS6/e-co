//
//  Heap.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/22/24.
//

import Foundation

struct Heap<T: Comparable> {
    private let sortBy: (T, T) -> Bool
    private let rootIndex: Int = 1
    private var elements: [T] = []
    
    var isEmpty: Bool { elements.count == 1 }
    var count: Int { elements.count - 1 }
    
    init(elements: [T], sortBy: @escaping (T, T) -> Bool) {
        self.elements = elements
        self.sortBy = sortBy
    }
    
    mutating func insert(_ node: T) {
        if elements.isEmpty {
            elements.append(node)
        }
        
        var index = elements.endIndex - 1
        
        elements.append(node)
        while index > rootIndex && sortBy(elements[index], elements[parent(of: index)]) == true {
            elements.swapAt(index, parent(of: index))
            index = parent(of: index)
        }
    }
    
    mutating func remove() -> T? {
        if isEmpty {
            return nil
        }
        
        elements.swapAt(rootIndex, elements.endIndex - 1)
        let removed = elements.removeLast()
        
        diveDown(from: rootIndex)
        
        return removed
    }
    
    mutating func peek() -> T? {
        if isEmpty {
            return nil
        }
        
        return elements[rootIndex]
    }
    
    private func leftChild(of index: Int) -> Int {
        return index * 2
    }
    
    private func rightChild(of index: Int) -> Int {
        return index * 2 + 1
    }
    
    private func parent(of index: Int) -> Int {
        return (index) / 2
    }
    
    mutating private func diveDown(from index: Int) {
        var higherPriority = index
        let left = leftChild(of: index)
        let right = rightChild(of: index)
        
        if left < elements.endIndex && sortBy(elements[left], elements[higherPriority]) == true {
            higherPriority = left
        }
        
        if right < elements.endIndex && sortBy(elements[right], elements[higherPriority]) == true {
            higherPriority = right
        }
        
        if higherPriority != index {
            elements.swapAt(higherPriority, index)
            diveDown(from: higherPriority)
        }
    }
}
