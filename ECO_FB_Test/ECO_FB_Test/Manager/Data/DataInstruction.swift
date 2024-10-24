//
//  Instruction.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/22/24.
// 

import Foundation
import SwiftUI

struct DataInstruction: Comparable {
    let instructionType: InstructionType
    let dataFlow: Binding<DataFlow>?
    let parameter: DataParam
    @MainActor let action: (DataType, DataParam) async throws -> DataResult
    let completion: (Result<DataResult, Error>) -> Void
    
    static func < (lhs: DataInstruction, rhs: DataInstruction) -> Bool {
        lhs.instructionType.rawValue < rhs.instructionType.rawValue
    }
    
    static func > (lhs: DataInstruction, rhs: DataInstruction) -> Bool {
        lhs.instructionType.rawValue > rhs.instructionType.rawValue
    }
    
    static func == (lhs: DataInstruction, rhs: DataInstruction) -> Bool {
        lhs.instructionType.rawValue == rhs.instructionType.rawValue
    }
}
