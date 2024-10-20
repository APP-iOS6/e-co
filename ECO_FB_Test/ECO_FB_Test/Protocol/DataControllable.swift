//
//  DataControllable.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
// 

import Foundation
import FirebaseFirestore

@MainActor
protocol DataControllable {
    /// **바로 사용 금지.** DataManager의 fetchData를 호출해 사용해주세요.
    func fetchData(parameter: DataParam) async throws -> DataResult
    /// **바로 사용 금지.** DataManager의 updateData를 호출해 사용해주세요.
    func updateData(parameter: DataParam) async throws
    /// **바로 사용 금지.** DataManager의 deleteData를 호출해 사용해주세요.
    func deleteData(parameter: DataParam) async throws
}
