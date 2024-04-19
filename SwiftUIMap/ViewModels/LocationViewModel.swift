//
//  LocationViewModel.swift
//  SwiftUIMap
//
//  Created by Daniil Kulikovskiy on 4/6/24.
//

import Foundation
import MapKit
import SwiftUI

@MainActor
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
    
    // Show location detail sheet
    @Published var showLocationDetailSheet: Location? = nil
    
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
        DispatchQueue.main.async { [self] in
            withAnimation(.easeInOut) {
                mapLocation = location
                showLocationList = false
            }
        }
    }
    
    func nextButtonPressed() {
        // Get current index
        guard let currentIndex = location.firstIndex(where: {$0 == mapLocation }) else {
            print("Could not find current index in location array.")
            return
        }
        
        // Check if the currentIndex is valid
        let nextIndex = currentIndex + 1
        guard location.indices.contains(nextIndex) else {
            // if next index is not valid
            // restart from 0
            guard let firstLocation = location.first else { return }
            snowNextLocation(location: firstLocation)
            return
        }
        
        // Next index is valid
        let nextLocation = location[nextIndex]
        snowNextLocation(location: nextLocation)
    }
}
