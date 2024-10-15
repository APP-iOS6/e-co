//
//  LocationManager.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/14/24.
//

import SwiftUI
import MapKit
import CoreLocation
import Observation

struct StoreLocationView: View {
    var coordinate = LocationManager.shared.coordinate
    var shopList = ZeroWasteShopStore.shared.zeroWasteShopList
    var body: some View {
        VStack {
            HStack {
                Text("내 주변 친환경 스토어")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            .padding(.vertical)
            
            Map {
                if let coordinate = coordinate {
                    Marker(coordinate: coordinate) {
                        Text("내 위치")
                    }
                }
                
                ForEach(shopList) { shop in
                    Marker(coordinate: shop.position) {
                        Text(shop.name)
                    }
                }
            }
        }
        .padding()
        
        List(shopList) { shop in
            HStack {
                Text(shop.name)
                    .bold()
                Spacer()
                Text(shop.phoneNumber)
            }
        }
        .listStyle(.plain)
    }
}

@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private let locationManager: CLLocationManager = CLLocationManager()

    var coordinate: CLLocationCoordinate2D? {
        locationManager.location?.coordinate
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /** 위치 정보가 업데이트 될 때 호출되는 delegate 함수 */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
//            print(location.coordinate)
        }
    }
}

#Preview {
    StoreLocationView()
}
