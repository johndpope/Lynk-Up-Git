//
//  LogInView.swift
//  Meep
//
//  Created by Thomas D'Alessandro on 7/4/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//

//
//  LogInView.swift
//  Meep
//
//  Created by Thomas D'Alessandro on 7/4/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//

import SwiftUI

struct LogInView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    @State var email: String = "test@gmail.com"
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var token: String
    @State var errorString: String = ""
    //@State var tokenDict: [String:String]
    
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    //let apiUrl = "http://192.168.1.9:5000/login"
    
    
    let apiUrl = "http://ec2-3-128-24-132.us-east-2.compute.amazonaws.com/api/login"
    
    func send(_ sender: Any, completion: @escaping (String) -> Void) {
    
    let request = NSMutableURLRequest(url: NSURL(string: apiUrl)! as URL)
        request.httpMethod = "POST"
    
    self.username = "\(self.username)"
    self.password = "\(self.password)"
    self.email = "\(self.email)"
    
    //let postString = "username=\(self.username)&password=\(self.password)/*&c=\(self.email)"
    let postString = "username=\(self.username)&password=\(self.password)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        request.allHTTPHeaderFields = ["Authorization": "Token \(self.token)"]
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            
            if error != nil {
                print("error=\(String(describing: error))")
                //put variable that triggers error try again view here
                self.didLogin = false
                self.errorString = String(describing: error)
                completion(self.errorString)
                return
            }else{
                self.didLogin = true
                completion(String(describing: error))
            }
            
            print("response = \(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //responseString as! String
            print(responseString)
            self.token = (String(describing: responseString))
            //let dict = convertToDictionary(text: self.token)
            //self.token = self.token["token"]
            print("responseString = \(String(describing: responseString))")
            self.token.removeLast(3)
            self.token.removeFirst(19)
            UserDefaults.standard.set(self.token, forKey: "Token")
            print("users key: \((self.token))")
            
            if let httpResponse = response as? HTTPURLResponse {
                self.errorString = String(httpResponse.statusCode)
                
            }
            
            
        }
        task.resume()
       

    }

    
    var body: some View {
        VStack{
            Spacer()
            WelcomeText()
            UserImage()
            TextField("Email", text: $username)
                .autocapitalization(.none) //added this so the first letter of the text field isn't capitalized
                .padding()
                .background(Color(.lightGray))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            SecureField("Password", text: $password)
                .autocapitalization(.none) //added this so users dont fuck up the cases
                .padding()
                .background(Color(.lightGray))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            Button(action: {
                self.send((Any).self){ array in
                    self.errorString = array}
                    print(self.errorString)
                    
                    if self.errorString == "Success!"{
                        
                        self.didLogin = true
                    }
                    else{
                        self.didLogin = false
                    }
                
            },
                label: {Text("LOGIN")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 220, height: 60)
                .background(Color.orange)
                .cornerRadius(15.0)})
                .shadow(radius: 5)
                .padding(.bottom, 10)
            Button(action: {
                self.needsAccount = true
            }, label: {Text("Not a member yet? Sign up here")})
            Spacer()
        }.padding().background(Color.white).edgesIgnoringSafeArea(.all).animation(.interactiveSpring())
    }
}

//#if DEBUG
//struct LogInView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogInView(didLogin: .constant(false), needsAccount: .constant(false), token: )
//    }
//}
//#endif


struct WelcomeText: View {
    var body: some View {
        
            return Text("Welcome")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .shadow(radius: 1)
                .padding(.bottom, 20)
        
    }
}

struct UserImage: View {
    var body: some View {
            
            return Image("default-user")
                .resizable()
                .aspectRatio(UIImage(named: "default-user")!.size, contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipped()
                .cornerRadius(150)
                .shadow(radius: 5)
                .padding(.bottom, 75)
    }
}
