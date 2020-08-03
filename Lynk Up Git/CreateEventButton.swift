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
import MapboxGeocoder

struct CreateEventButton: View {
    @EnvironmentObject var request: DataFetcher
    @ObservedObject var VModel: ViewModel
    var annotation: AnnotationsVM
    @State private var isPresentedEvent = false
    @State private var eventName: String = ""
    @Binding var eventDescription: String
    @State private var selectedStartTime = Date()
    @State private var selectedEndTime = Date()
    @State private var startTimeStamp: String = ""
    @State private var endTimeStamp: String = ""
    @Binding var annotationSelected: Bool
    @Binding var token: String
    @Binding var showCreateEventResults: Bool
    var mapStyle: URL
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    var shortDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    init(VModel: ViewModel, annotation: AnnotationsVM, annotationSelected: Binding<Bool>, token: Binding<String>, eventDescription: Binding<String>, showCreateEventResults: Binding<Bool>, mapStyle: URL) {
        self.VModel = VModel
        self.annotation = annotation
        _annotationSelected = annotationSelected
        _token = token
        _eventDescription = eventDescription
        _showCreateEventResults = showCreateEventResults
        self.mapStyle = mapStyle
        UITableView.appearance().backgroundColor = .clear
        //UITableView.appearance().tintColor = .purple
        UITableViewCell.appearance().backgroundColor = .clear
        //UITableViewCell.appearance().tintColor = .purple
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
        let binding = Binding<String>(get: {
            self.eventDescription
        }, set: {
            self.eventDescription = $0
            self.VModel.findResults(address: self.eventDescription)
            if self.VModel.searchResults.count >= 0 {
                self.showCreateEventResults = true
                //               self.position = CardPosition.top(50)
            } else {
                self.showCreateEventResults = false
            }
            //               if self.eventDescription == "" {
            //                self.showCreateEventResults = false
            //                   //self.position = CardPosition.bottom(UIScreen.main.bounds.height - 77.5)
            //               }
        }
        )
        //UNCOMMENT THIS STUFF BELOW TO MAKE AN EVENT CREATION BUTTON IN THE SHEET INSTEAD OF JUST DIRECTING TO A SHEET WITH THE EVENT CREATION DETAILS
        return Button(action: {
            self.isPresentedEvent.toggle() //trigger modal presentation
            self.eventDescription = ""
            self.showCreateEventResults = false
        }, label: {
            Text("Create Event")
                .font(.system(size: 18))
                .foregroundColor(Color.white)
                .shadow(radius: 8)
        })
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .background(Color.purple)
            .cornerRadius(10)
            .sheet(isPresented: $isPresentedEvent, content:{
                
                if self.mapStyle == MGLStyle.darkStyleURL {
                    ScrollView {
                        ZStack {
                            VStack{
                                ZStack {
                                    HStack {
                                        if self.eventName.isEmpty {
                                            HStack {
                                                Text("Event Name")
                                                    .foregroundColor(Color.init(red: 0.5, green: 0.5, blue: 0.5))
                                                Spacer()
                                            }.padding(.vertical, 10)
                                                .padding(.horizontal, 15)
                                                .background(Color.black)
                                                .cornerRadius(10)
                                        }
                                        else {
                                            HStack {
                                                Spacer()
                                            }.padding(.vertical, 20)
                                                .padding(.horizontal, 15)
                                                .background(Color.black)
                                                .cornerRadius(10)
                                        }
                                    }.padding(.horizontal)
                                        .padding(.top, 20)
                                    HStack {
                                        TextField("", text: self.$eventName)
                                            .padding(.top, 10)
                                            .padding(.leading, 15)
                                            .padding(.bottom, 10)
                                            //.background(Color.black)
                                            .cornerRadius(10)
                                            .foregroundColor(Color.white)
                                    }.padding(.horizontal)
                                        .padding(.top, 20)
                                }
                                ZStack {
                                    HStack {
                                        if self.eventDescription.isEmpty {
                                            HStack {
                                                Text("Event Address")
                                                    .foregroundColor(Color.init(red: 0.5, green: 0.5, blue: 0.5))
                                                Spacer()
                                            }.padding(.vertical, 10)
                                                .padding(.horizontal, 15)
                                                .background(Color.black)
                                                .cornerRadius(10)
                                        }
                                        else {
                                            HStack {
                                                Spacer()
                                            }.padding(.vertical, 20)
                                                .padding(.horizontal, 15)
                                                .background(Color.black)
                                                .cornerRadius(10)
                                        }
                                    }.padding(.horizontal)
                                    HStack {
                                        TextField("Event Address", text: binding, onCommit: {
                                            if self.VModel.searchResults.first != nil {
                                                self.eventDescription = "\(self.rowText(result: self.VModel.searchResults.first!).label)"
                                            }
                                            self.showCreateEventResults = false
                                        })
                                            .padding(.top, 10)
                                            .padding(.leading, 15)
                                            .padding(.bottom, 10)
                                            //.background(Color.black)
                                            .cornerRadius(10)
                                            .foregroundColor(Color.white)
                                    }.padding(.horizontal)
                                }
                                
                                VStack {
                                    HStack {
                                        Text("Event Start Time:")
                                            .foregroundColor(Color.white)
                                        Text("\(self.shortDateFormatter.string(from: self.selectedStartTime))")
                                            .foregroundColor(Color.purple)
                                    }
                                    .padding(.horizontal)
                                    .padding(.top)
                                    DatePicker("", selection: self.$selectedStartTime, in: Date()...)
                                        .colorMultiply(Color.black)
                                        .colorInvert()
                                        .background(Color.black)
                                }
                                .background(Color.black)
                                .cornerRadius(15)
                                .padding(.horizontal)
                                VStack {
                                    HStack {
                                        Text("Event End Time:")
                                            .foregroundColor(Color.white)
                                        Text("\(self.shortDateFormatter.string(from: self.selectedEndTime))")
                                            .foregroundColor(Color.purple)
                                    }
                                    .padding(.horizontal)
                                    .padding(.top)
                                    DatePicker("", selection: self.$selectedEndTime, in: Date()...)
                                        .colorMultiply(Color.black)
                                        .colorInvert()
                                        .background(Color.black)
                                }
                                .background(Color.black)
                                .cornerRadius(15)
                                .padding(.horizontal)
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
                                            .accentColor(Color.green)
                                            .padding(.all, 10)
                                            .background(Color.black)
                                            .cornerRadius(10)
                                    })
                                    Button(action: {
                                        self.isPresentedEvent.toggle()
                                    }, label: {
                                        Text("Cancel")
                                            .accentColor(Color.red)
                                            .padding(.all, 10)
                                            .background(Color.black)
                                            .cornerRadius(10)
                                        
                                    })
                                }.padding(.bottom, 10)
                            }
                            VStack {
                                if self.$eventDescription.wrappedValue.count >= 1 && self.showCreateEventResults == true && self.mapStyle == MGLStyle.darkStyleURL {
                                    CreateEventSearchResults(VModel: self.VModel, annotation: self.annotation, showCreateEventResults: self.$showCreateEventResults, eventDescription: self.$eventDescription, mapStyle: MGLStyle.darkStyleURL)
                                }
                                else if self.$eventDescription.wrappedValue.count >= 1 && self.showCreateEventResults == true {
                                    CreateEventSearchResults(VModel: self.VModel, annotation: self.annotation, showCreateEventResults: self.$showCreateEventResults, eventDescription: self.$eventDescription, mapStyle: MGLStyle.outdoorsStyleURL)
                                }
                            }.padding(.bottom, 60)
                                .padding(.horizontal)
                        }.background(Color.init(red: 0.1, green: 0.1, blue: 0.1))
                    }
                } else {
                    ScrollView {
                        ZStack {
                            VStack{
                                HStack {
                                    TextField("Event Name", text: self.$eventName)
                                        .padding(.top, 10)
                                        .padding(.leading, 15)
                                        .padding(.bottom, 10)
                                        .background(Color.init(red: 0.9, green: 0.9, blue: 0.9))
                                        .cornerRadius(10)
                                }.padding(.horizontal)
                                    .padding(.top, 20)
                                HStack {
                                    TextField("Event Address", text: binding, onCommit: {
                                        if self.VModel.searchResults.first != nil {
                                            self.eventDescription = "\(self.rowText(result: self.VModel.searchResults.first!).label)"
                                            print("the results are:\(self.VModel.searchResults)")
                                        }
                                        self.showCreateEventResults = false
                                    })
                                        .padding(.top, 10)
                                        .padding(.leading, 15)
                                        .padding(.bottom, 10)
                                        .background(Color.init(red: 0.9, green: 0.9, blue: 0.9))
                                        .cornerRadius(10)
                                }.padding(.horizontal)
                                
                                VStack {
                                    HStack {
                                        Text("Event Start Time:")
                                        Text("\(self.shortDateFormatter.string(from: self.selectedStartTime))")
                                            .foregroundColor(Color.purple)
                                    }
                                    .padding(.horizontal)
                                    .padding(.top)
                                    DatePicker("", selection: self.$selectedStartTime, in: Date()...)
                                        .accentColor(Color.purple)
                                }
                                .background(Color.init(red: 0.9, green: 0.9, blue: 0.9))
                                .cornerRadius(15)
                                .padding(.horizontal)
                                VStack {
                                    HStack {
                                        Text("Event End Time:")
                                        Text("\(self.shortDateFormatter.string(from: self.selectedEndTime))")
                                            .foregroundColor(Color.purple)
                                    }
                                    .padding(.horizontal)
                                    .padding(.top)
                                    DatePicker("", selection: self.$selectedEndTime, in: Date()...)
                                        .accentColor(Color.purple)
                                }
                                .background(Color.init(red: 0.9, green: 0.9, blue: 0.9))
                                .cornerRadius(15)
                                .padding(.horizontal)
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
                                            .accentColor(Color.green)
                                            .padding(.all, 10)
                                            .background(Color.init(red: 0.9, green: 0.9, blue: 0.9))
                                            .cornerRadius(10)
                                    })
                                    Button(action: {
                                        self.isPresentedEvent.toggle()
                                    }, label: {
                                        Text("Cancel")
                                            .accentColor(Color.red)
                                            .padding(.all, 10)
                                            .background(Color.init(red: 0.9, green: 0.9, blue: 0.9))
                                            .cornerRadius(10)
                                    })
                                }.padding(.bottom, 10)
                            }
                            VStack {
                                if self.$eventDescription.wrappedValue.count >= 1 && self.showCreateEventResults == true && self.mapStyle == MGLStyle.darkStyleURL {
                                    CreateEventSearchResults(VModel: self.VModel, annotation: self.annotation, showCreateEventResults: self.$showCreateEventResults, eventDescription: self.$eventDescription, mapStyle: MGLStyle.darkStyleURL)
                                }
                                else if self.$eventDescription.wrappedValue.count >= 1 && self.showCreateEventResults == true {
                                    CreateEventSearchResults(VModel: self.VModel, annotation: self.annotation, showCreateEventResults: self.$showCreateEventResults, eventDescription: self.$eventDescription, mapStyle: MGLStyle.outdoorsStyleURL)
                                }
                            }.padding(.bottom, 60)
                                .padding(.horizontal)
                        }
                    }
                }
            }
                
        )
    }
    
    private func rowText(result: GeocodedPlacemark) -> (view: Text, label: String) {
        
        
        //        city is not nil
        //        state is not nil
        //        country is not nil
        if result.postalAddress != nil && result.postalAddress?.city != "" && result.postalAddress?.state != "" && result.postalAddress?.country != "" {
            
            return (Text("\(result.formattedName), \(result.postalAddress!.city), \(result.postalAddress!.state), \(result.postalAddress!.country)"), "\(result.formattedName), \(result.postalAddress!.city), \(result.postalAddress!.state), \(result.postalAddress!.country)")
        }
            
            
            
            //        city is not nil
            //        state is not nil
            //        country is nil
        else if result.postalAddress != nil && result.postalAddress?.city != "" && result.postalAddress?.state != "" && result.postalAddress?.country == "" {
            
            return (Text("\(result.formattedName), \(result.postalAddress!.city), \(result.postalAddress!.state)"), "\(result.formattedName), \(result.postalAddress!.city), \(result.postalAddress!.state)")
        }
            
            
            //        city is not nil
            //        state is nil
            //        country is nil
        else if result.postalAddress != nil && result.postalAddress?.city != "" && result.postalAddress?.state == "" && result.postalAddress?.country == "" {
            
            return (Text("\(result.formattedName), \(result.postalAddress!.city)"), "\(result.formattedName), \(result.postalAddress!.city)")
        }
            
            
            //        city is nil
            //        state is nil
            //        country is nil
        else if result.postalAddress != nil && result.postalAddress?.city == "" && result.postalAddress?.state == "" && result.postalAddress?.country == "" {
            
            return (Text("\(result.formattedName)"), "\(result.formattedName)")
        }
            
            
            
            //        city is not nil
            //        state is nil
            //        country is not nil
        else if result.postalAddress != nil && result.postalAddress?.city != "" && result.postalAddress?.state == "" && result.postalAddress?.country != "" {
            
            return (Text("\(result.formattedName), \(result.postalAddress!.city), \(result.postalAddress!.country)"), "\(result.formattedName), \(result.postalAddress!.city), \(result.postalAddress!.country)")
        }
            
            
            
            //        city is nil
            //        state is not nil
            //        country is nil
        else if result.postalAddress != nil && result.postalAddress?.city == "" && result.postalAddress?.state != "" && result.postalAddress?.country == "" {
            
            return (Text("\(result.formattedName), \(result.postalAddress!.state)"), "\(result.formattedName), \(result.postalAddress!.state)")
            
        }
            
            
            
            
            //        city is nil
            //        state is nil
            //        country is not nil
        else if result.postalAddress != nil && result.postalAddress?.city == "" && result.postalAddress?.state == "" && result.postalAddress?.country != "" {
            
            
            return (Text("\(result.formattedName), \(result.postalAddress!.country)"), "\(result.formattedName), \(result.postalAddress!.country)")
            
        }
            
            
            
            
            //        city is nil
            //        state is not nil
            //        country is not nil
        else if result.postalAddress != nil && result.postalAddress?.city == "" && result.postalAddress?.state != "" && result.postalAddress?.country != "" {
            
            return (Text("\(result.formattedName), \(result.postalAddress!.state), \(result.postalAddress!.country)"), "\(result.formattedName), \(result.postalAddress!.state), \(result.postalAddress!.country)")
            
        }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        else if result.postalAddress?.city != "" && result.postalAddress?.state != "" {
            
            return (Text("\(result.formattedName), \(result.postalAddress!.city), \(result.postalAddress!.state)"), "\(result.formattedName), \(result.postalAddress!.city), \(result.postalAddress!.state)")
        }
            
            
            
            
        else if result.postalAddress?.city != "" && result.postalAddress?.country != "" {
            
            return (Text("\(result.formattedName), \(result.postalAddress!.city), \(result.postalAddress!.country)"), "\(result.formattedName), \(result.postalAddress!.city), \(result.postalAddress!.country)")
        }
            
            
            
            
        else if result.postalAddress?.state != "" && result.postalAddress?.country != "" {
            
            return (Text("\(result.formattedName), \(result.postalAddress!.state), \(result.postalAddress!.country)"), "\(result.formattedName), \(result.postalAddress!.state), \(result.postalAddress!.country)")
        }
            
            
            
            
        else if result.postalAddress?.city != "" {
            
            return (Text("\(result.formattedName), \(result.postalAddress!.city)"), "\(result.formattedName), \(result.postalAddress!.city)")
        }
            
            
            
            
        else if result.postalAddress?.state != "" {
            
            return (Text("\(result.formattedName), \(result.postalAddress!.state)"), "\(result.formattedName), \(result.postalAddress!.state)")
        }
            
            
            
            
        else if result.postalAddress?.country != "" {
            
            return (Text("\(result.formattedName), \(result.postalAddress!.country)"), "\(result.formattedName), \(result.postalAddress!.country)")
        }
            
            
            
            
        else {
            return (Text("\(result.formattedName)"), "\(result.formattedName)")
        }
    }
}

