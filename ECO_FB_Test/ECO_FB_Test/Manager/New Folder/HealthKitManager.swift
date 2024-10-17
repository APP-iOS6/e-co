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
    
    let read: Set<HKSampleType> = [
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
    ]
    
    private var stepCount = 0
    private(set) var distanceWalking = 0.0
    private(set) var remainStepCount = 0
    private(set) var changeStepCount = 0
    private(set) var todayPoint = 0
    private(set) var isChangedTodayStepCount: Bool = false
    private(set) var todayStepCount: Int {
        get {
            return stepCount
        }
        set {
            if newValue > 10000 {
                stepCount = 10000
            } else {
                stepCount = newValue
            }
        }
    }
//    private(set) var stepAuthorization: Bool = false
    
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
        loadData()
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
//            stepAuthorization = false
            return
        }
//        stepAuthorization = true
        let now = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] (_, result, error) in
            guard let self = self, let result = result, let sum = result.sumQuantity() else {
                if error != nil {
                    print("걸음수 가져오기 오류: \(error!.localizedDescription)")
//                    self?.stepAuthorization = false
                }
                return
            }
            
            let stepCount = Int(sum.doubleValue(for: .count()))
            DispatchQueue.main.async {
                if self.todayStepCount < stepCount {
                    self.isChangedTodayStepCount = true
                    self.changeStepCount = stepCount - self.todayStepCount
                }
                self.todayStepCount = stepCount
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
    
    /**
     오늘의 걸음수를 가지고 오늘 획득한 총 포인트를 반환하는 함수
     */
    func getTodayStepPoint() -> Int {
        var point = 0
        remainStepCount = todayStepCount % 1000
        
        point += (todayStepCount / 1000) * 10    // 1000 걸음당 10포인트
        
        if todayStepCount >= 10000 {     // 10000걸음 목표 달성시 50포인트
            point += 50
        }
        
        todayPoint = point
        return point
    }
    
    /**
     걸음수가 변경이 되었을때 해당걸음수의 포인트를 계산하는 함수
     */
    func getStepPoint() -> Int {
        var point = 0
        
        let steps = remainStepCount + changeStepCount
        remainStepCount = steps % 1000
        
        point += (steps / 1000) * 10
        
        if todayStepCount == 10000 {
            point += 50
        }
        
        if isChangedTodayStepCount == true {
            isChangedTodayStepCount = false
        }
        
        return point
    }
}
