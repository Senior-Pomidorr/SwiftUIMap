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
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $vm.mapRegion)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    LocationView()
        .environmentObject(LocationViewModel())
}
