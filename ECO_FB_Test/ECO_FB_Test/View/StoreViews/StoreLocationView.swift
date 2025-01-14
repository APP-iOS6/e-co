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
    @State var mapCameraPosition: MapCameraPosition = .camera(.init(centerCoordinate: LocationManager.shared.coordinate ?? CLLocationCoordinate2D(latitude: 37.5642135, longitude: 127.0016985), distance: 0))
    var coordinate = LocationManager.shared.coordinate
    var shopList = ZeroWasteShopStore.shared.zeroWasteShopList
    
    var body: some View {
        GeometryReader { GeometryProxy in
            VStack {
                VStack {
                    HStack {
                        Text("내 주변 친환경 매장")
                            .font(.system(size: 20, weight: .semibold))
                        Spacer()
                    }
                    .padding(.vertical)
       
                    Map(position: $mapCameraPosition) {
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
                .frame(width: GeometryProxy.size.width, height: GeometryProxy.size.height/3*2)
                
                List(shopList) { shop in
                    Button {
                        mapCameraPosition = .camera(.init(centerCoordinate: shop.position, distance: 0))
                    } label: {
                        HStack {
                            Text(shop.name)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .frame(width: max(0, GeometryProxy.size.width / 2 - 10), alignment: .leading)
                                
                            VStack(alignment: .leading){
                                Text(shop.phoneNumber)
                            }
                            
                            Spacer()
                            Image(systemName: "chevron.right")
                                .padding(.trailing)
                        }
                    }
                }
                .frame(width: GeometryProxy.size.width, height: GeometryProxy.size.height/5*4)
                .listStyle(.plain)
            }
        }
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
        if let _ = locations.last {
            manager.stopUpdatingLocation()
//            print(location.coordinate)
        }
    }
}

#Preview {
    StoreLocationView()
}
