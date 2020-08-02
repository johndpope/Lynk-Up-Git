//
//  SignUpView.swift
//  meep0.2
//
//  Created by Thomas D'Alessandro on 6/4/20.
//  Copyright © 2020 Thomas D'Alessandro. All rights reserved.
//
import SwiftUI

struct SignUpView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    @State var password2: String = ""
    @State var email: String = ""
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var token: String
    
    
    func send(_ sender: Any) {
    
        
 let parameters: [String: String] = ["email": self.email, "name": self.username, "password": self.password/*, "password2": self.password2*/]
        
    let request = NSMutableURLRequest(url: NSURL(string: "http://ec2-3-128-24-132.us-east-2.compute.amazonaws.com/api/profile")! as URL)
        request.httpMethod = "POST"
    
//    self.username = "\(self.username)"
//    self.password = "\(self.password)"
//    self.email = "\(self.email)"
    
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

                        let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                              responseString as! String
                              self.token = String(describing: responseString)
                     } catch let error {
                         print(error)
                     }
           }
           task.resume()
       

    }

    
    var body: some View {
        VStack{
            Spacer()
            WelcomeText()
            UserImage()
            TextField("Email", text: $email)
            .autocapitalization(.none)
            .padding()
            .background(Color(.lightGray))
            .cornerRadius(5.0)
            .padding(.bottom, 10)
            TextField("Username", text: $username)
                .autocapitalization(.none)
                .padding()
                .background(Color(.lightGray))
                .cornerRadius(5.0)
                .padding(.bottom, 10)
            SecureField("Password", text: $password)
                .autocapitalization(.none)
                .padding()
                .background(Color(.lightGray))
                .cornerRadius(5.0)
                .padding(.bottom, 10)
            
/*
            SecureField("Verify Password", text: $password2)
                           .padding()
                           .background(Color(.lightGray))
                           .cornerRadius(5.0)
                           .padding(.bottom, 20)
 */
            Button(action: {
                self.send((Any).self)
                
                self.didLogin = true
                self.needsAccount = false
            },
                label: {Text("Submit")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 220, height: 60)
                .background(Color.orange)
                .cornerRadius(15.0)})
                .shadow(radius: 5)
                .padding(.bottom, 10)
            
            Button(action: {
                self.needsAccount = false
            }, label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back to Login")
                }
            })
            Spacer()
        }.padding().background(Color.white).edgesIgnoringSafeArea(.all)
    }
}
