//
//  HealthKitManager.swift
//  ECO_FB_Test
//
//  Created by 최승호 on 10/14/24.
//

import Foundation
import HealthKit

@Observable
class HealthKitManager {
    let healthStore = HKHealthStore()
    
    let read = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
    
    var stepCount = 0
    /**
     건강앱 권한요청 함수
     */
    func requestAuthorization() {
        self.healthStore.requestAuthorization(toShare: [], read: read) { success, error in
            if success {
                print("Authorization successful")
            } else {
                print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    /**
     오늘 날짜의 걷기데이터를 가져오는 함수
     */
    func readCurrentStepCount() {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            print("stepCount 타입을 가져올 수 없습니다.")
            return
        }
        
        let now = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] (_, result, error) in
            guard let self = self, let result = result, let sum = result.sumQuantity() else {
                if error != nil {
                    print("칼로리 가져오기 오류: \\(error.localizedDescription)")
                }
                return
            }
            
            let stepCount = Int(sum.doubleValue(for: .count()))
            DispatchQueue.main.async {
                self.stepCount = stepCount
            }
        }
        
        healthStore.execute(query)
    }
}
