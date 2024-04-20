//
//  LocationDetailView.swift
//  SwiftUIMap
//
//  Created by Daniil Kulikovskiy on 4/19/24.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    @EnvironmentObject private var vm: LocationViewModel
    let location: Location
    
    var body: some View {
        ScrollView {
            imageSection
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            VStack(alignment: .leading, spacing: 16, content: {
                titleSection
                Divider()
                descriptionSection
                Divider()
                mapLayer
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(backButton, alignment: .topLeading)
    }
}

#Preview {
    LocationDetailView(location: LocationsDataService.locations.first!)
        .environmentObject(LocationViewModel())
}


extension LocationDetailView {
    private var imageSection: some View {
        TabView {
            ForEach(location.imageNames, id: \.self) { imageName in
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? nil : UIScreen.main.bounds.width)
                    .clipped()
            }
        }
        .frame(height: 500)
        .tabViewStyle(.page)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(location.cityName)
                .font(.title)
                .foregroundStyle(.secondary)
        })
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            Text(location.description)
                .font(.headline)
                .foregroundStyle(.secondary)
            
            if let url = URL(string: location.link) {
                Link("Read more on Wikipedia", destination: url)
                    .font(.headline)
                    .tint(.blue)
            }
        })
    }
    
    private var mapLayer: some View {
        Map(coordinateRegion: .constant(
            MKCoordinateRegion(
                center: location.coordinates,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.1,
                    longitudeDelta: 0.1
                )
            )
        ),
            annotationItems: [location],
            annotationContent: {
            location in
            MapAnnotation(
                coordinate: location.coordinates
            ) {
                LocationMapAnnotationView()
                    .shadow(
                        radius: 10
                    )
            }
        })
        .allowsHitTesting(false)
        .aspectRatio(1, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
        .clipShape(.rect(cornerRadius: 30))
    }
    
    private var backButton: some View {
        Button {
            vm.showLocationDetailSheet = nil
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .tint(.black)
                .padding(16)
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(radius: 4)
                .padding()
        }
    }
}
