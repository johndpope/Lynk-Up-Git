//
//  CreateEventButton.swift
//  Meep
//
//  Created by Katia K Brinsmade on 4/25/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//

import Foundation
import SwiftUI
import Mapbox


struct CreateEventButton: View {
    @EnvironmentObject var request: DataFetcher
    var annotation: AnnotationsVM
    @State private var isPresentedEvent = false
    @State private var eventName: String = ""
    @State private var eventDescription: String = ""
    @State private var selectedStartTime = Date()
    @State private var selectedEndTime = Date()
    @State private var startTimeStamp: String = ""
    @State private var endTimeStamp: String = ""
    @Binding var annotationSelected: Bool
    @Binding var token: String
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
   

    
    func send(_ sender: Any) {
            
            let ISOFormat = ISO8601DateFormatter()
            
            
            self.startTimeStamp = "\(ISOFormat.string(from: self.selectedStartTime))"
            self.endTimeStamp = "\(ISOFormat.string(from: self.selectedEndTime))"
            print(self.endTimeStamp)
            
            //self.startTimeStamp.removeLast(5)
           // self.endTimeStamp.removeLast(5)

            let parameters: [String: String] = ["poi": self.eventName, "address": self.eventDescription, "start_time": self.startTimeStamp, "end_time": self.endTimeStamp]
            
            //let session = URLSession.shared
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://ec2-3-128-24-132.us-east-2.compute.amazonaws.com/api/feed")! as URL)
            request.httpMethod = "POST"
            print(self.token)
            request.addValue("Token \(self.token)", forHTTPHeaderField: "Authorization")
            //request.setValue("Token c495184ff393bbf10ea914be4617775bb77956c6", forHTTPHeaderField: "Authorization")
        
            //let postString = "b=\(self.eventName)&c=\(self.eventDescription)&d=\(self.startTimeStamp)&e=\(self.endTimeStamp)"
            
                //request.httpBody = postString.data(using: String.Encoding.utf8)
                
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
                print(request.httpBody)
               } catch let error {
                   print(error)
               }
                
        
               request.addValue("application/json", forHTTPHeaderField: "Content-Type")
               request.addValue("application/json", forHTTPHeaderField: "Accept")

                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    
                      guard error == nil else {
                              return
                          }

                          guard let data = data else {
                              return
                          }

                          do {
                              //create json object from data
                              if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                                  print(json)
                                  // handle json...
                              }

                          } catch let error {
                              print(error)
                          }
                }
                task.resume()
                
                self.eventName = ""
                self.eventDescription = ""
                self.selectedStartTime = Date()
                self.selectedEndTime = Date()

            }

        
        
        var body: some View {
            //UNCOMMENT THIS STUFF BELOW TO MAKE AN EVENT CREATION BUTTON IN THE SHEET INSTEAD OF JUST DIRECTING TO A SHEET WITH THE EVENT CREATION DETAILS
          Button(action: {
                self.isPresentedEvent.toggle() //trigger modal presentation
            }, label: {
                Text("Create Event")
                    .font(.system(size: 18))
                    .foregroundColor(Color(.darkGray))
                    .shadow(radius: 8)
                }).padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .sheet(isPresented: $isPresentedEvent, content:{
                VStack{
                    TextField("Event Name", text: self.$eventName).padding()
                    TextField("Event Address", text: self.$eventDescription).padding()
                    Form {
                        DatePicker("When your event starts: ", selection: self.$selectedStartTime, in: Date()...)
                    }
                    Form {
                        DatePicker("When your event ends:   ", selection: self.$selectedEndTime, in: Date()...)
                    }
                    HStack{
                    Button(action: {
                        self.isPresentedEvent.toggle()
                        self.annotationSelected = false
                        //print("yo yo \(self.request.events.last?.address)")
                        //DispatchQueue.main.async{
                          //  self.request.fetchEvents()
                            
                            //for events in self.request.events{
                              //  print("adding: \(events.address)")
                                //self.annotation.addNextAnnotation(address: events.address)
                           // }
                        //}
                        print(self.request.events.last?.poi)
                        for event in self.request.events{
                            self.annotation.addNextAnnotation(address: event.address)
                        }

                        self.send((Any).self)
                        }, label: {
                            Text("Create Event")
                        })
                    Button(action: {
                        self.isPresentedEvent.toggle()
                       }, label: {
                          
                             Text("Cancel")
                       })
                    }
                    Text("Create Event Button (Non Functional)").padding()
                }
            } )
         }
    }

