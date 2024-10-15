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
    
    var body: some View {
        VStack {
            HStack {
                Text("내 주변 친환경 스토어")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            
            Map {
                // TODO: 파이어베이스에 스토어별 위도 경도 위치 정보 가져와서 주변 스토어들 핀 찍기
                if let coordinate = coordinate {
                    Marker(coordinate: coordinate) {
                        // 스토어 별로 핀 찍으려고 한거에여
                        Text("내 위치")
                    }
                }
            }
        }
        .padding()
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
            print(location.coordinate)
        }
    }
}

#Preview {
    StoreLocationView()
}
