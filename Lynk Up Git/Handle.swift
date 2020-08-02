//
//  Handle.swift
//  Meep
//
//  Created by Katia K Brinsmade on 6/27/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//


import Foundation
import SwiftUI
import Mapbox
struct Handle : View {
    private let handleThickness = CGFloat(5.0)
    var mapStyle: URL
    var body: some View {
        VStack {
            if mapStyle == MGLStyle.darkStyleURL {
                RoundedRectangle(cornerRadius: handleThickness / 2.0)
                    .frame(width: 40, height: handleThickness)
                    .foregroundColor(Color.init(red: 70/255, green: 70/255, blue: 70/255))
                    .padding(5)
            } else {
                RoundedRectangle(cornerRadius: handleThickness / 2.0)
                    .frame(width: 40, height: handleThickness)
                    .foregroundColor(Color.init(red: 200/255, green: 200/255, blue: 200/255))
                    .padding(5)
            }
        }
    }
}
