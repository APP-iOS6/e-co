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
    private(set) var changeStepCount = 0    // 직전의 걸음수와 새로 불러온 걸음수와 비교해 변화한 걸음수
    var todayPoint = 0
    var totalPoints = 0
    var isChangedTodayStepCount: Bool {
        return changeStepCount > 0
    }
    
    private(set) var todayStepCount: Int {  // 건강앱에서 가져온 오늘의 총 걸음수
        get {
            return stepCount
        }
        set {
            stepCount = min(newValue, 10000) // 10000걸음 이상 제한
        }
    }
    
    var earnedPointsToday: Int {    // 오늘 적립한 총 포인트
        get {
            return UserDefaults.standard.integer(forKey: "earnedPointsToday")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "earnedPointsToday")
        }
    }
    
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
    private func readCurrentStepCount() {
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
                } else {
                    print("걸음수 가져오기 성공!")
                }
                return
            }
            
            let stepCount = Int(sum.doubleValue(for: .count()))
            DispatchQueue.main.async {
                self.handleStepCountUpdate(newStepCount: stepCount)
            }
        }
        
        healthStore.execute(query)
    }
    
    /**
     건강앱의 걷기,뛴 거리 데이터를 가져오는 함수
     */
    private func readCurrentDistance() {
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
                } else {
                    print("거리 가져오기 성공!")
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
     걸음 수 업데이트 시 포인트를 계산하고 반영하는 함수
     */
    private func handleStepCountUpdate(newStepCount: Int) {
        if newStepCount > todayStepCount {
            changeStepCount = min(10000, newStepCount - todayStepCount)
            
            todayStepCount = newStepCount
            
            let newPoints = calculateStepPoints()
            
            let maxPoint = 150
            
            if earnedPointsToday < 150 { // 하루 최대 150포인트 제한
                if earnedPointsToday + newPoints > 150 {
                        totalPoints += (maxPoint - earnedPointsToday)
                        todayPoint += (maxPoint - earnedPointsToday)
                } else {
                    totalPoints += newPoints
                    todayPoint += newPoints
                }
            }
        }
        
        if totalPoints > 150 {
            totalPoints = 150
        }
        if todayPoint > 150 {
            todayPoint = 150
        }
    }
  
    /**
     걸음 수에 따라 포인트를 계산하는 함수
     */
    private func calculateStepPoints() -> Int {
        var points = 0

        let steps = remainStepCount + changeStepCount
        remainStepCount = steps % 1000

        points += (steps / 1000) * 10 // 1000걸음당 10포인트

        if todayStepCount >= 10000 && changeStepCount > 0 { // 10000걸음 달성 시 50포인트 추가
            points += 50
        }

        return points
    }
}
