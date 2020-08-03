//
//  MyEventsButton.swift
//  Meep
//
//  Created by Katia K Brinsmade on 7/12/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//import Foundation
import Foundation
import SwiftUI
import Mapbox


struct MyEventsButton: View {
    @Binding var isPresentedMyEvents: Bool
    @Binding var token: String
    var data: DataFetcher
    
    var body: some View {
        //UNCOMMENT THIS STUFF BELOW TO MAKE AN EVENT CREATION BUTTON IN THE SHEET INSTEAD OF JUST DIRECTING TO A SHEET WITH THE EVENT CREATION DETAILS
        Button(action: {
            self.isPresentedMyEvents.toggle() //trigger modal presentation
        }, label: {
            Text("My Events")
            .font(.system(size: 18))
            .foregroundColor(Color.white)
            .shadow(radius: 8)
        }).padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
        .background(Color.purple)
        .cornerRadius(10)
            .sheet(isPresented: $isPresentedMyEvents, content:{
                VStack{
                    NavigationView {
                        NavigationLink(destination: EventsUserAttendingView(token: self.$token, data: self.data)) {
                            Text("Events I'm Attending")
                                .padding(.leading, 15)
                            Spacer()
                        }
                        .onAppear{
                            self.data.userAttendingEvents()
//                            self.data.userAttendingEvents()
//                            self.data.eventNames = []
//                            for events in self.data.events{
//                                for event in self.data.IAmAtending{
//                                    if events.id == event.event_id{
//                                        self.data.eventNames.append(events)
//                                    }
//                                }
//                            }
                        }
                    }
                    NavigationView {
                        NavigationLink(destination: EventsUserCreatedView(token: self.$token, data: self.data)) {
                            Text("Events I've Created")
                                .padding(.leading, 15)
                            Spacer()
                        }
                    }.onAppear{
                        self.data.userCreatedEvents()
//                        for row in self.data.createdEvents{
//                            self.data.fetchAtendees(id: row.id){ array in
//                                DispatchQueue.main.async {
//                                    self.data.atendees = array
//                                }
//                            }
//
//                        }
                    }
                }
            } )
        
    }
}


