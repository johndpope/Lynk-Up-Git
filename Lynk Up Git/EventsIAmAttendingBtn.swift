//
//  EventsIAmAttendingBtn.swift
//  Meep
//
//  Created by Thomas D'Alessandro on 7/17/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//

import Foundation
import SwiftUI
import Mapbox


struct EventsIAmAttendingBtn: View {
    @Binding var isPresentedAttending: Bool
    @Binding var token: String
    var data: DataFetcher
    
    var body: some View {
                    //UNCOMMENT THIS STUFF BELOW TO MAKE AN EVENT CREATION BUTTON IN THE SHEET INSTEAD OF JUST DIRECTING TO A SHEET WITH THE EVENT CREATION DETAILS
            Button(action: {
                self.isPresentedAttending.toggle() //trigger modal presentation
            }, label: {
                Text("My Events")
            }).padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(50.0)
                .sheet(isPresented: $isPresentedAttending, content:{
                    VStack{
                        NavigationView {
                            NavigationLink(destination: EventsUserAttendingView(token: self.$token, data: self.data)) {
                            Text("Events I'm Attending")
                                .padding(.leading, 15)
                            Spacer()
                        }
                        }
                    }
                } )
        
    }
}
