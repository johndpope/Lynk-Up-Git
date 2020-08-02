//
//  PrivacyPolicyView.swift
//  Meep
//
//  Created by Katia K Brinsmade on 6/3/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        NavigationView {
            Text("this is a third view")
        }.navigationBarTitle("Privacy Policy")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView()
    }
}
