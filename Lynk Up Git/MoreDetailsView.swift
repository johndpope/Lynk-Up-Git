//
//  MoreDetailsView.swift
//  Meep
//
//  Created by Katia K Brinsmade on 5/26/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//

import SwiftUI
import Mapbox

struct MoreDetailsView: View {
    
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var searchedText: String
    @Binding var showMoreDetails: Bool
    @Binding var selectedAnnotation: MGLAnnotation?
    @Binding var token: String
    @State var event_id_int: Int = 0
    @State private var event_id: String = ""
    
    var data: DataFetcher
    
    var addurl = "http://ec2-3-128-24-132.us-east-2.compute.amazonaws.com/api/events"
    
    func addToEvent(_ sender: Any){
        
       let parameters: [String: String] = ["event_id": self.event_id]
                
            let request = NSMutableURLRequest(url: NSURL(string: addurl)! as URL)
                request.httpMethod = "POST"
                print(self.token)
                request.addValue("Token \(self.token)", forHTTPHeaderField: "Authorization")
        
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
               

            }
    
    
    var body: some View {
        ZStack {
            VStack {
                
                
                
                HStack {
                    VStack (alignment: .leading) {
                        Text("\((selectedAnnotation?.title ?? "Searched Location Not Found")!)").font(.system(size: 20))
                            //the text above will be the reverse geocoded text for the selected annotation
                            .padding(.leading, 0)
                        
                        Spacer()
                    }.frame(height: 5)
                        .padding(.leading, 12)
                        .padding(.top, 7)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    VStack {
                        Button("X") {
                            self.showMoreDetails = false
                        }
                        
                        Spacer()
                        
                    }.frame(width: 10, height: 5)
                        .padding(.top, 7)
                        .padding()
                        .foregroundColor(.white)
                }.background(Color.orange)
                
                VStack (alignment: .leading) {
                    Text("The event details shall be listed here. This event is going to be at this time, in this place, this is just placeholder text to see what it looks like, here we go, blah blah blah, me and tj are working on this project right now.")
                        .padding(.leading, 12)
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                        .padding(.trailing, 5)
                }.frame(width: textWidth())
                
                VStack {
                    Button("Join Event") {
                        //Call the function again to add the annotation
                        
                        self.showMoreDetails = false
                        DispatchQueue.main.async {
                            for event in self.data.events{
                                if self.selectedAnnotation?.title == event.address{
                                    DispatchQueue.main.async {
                                        self.event_id_int = event.id
                                        self.event_id = "\(self.event_id_int)"
                                        self.addToEvent((Any).self)
                                    }
                                }
                            }
                        }
                        
                        
                        print("We just joined the event \(self.searchedText)")
                    }.padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 5)
                        .padding(.trailing, 5)
                        .background(Color.blue)
                        .foregroundColor(.white)
                }.cornerRadius(5)
                    .padding(.bottom, 10)
                
            }
        }.frame(width: textWidth())
            .background(Color.white)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 3))
    }
    
    func textWidth() -> CGFloat? {
        return UIScreen.main.bounds.width / 1.2
    }
    
}
