//
//  DataManager.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
// 

import Foundation
import FirebaseFirestore

@MainActor
@Observable
final class DataManager {
    static let shared: DataManager = DataManager()
    private let _db: Firestore = Firestore.firestore()
    @ObservationIgnored private lazy var dataStores: [DataControllable] = [
        UserStore.shared,
        SellerStore.shared,
        GoodsStore.shared,
        PaymentInfoStore.shared,
        AnnouncementStore.shared,
        ZeroWasteShopStore.shared
    ]
    
    var db: Firestore { _db }
    
    private init() {}
    
    /**
     유저 존재 여부 확인 메소드
     
     - parameter parameter: 에러가 날 수 있으니 꼭 .userLoad(id)를 넣어야 합니다.
     - Returns: 유저가 존재한다면 true, 존재하지 않는다면 false
     */
    func checkIfUserExists(parameter: DataParam) async -> Bool {
        do {
            let result = try await UserStore.shared.checkIfUserExists(parameter: parameter)
            
            return result
        } catch {
            print("Error: \(error)")
        }
        
        return false
    }
    
    /**
     유저의 로그인 방법 조회 메소드
     
     - parameter parameter: 에러가 날 수 있으니 꼭 .userLoad(id)를 넣어야 합니다.
     - Returns: 문자열 형식의 유저의 로그인 방법, 알 수 없다면 none
     */
    func getUserLoginMethod(parameter: DataParam) async -> String {
        do {
            let result = try await UserStore.shared.getUserLoginMethod(parameter: parameter)
            
            return result
        } catch {
            print("Error: \(error)")
        }
        
        return "none"
    }
    
    /**
     로그아웃 후 유저 정보를 초기화 하는 메소드
     */
    func setLogout() {
        UserStore.shared.setLogout()
    }
    
    /**
     데이터를 가져오는 메소드
     
     - parameters:
        - type: 가져올 대상, 예) 유저라면 .user
        - parameter: 가져올 대상의 정보, 뒤에 Load가 붙은 값들을 쓰거나 특정 대상에 한해 All이 붙은 값을 쓸 수 있습니다. 예) 유저라면 .userLoad(id)
     - Returns: 가져온 데이터, 만약 가져온 데이터를 Store 자체에서 저장한다면 반환값은 none이고, 데이터를 가져올 수 없다면 error가 반환됩니다.
     */
    func fetchData(type: DataType, parameter: DataParam, fetchFlowChangeAction: (DataFetchFlow) -> Void) async -> DataResult {
        do {
            var dataFetchFlow: DataFetchFlow = .loading
            fetchFlowChangeAction(dataFetchFlow)
            
            let result = try await dataStores[type.rawValue].fetchData(parameter: parameter)
            
            dataFetchFlow = .didLoad
            fetchFlowChangeAction(dataFetchFlow)
            
            return result
        } catch {
            print("Error: \(error)")
        }
        
        return DataResult.error(reason: "Can't fetch data")
    }
    
    /**
     데이터를 업데이트 하거나 새로 추가하는 메소드
     
     - parameters:
        - type: 업데이트 할 대상, 예) 유저라면 .user
        - parameter: 업데이트 할 대상의 정보, 뒤에 Update가 붙은 값들을 써야합니다. 예) 유저라면 .userUpdate(id, user)
     */
    func updateData(type: DataType, parameter: DataParam) async {
        do {
            try await dataStores[type.rawValue].updateData(parameter: parameter)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func deleteData() {
        
    }
}
