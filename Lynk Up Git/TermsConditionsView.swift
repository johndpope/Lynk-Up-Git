//
//  TermsConditionsView.swift
//  Meep
//
//  Created by Katia K Brinsmade on 6/3/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//

import SwiftUI

struct TermsConditionsView: View {
    var body: some View {
        NavigationView {
            Text("this is also a view")
        }.navigationBarTitle("Terms and Conditions")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TermsConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsConditionsView()
    }
}
