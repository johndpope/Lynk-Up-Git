//
//  EventsUserAttendingView.swift
//  Meep
//
//  Created by Katia K Brinsmade on 7/12/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//

import Foundation
import SwiftUI

struct EventsUserAttendingView: View {
    
    @Binding var token: String
    @State private var pressedEvent: Bool = false
    @State private var selectedEvent: Int = 0
    var data: DataFetcher
    
    
    var body: some View {
        ZStack{
            Group{
                if self.data.attendeesLoaded{
                    NavigationView {
                        List{
                            ForEach(self.data.eventNames){ row in
                                HStack {
                                    Button("\((row.poi)!)") {
                                        print("Display event information")
                                        
                                        self.selectedEvent = row.id
                                        self.pressedEvent = true
                                        
                                    }
                                    .foregroundColor(Color.purple)
                                    
                                    Spacer()
                                    Button("Leave") {
                                        
                                        for event in self.data.eventNames{
                                            if row.id == event.id{
                                                DispatchQueue.main.async {
                                                    self.data.removeFromEvent(id: event.id)
                                                }
                                            }
                                        }
                                        print("Left the Event")
                                    }.buttonStyle(BorderlessButtonStyle())
                                        .padding(4)
                                        .background(Color.red)
                                        .cornerRadius(5)
                                        .foregroundColor(Color.white)
                                    
                                }
                            }
                            
                        }

                    }.navigationBarTitle("Events I'm Going To")
                        .navigationViewStyle(StackNavigationViewStyle())
                }else{
                    Spacer()
                    Text("Loading Events")
                    Spacer()
                }
            }.onAppear{
                
               
            }
            if pressedEvent == true{
                NavigationView {
                    List{
                        ForEach(self.data.eventNames){ row in
                            HStack {
                                Text("\(row.poi!)")
                                .foregroundColor(Color.purple)
                                Spacer()
                            }
                        }
                        
                    }
                    
                    //if you hit more buttons than there is room for, it'll be scrollable. make some kind of for loop that iterates over events a user is going to and displays it
                    
                }.navigationBarTitle("My Attendees")
                    .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
}
