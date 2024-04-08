//
//  LocationListView.swift
//  SwiftUIMap
//
//  Created by Daniil Kulikovskiy on 4/8/24.
//

import SwiftUI

struct LocationListView: View {
    @EnvironmentObject private var vm: LocationViewModel
    var body: some View {
        List(vm.location) { location in
            Button {
                vm.snowNextLocation(location: location)
            } label: {
                listRowView(location: location)
            }
            .padding(.vertical, 4)
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
    }
}

#Preview {
    LocationListView()
        .environmentObject(LocationViewModel())
}

extension LocationListView {
    private func listRowView(location: Location) -> some View {
        HStack {
            if let imageName = location.imageNames.first {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .cornerRadius(10)
            }
            VStack(alignment:  .leading) {
                Text(location.name)
                    .font(.headline)
                Text(location.cityName)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
