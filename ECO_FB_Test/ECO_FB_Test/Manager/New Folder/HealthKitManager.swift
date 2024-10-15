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
    
    static let shared = HealthKitManager()
    
//    let read = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
    let read: Set<HKSampleType> = [
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
    ]
    
    var stepCount = 0
    var distanceWalking = 0.0
    
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
    
    func loadData() {
        self.readCurrentStepCount()
        self.readCurrentDistance()
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
                    print("걸음수 가져오기 오류: \(error!.localizedDescription)")
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
    
    /**
     건강앱의 걷기,뛴 거리 데이터를 가져오는 함수
     */
    func readCurrentDistance() {
        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            print("distanceType 타입을 가져올 수 없습니다.")
            return
        }
        
        let now = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] (_, result, error) in
            guard let self = self, let result = result, let sum = result.sumQuantity() else {
                if error != nil {
                    print("거리 가져오기 오류: \(error!.localizedDescription)")
                }
                return
            }
            
            let distance = sum.doubleValue(for: .meter())
            DispatchQueue.main.async {
                self.distanceWalking = distance
            }
        }
        
        healthStore.execute(query)
    }
}
