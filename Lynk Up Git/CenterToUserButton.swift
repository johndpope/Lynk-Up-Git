//
//  CenterToUserButton.swift
//  Meep
//
//  Created by Thomas D'Alessandro on 7/12/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//

import Foundation
import SwiftUI
import Mapbox


struct CenterToUserButton: View {
    @Binding var centerToUser: () -> ()
    @Binding var allowUserLocation: Bool
    @ObservedObject var locationManager: LocationManager
    var mapStyle: URL
    
    var body: some View {
        VStack {
        if self.mapStyle == MGLStyle.darkStyleURL {
            Button(action: {
                self.centerToUser()
            }, label: {
                ZStack {
                    Image(systemName:"dot.circle")
                }
                    .font(.system(size: 30))
                    .foregroundColor(Color(.lightGray))
                    .shadow(radius: 8)
            }).padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                //.foregroundColor(.secondary)
                .background(Color.init(red: 7/255, green: 7/255, blue: 7/255))
                .cornerRadius(50.0)
        } else {
            Button(action: {
                self.centerToUser()
            }, label: {
                Image(systemName:"dot.circle")
                    .font(.system(size: 30))
                    .foregroundColor(Color(.darkGray))
                    .shadow(radius: 8)
            }).padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color.white)
                .cornerRadius(50.0)
            }
        }
//        NavigationLink (destination: SettingsPageView(isPresentedSettings: $isPresentedSettings, allowUserLocation: self.$allowUserLocation, showToFriends: self.$showToFriends, rangeValue: self.$rangeValue, selectedMapStyle: self.$selectedMapStyle, locationManager: self.locationManager).transition(.move(edge: .leading)), isActive: self.$isPresentedSettings) {
//                    Button(action: {
//                        self.isPresentedSettings = true //trigger modal presentation
//                    }, label: {
//                        Image(systemName:"gear").font(.system(size: 30)).foregroundColor(Color(.darkGray)).shadow(radius: 8)
//                    }).padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
//                        .foregroundColor(.secondary)
//                        .background(Color(.secondarySystemBackground))
//                        .cornerRadius(50.0)
//                }
    }
}
