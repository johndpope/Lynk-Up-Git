//
//  LicensesView.swift
//  Meep
//
//  Created by Katia K Brinsmade on 6/3/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//

import SwiftUI

struct LicensesView: View {
    var body: some View {
        NavigationView {
            Text("this is a view")
        }.navigationBarTitle("Licenses")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LicensesView_Previews: PreviewProvider {
    static var previews: some View {
        LicensesView()
    }
}
