//
//  LocationView.swift
//  SwiftUIMap
//
//  Created by Daniil Kulikovskiy on 4/6/24.
//

import SwiftUI
import MapKit

struct LocationView: View {
    @EnvironmentObject private var vm: LocationViewModel
    private var maxWidgthIpad: CGFloat = 700
    
    var body: some View {
        ZStack {
            mapLayer
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                    .padding()
                    .frame(maxWidth: maxWidgthIpad)
                Spacer()
                
                locationPreviewStack
            }
        }
        .sheet(item: $vm.showLocationDetailSheet, onDismiss: nil) { location in
            LocationDetailView(location: location)
        }
    }
}

#Preview {
    LocationView()
        .environmentObject(LocationViewModel())
}

extension LocationView {
    private var header: some View {
        VStack {
            Button(action: vm.toolgleLocationList) {
                Text(vm.mapLocation.name + ", " + vm.mapLocation.cityName)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(.foreground)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: vm.mapLocation)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundStyle(.black)
                            .padding()
                            .rotationEffect(.degrees(vm.showLocationList ? 180 : 0))
                    }
            }
            if vm.showLocationList {
                LocationListView()
            }
        }
        .background(.regularMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
    
    private var mapLayer: some View {
        Map(
            coordinateRegion: $vm.mapRegion,
            annotationItems: vm.location,
            annotationContent: { location in
                MapAnnotation(coordinate: location.coordinates) {
                    LocationMapAnnotationView()
                        .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
                        .shadow(radius: 10)
                        .onTapGesture {
                            vm.snowNextLocation(location: location)
                        }
                }
            })
        .ignoresSafeArea()
    }
    
    private var locationPreviewStack: some View {
        ZStack {
            ForEach(vm.location) { location in
                if vm.mapLocation == location {
                    LocationPreviewView(location: location)
                        .shadow(color: Color.black.opacity(0.3), radius: 20)
                        .padding()
                        .frame(maxWidth: maxWidgthIpad)
                        .frame(maxWidth: .infinity)
                        .transition(
                            .asymmetric(
                                insertion: .move(
                                    edge: .trailing
                                ),
                                removal: .move(
                                    edge: .leading
                                )
                            )
                        )
                }
            }
        }
    }
}
