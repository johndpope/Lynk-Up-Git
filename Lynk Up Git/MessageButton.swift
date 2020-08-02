//
//  MessageButton.swift
//  Meep
//
//  Created by Katia K Brinsmade on 4/23/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//

import SwiftUI
import Mapbox

struct MessageButton: View {
    @State private var isPresentedMessage = false
    @State private var bodyOfMail: String = ""
    @State private var feedbackSubmitted: Bool = false
    var mapStyle: URL
    
    var body: some View {
        VStack {
            if self.mapStyle == MGLStyle.darkStyleURL {
                
                Button(action: {
                    self.isPresentedMessage.toggle() //trigger modal presentation
                    self.feedbackSubmitted = false
                    self.bodyOfMail = ""
                }, label: {
                    Image(systemName: "message")
                        .font(.system(size: 30))
                        .foregroundColor(Color.init(red: 120/255, green: 200/255, blue: 255/255))
                        .shadow(radius: 8)
                }).padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color.init(red: 7/255, green: 7/255, blue: 7/255))
                    .cornerRadius(50.0)
                    .sheet(isPresented: $isPresentedMessage, content:{
                        VStack{
                            TextField("What could we do to improve your in-app experience?", text: self.$bodyOfMail, onCommit: {
                                if self.$bodyOfMail.wrappedValue.count >= 1 {
                                    MailSender.shared.sendEmail(subject: "LynkUp Feedback", body: "\(self.$bodyOfMail.wrappedValue)")
                                    print("mail content should be \(self.$bodyOfMail.wrappedValue)")
                                    self.feedbackSubmitted = true
                                }
                            })//.frame(width: 300, height: UIScreen.main.bounds.height * 0.5)
                                .background(Color.red)
                            
                            Button("Submit") {
                                if self.$bodyOfMail.wrappedValue.count >= 1 {
                                    MailSender.shared.sendEmail(subject: "LynkUp Feedback", body: "\(self.$bodyOfMail.wrappedValue)")
                                    print("mail content should be \(self.$bodyOfMail.wrappedValue)")
                                    self.feedbackSubmitted = true
                                }
                            }
                            if self.feedbackSubmitted == true {
                                Text("Your feedback has been submitted. If you have more ideas, please let us know so we can make the experience better for you.")
                                .fixedSize(horizontal: false, vertical: true)
                                .padding()
                            }
                        }
                    } )
            } else {
                Button(action: {
                    self.isPresentedMessage.toggle() //trigger modal presentation
                    self.feedbackSubmitted = false
                    self.bodyOfMail = ""
                }, label: {
                    Image(systemName: "message")
                        .font(.system(size: 30))
                        .foregroundColor(Color(.systemBlue))
                        .shadow(radius: 8)
                }).padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(50.0)
                    .sheet(isPresented: $isPresentedMessage, content:{
                        VStack{
                            TextField("What could we do to improve your in-app experience?", text: self.$bodyOfMail, onCommit: {
                                if self.$bodyOfMail.wrappedValue.count >= 1 {
                                    MailSender.shared.sendEmail(subject: "LynkUp Feedback", body: "\(self.$bodyOfMail.wrappedValue)")
                                    print("mail content should be \(self.$bodyOfMail.wrappedValue)")
                                    self.feedbackSubmitted = true
                                }
                            })
                                .fixedSize(horizontal: false, vertical: true)
                                //.frame(width: 300, height: UIScreen.main.bounds.height * 0.5)
                            .background(Color.red)
                            Button("Submit") {
                                if self.$bodyOfMail.wrappedValue.count >= 1 {
                                    MailSender.shared.sendEmail(subject: "LynkUp Feedback", body: "\(self.$bodyOfMail.wrappedValue)")
                                    print("mail content should be \(self.$bodyOfMail.wrappedValue)")
                                    self.feedbackSubmitted = true
                                }
                            }
                            if self.feedbackSubmitted == true {
                                Text("Your feedback has been submitted. If you have more ideas, please let us know so we can make the experience better for you.")
                                .fixedSize(horizontal: false, vertical: true)
                                .padding()
                            }
                        }
                    } )
            }
        }
    }
}

