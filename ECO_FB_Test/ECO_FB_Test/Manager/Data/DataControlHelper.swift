//
//  DataControlHelper.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/22/24.
//

import Foundation
import Combine

@MainActor
@Observable
final class DataControlHelper {
    private let dataType: DataType
    private var anyCancellables: Set<AnyCancellable> = []
    private var instructions: PriorityQueue<DataInstruction> = PriorityQueue {
        $0 > $1
    }
    private(set) var currentInstructionType: InstructionType = .none
    
    init(dataType: DataType) {
        self.dataType = dataType
        
        let timer = Timer.publish(every: 0.3, on: .main, in: .default).autoconnect()
        
        timer
            .sink { [weak self] _ in
                Task {
                    await self?.executeNextInstruction()
                }
            }
            .store(in: &anyCancellables)
    }
    
    func insertInstruction(_ instruction: DataInstruction) {
        instructions.enqueue(instruction)
    }
    
    private func executeNextInstruction() async {
        let firstInstruction = instructions.dequeue()
        
        guard let firstInstruction else {
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
        
        currentInstructionType = firstInstruction.instructionType
        
        await withTaskGroup(of: Void.self) { [weak self] taskGroup in
            for instruction in sameInstructions {
                taskGroup.addTask { [weak self] in
                    guard let self = self else {
                        instruction.completion(.failure(CommonError.referenceError(reason: "Self is nil")))
                        return
                    }
                    
                    do {
                        instruction.dataFlow?.wrappedValue = .loading
                        
                        let result = try await instruction.action(self.dataType, instruction.parameter)
                        
                        instruction.dataFlow?.wrappedValue = .didLoad
                        instruction.completion(.success(result))
                    } catch {
                        instruction.completion(.failure(error))
                    }
                }
            }
        }
        
        currentInstructionType = .none
    }
}
