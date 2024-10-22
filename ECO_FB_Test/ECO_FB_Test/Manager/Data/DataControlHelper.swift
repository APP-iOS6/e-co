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
        let firstInstruction = instructions.dequeue()
        
        guard var firstInstruction else {
            dataFlow = .none
            currentInstructionType = .none
            return
        }
        
        var top = instructions.top()
        var sameInstructions: [DataInstruction] = []
        sameInstructions.append(firstInstruction)
        
        while top != nil {
            if top!.instructionType == firstInstruction.instructionType {
                let instruction = instructions.dequeue()!
                sameInstructions.append(instruction)
                
                top = instructions.top()
            } else {
                break
            }
        }
        
        dataFlow = .loading
        currentInstructionType = firstInstruction.instructionType
        
        await withTaskGroup(of: Void.self) { [weak self] taskGroup in
            for instruction in sameInstructions {
                taskGroup.addTask { [weak self] in
                    guard let self = self else {
                        instruction.completion(.failure(CommonError.referenceError(reason: "Self is nil")))
                        return
                    }
                    
                    do {
                        let result = try await instruction.action(self.dataType, instruction.parameter)
                        instruction.completion(.success(result))
                    } catch {
                        instruction.completion(.failure(error))
                    }
                }
            }
        }
        
        currentInstructionType = .none
        dataFlow = .didLoad
    }
}
