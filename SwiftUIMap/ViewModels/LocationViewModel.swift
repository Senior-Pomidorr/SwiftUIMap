//
//  LocationViewModel.swift
//  SwiftUIMap
//
//  Created by Daniil Kulikovskiy on 4/6/24.
//

import Foundation
import MapKit
import SwiftUI

class LocationViewModel: ObservableObject {
    
    // All loaded loacations
    @Published var location: [Location]
    
    // Current location on map
    @Published var mapLocation: Location {
        didSet {
            updateMapRegion(location: mapLocation)
        }
    }
    
    // Current region on map
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1,
                                   longitudeDelta: 0.1)
    
    // Show list of locations
    @Published var showLocationList: Bool = false
    
    init() {
        let location = LocationsDataService.locations
        self.location = location
        self.mapLocation = location.first!
        self.updateMapRegion(location: location.first!)
    }
    
    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: location.coordinates,
                span: mapSpan
            )
        }
    }
    
    func toolgleLocationList() {
        withAnimation(.easeInOut) {
            showLocationList.toggle()
        }
    }
    
    func snowNextLocation(location: Location) {
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocationList = false
        }
    }
}
