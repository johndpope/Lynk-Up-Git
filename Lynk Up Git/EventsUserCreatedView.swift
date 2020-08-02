//
//  EventsUserCreatedView.swift
//  
//
//  Created by Thomas D'Alessandro on 7/17/20.
//
import Foundation
import SwiftUI

struct EventsUserCreatedView: View {
    
    
    @Binding var token: String
    @State private var pressedEvent: Bool = false
    @State private var selectedEvent: Int = 0
    @State private var atendees: [atendeedata] = []
    @State private var profileList: [profiledata] = []
    
    
    var data: DataFetcher
    
    
    var body: some View {
        ZStack{
            NavigationView {
                List{
                    ForEach(self.data.createdEvents){ row in
                        HStack {
                            Button("\((row.poi)!)") {
                                print("Display event information")
                                
                                self.selectedEvent = row.id
                                
                                self.pressedEvent = true
                                
                            }
                            .foregroundColor(Color.purple)
                            Spacer()
                            Button("Delete") {
                                
                                for event in self.data.createdEvents{
                                    if row.id == event.id{
                                        DispatchQueue.main.async {
                                            self.data.deleteEvent(id: event.id)
                                        }
                                    }
                                }
                                print("Deletes the event in this row")
                            }.buttonStyle(BorderlessButtonStyle())
                                .padding(4)
                                .background(Color.red)
                                .cornerRadius(5)
                                .foregroundColor(Color.white)
                        }
                    }
                    
                }
                
                //if you hit more buttons than there is room for, it'll be scrollable. make some kind of for loop that iterates over events a user is going to and displays it
                
            }.navigationBarTitle("My Events")
                .navigationViewStyle(StackNavigationViewStyle())
            
            if pressedEvent{
                Group{
                    if self.data.profilesLoaded == true{
                        NavigationView {
                            List{
                                ForEach(self.data.profileList){ row in
                                    HStack {
                                        Text("\(row.name)")
                                            .foregroundColor(Color.purple)
                                        Spacer()
                                    }
                                }
                                
                            }
                            
                            //if you hit more buttons than there is room for, it'll be scrollable. make some kind of for loop that iterates over events a user is going to and displays it
                            
                        }
                    }else{
                        Spacer()
                        Text("Loading Attendees")
                        Spacer()
                    }
                }.onAppear{
                    //this can't be done on appear as it won't update when a different
                    self.data.profileList = []
                    self.data.atendees = []
                    DispatchQueue.main.async{
                        
                        self.data.fetchAtendees(id: self.selectedEvent)
                        
                        if self.data.profilesLoaded{
                            self.profileList = self.data.profileList
                            self.atendees = self.data.atendees
                        }
                    }
                }
                .navigationBarTitle("My Attendees")
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
}

