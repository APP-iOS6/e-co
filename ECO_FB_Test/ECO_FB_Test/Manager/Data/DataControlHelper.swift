//
//  DataControlHelper.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/22/24.
// 

import Foundation

@MainActor
@Observable
final class DataControlHelper {
    private let dataType: DataType
    private var instructions: PriorityQueue<DataInstruction> = PriorityQueue {
        $0 > $1
    }
    private(set) var dataFlow: DataFlow = .none {
        didSet {
            handleDataFlow()
        }
    }
    private(set) var currentInstructionType: InstructionType = .none
    
    init(dataType: DataType) {
        self.dataType = dataType
    }
    
    func insertInstruction(_ instruction: DataInstruction) {
        instructions.enqueue(instruction)
        
        if dataFlow == .none {
            dataFlow = .didLoad
        }
    }
    
    private func handleDataFlow() {
        switch dataFlow {
        case .none, .loading:
            break
        case .didLoad:
            Task {
                await executeNextInstruction()
                
            }
        }
    }
    
    private func executeNextInstruction() async {
        let instruction = instructions.dequeue()
        
        guard let instruction else {
            dataFlow = .none
            currentInstructionType = .none
            return
        }
        
        currentInstructionType = instruction.instructionType
        dataFlow = .loading
        
        do {
            let result = try await instruction.action(dataType, instruction.parameter)
            instruction.completion(.success(result))
        } catch {
            instruction.completion(.failure(error))
        }
        
        currentInstructionType = .none
        dataFlow = .didLoad
    }
}
