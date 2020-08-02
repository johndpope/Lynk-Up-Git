import SwiftUI
import Mapbox

struct SettingsPageView: View {
    @Binding var isPresentedSettings: Bool
    @Binding var allowUserLocation: Bool
    @Binding var showToFriends: Bool
    @Binding var rangeValue: Double
    @Binding var selectedMapStyle: Int
    @Binding var token: String
    var mapStyle: URL
    var mapStyles = ["System", "Light", "Dark"]
    @ObservedObject var locationManager: LocationManager
    
    init(isPresentedSettings: Binding<Bool>, allowUserLocation: Binding<Bool>, showToFriends: Binding<Bool>, rangeValue: Binding<Double>, selectedMapStyle: Binding<Int>, mapStyle: URL, locationManager: LocationManager, token: Binding<String>) {
        _isPresentedSettings = isPresentedSettings
        _allowUserLocation = allowUserLocation
        _showToFriends = showToFriends
        _rangeValue = rangeValue
        _selectedMapStyle = selectedMapStyle
        _token = token
        self.mapStyle = mapStyle
        self.locationManager = locationManager
        if self.mapStyle == MGLStyle.darkStyleURL {
            UINavigationBar.appearance().backgroundColor = UIColor.init(displayP3Red: 7/255, green: 7/255, blue: 7/255, alpha: 1)
            UISegmentedControl.appearance().backgroundColor = .black
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.selected)
            UISegmentedControl.appearance().selectedSegmentTintColor = .white
            UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        } else {
            UINavigationBar.appearance().backgroundColor = .white
            UISegmentedControl.appearance().backgroundColor = .white
            UISegmentedControl.appearance().selectedSegmentTintColor = .white
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.selected)
            UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.normal)
        }
    }
    
    
    var body: some View {
        VStack {
            if self.mapStyle == MGLStyle.darkStyleURL {
                NavigationView {
                    ScrollView {
                        VStack (alignment: .leading){
                            
                            Spacer()
                            
                            //Account Settings
                            VStack (alignment: .leading, spacing: 0){
                                Text("ACCOUNT")
                                    .padding(.bottom, 5)
                                    .padding(.leading, 10)
                                    .foregroundColor(.white)
                                VStack {
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    Text("Phone Number")
                                        .padding(.leading, 15)
                                        .foregroundColor(.white)
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    .padding(.horizontal, 15)
                                    Text("This will be email's row")
                                        .padding(.leading, 15)
                                        .foregroundColor(.white)
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }.frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                        .padding(.horizontal, 15)
                                    Button(
                                        action: {
                                            self.isPresentedSettings = false
                                            self.token = ""
                                            print("logged out: \(self.token)")
                                            UserDefaults.standard.set("", forKey: "Token")
                                    }, label: {
                                        Text("Logout")
                                    })
                                        .padding(.leading, 15)
                                        .foregroundColor(.white)
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                }.background(Color.black)
                            }.padding(.bottom, 15)
                            
                            //Map Settings
                            VStack (spacing: 0){
                                HStack {
                                    Text("MAP")
                                        .padding(.bottom, 5)
                                        .padding(.leading, 10)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                VStack (alignment: .leading, spacing: 0){
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    Text("Map Style")
                                        .padding(.top, 5)
                                        .padding(.leading, 15)
                                        .foregroundColor(.white)
                                    Picker(selection: $selectedMapStyle, label: Text("")) {
                                        ForEach(0 ..< mapStyles.count) {
                                            Text(self.mapStyles[$0])
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .padding(.top, 5)
                                    .padding(.leading, 15)
                                    .padding(.trailing, 15)
                                    .padding(.bottom, 10)
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                }.background(Color.black)
                            }.padding(.bottom, 15)
                            
                            // Location Settings
                            VStack (alignment: .leading, spacing: 0){
                                Text("LOCATION")
                                    .padding(.bottom, 5)
                                    .padding(.leading, 10)
                                    .foregroundColor(.white)
                                VStack (alignment: .leading) {
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    Toggle(isOn: $allowUserLocation) {
                                        Text("Allow LinkUP! to use my location")
                                            .fixedSize(horizontal: false, vertical: true)
                                            .padding(.top, 5)
                                            .foregroundColor(.white)
                                    }
                                    .padding(.leading, 15)
                                    .padding(.trailing, 15)
                                    
                                    Text("While turned off, your experience will not be optimized.")
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 15)
                                        .padding(.trailing, 15)
                                        .padding(.bottom, 5)
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                }
                                .background(Color.black)
                            }.padding(.bottom, 15)
                            
                            // Privacy settings
                            VStack (alignment: .leading, spacing: 0) {
                                Text("PRIVACY")
                                    .padding(.bottom, 5)
                                    .padding(.leading, 10)
                                    .foregroundColor(.white)
                                VStack (alignment: .leading) {
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    Toggle(isOn: $showToFriends) {
                                        Text("Allow friends to see events I'm attending")
                                            .fixedSize(horizontal: false, vertical: true)
                                            .foregroundColor(.white)
                                    }
                                    .padding(.leading, 15)
                                    .padding(.trailing, 15)
                                    .padding(.top, 5)
                                    Text("While turned off, your friends will not be able to see events you are attending.")
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 15)
                                        .padding(.trailing, 15)
                                        .padding(.bottom, 5)
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                }
                                .background(Color.black)
                            }.padding(.bottom, 15)
                            
                            //Set the range that you want to see events within
                            VStack (alignment: .leading, spacing: 0){
                                Text("DISCOVERY")
                                    .padding(.bottom, 5)
                                    .padding(.leading, 10)
                                    .foregroundColor(.white)
                                VStack (alignment: .leading){
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    HStack {
                                        Text("Find events within:")
                                            .fixedSize(horizontal: false, vertical: true)
                                            .padding(.leading, 15)
                                            .padding(.top, 5)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text("\(rangeValue, specifier: "%.0f") miles")
                                            .padding(.trailing, 15)
                                            .padding(.top, 5)
                                            .foregroundColor(.white)
                                    }
                                    Slider(value: $rangeValue, in: 0...50)
                                        .padding(.leading, 15)
                                        .padding(.trailing, 15)
                                        .padding(.bottom, 5)
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                }.background(Color.black)
                            }.padding(.bottom, 15)
                            
                            //Legal Stuff
                            VStack (alignment: .leading, spacing: 0){
                                Text("LEGAL")
                                    .padding(.bottom, 5)
                                    .padding(.leading, 10)
                                    .foregroundColor(.white)
                                VStack (alignment: .leading){
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    HStack {
                                        NavigationLink(destination: PrivacyPolicyView()) {
                                            Text("Privacy Policy")
                                                .padding(.leading, 15)
                                            Spacer()
                                        }
                                    }
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    .padding(.horizontal, 15)
                                    HStack {
                                        NavigationLink(destination: TermsConditionsView()) {
                                            Text("Terms and Conditions")
                                                .padding(.leading, 15)
                                            Spacer()
                                        }
                                    }
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    .padding(.horizontal, 15)
                                    HStack {
                                        NavigationLink(destination: LicensesView()) {
                                            Text("Licenses")
                                                .padding(.leading, 15)
                                            Spacer()
                                        }
                                    }
                                    
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                }
                                .background(Color.black)
                            }.padding(.bottom, 15)
                            
                        }.navigationBarTitle("Settings", displayMode: .inline)
                            .navigationBarColor(UIColor.init(displayP3Red: 7/255, green: 7/255, blue: 7/255, alpha: 1), .white, .white, .white)
                            .navigationBarItems(trailing:
                                Button("Done") {
                                    self.isPresentedSettings.toggle()
                                    print("allowsUserLocation is \(self.allowUserLocation)")
                                    print("showToFriends is \(self.showToFriends)")
                                    print("rangeValue is \(self.rangeValue)")
                                    print("selectedMapStyleis \(self.selectedMapStyle)")
                                }
                        )
                            .background(Color.init(red: 0.1, green: 0.1, blue: 0.1))
                    }.background(Color.init(red: 0.1, green: 0.1, blue: 0.1))
                }.navigationViewStyle(StackNavigationViewStyle())
                    .background(Color.init(red: 0.1, green: 0.1, blue: 0.1))
            } else {
                NavigationView {
                    ScrollView {
                        VStack (alignment: .leading){
                            
                            Spacer()
                            
                            //Account Settings
                            VStack (alignment: .leading, spacing: 0){
                                Text("ACCOUNT")
                                    .padding(.bottom, 5)
                                    .padding(.leading, 10)
                                    .foregroundColor(.gray)
                                VStack {
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    Text("Phone Number")
                                        .padding(.leading, 15)
                                        .foregroundColor(Color.black)
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    .padding(.horizontal, 15)
                                    Text("This will be email's row")
                                        .padding(.leading, 15)
                                        .foregroundColor(Color.black)
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    .padding(.horizontal, 15)
                                    Button(
                                        action: {
                                            self.isPresentedSettings = false
                                            self.token = ""
                                            print("logged out: \(self.token)")
                                            UserDefaults.standard.set("", forKey: "Token")
                                    }, label: {
                                        Text("Logout")
                                    })
                                        .padding(.leading, 15)
                                        .foregroundColor(Color.black)
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                }.background(Color.white)
                            }.padding(.bottom, 15)
                            
                            //Map Settings
                            VStack (spacing: 0){
                                HStack {
                                    Text("MAP")
                                        .padding(.bottom, 5)
                                        .padding(.leading, 10)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                VStack (alignment: .leading, spacing: 0){
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    Text("Map Style")
                                        .foregroundColor(Color.black)
                                        .padding(.top, 5)
                                        .padding(.leading, 15)
                                    Picker(selection: $selectedMapStyle, label: Text("")) {
                                        ForEach(0 ..< mapStyles.count) {
                                            Text(self.mapStyles[$0])
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .padding(.top, 5)
                                    .padding(.leading, 15)
                                    .padding(.trailing, 15)
                                    .padding(.bottom, 10)
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                }.background(Color.white)
                            }.padding(.bottom, 15)
                            
                            // Location Settings
                            VStack (alignment: .leading, spacing: 0){
                                Text("LOCATION")
                                    .padding(.bottom, 5)
                                    .padding(.leading, 10)
                                    .foregroundColor(.gray)
                                VStack (alignment: .leading) {
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    Toggle(isOn: $allowUserLocation) {
                                        Text("Allow LinkUP! to use my location")
                                            .foregroundColor(Color.black)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .padding(.top, 5)
                                    }
                                    .padding(.leading, 15)
                                    .padding(.trailing, 15)
                                    Text("While turned off, your experience will not be optimized.")
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 15)
                                        .padding(.trailing, 15)
                                        .padding(.bottom, 5)
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                }
                                .background(Color.white)
                            }.padding(.bottom, 15)
                            
                            // Privacy settings
                            VStack (alignment: .leading, spacing: 0) {
                                Text("PRIVACY")
                                    .padding(.bottom, 5)
                                    .padding(.leading, 10)
                                    .foregroundColor(.gray)
                                VStack (alignment: .leading) {
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    Toggle(isOn: $showToFriends) {
                                        Text("Allow friends to see events I'm attending")
                                            .foregroundColor(Color.black)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .padding(.leading, 15)
                                    .padding(.trailing, 15)
                                    .padding(.top, 5)
                                    Text("While turned off, your friends will not be able to see events you are attending.")
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 15)
                                        .padding(.trailing, 15)
                                        .padding(.bottom, 5)
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                }
                                .background(Color.white)
                            }.padding(.bottom, 15)
                            
                            //Set the range that you want to see events within
                            VStack (alignment: .leading, spacing: 0){
                                Text("DISCOVERY")
                                    .padding(.bottom, 5)
                                    .padding(.leading, 10)
                                    .foregroundColor(.gray)
                                VStack (alignment: .leading){
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    HStack {
                                        Text("Find events within:")
                                            .fixedSize(horizontal: false, vertical: true)
                                            .padding(.leading, 15)
                                            .padding(.top, 5)
                                        Spacer()
                                        Text("\(rangeValue, specifier: "%.0f") miles")
                                            .padding(.trailing, 15)
                                            .padding(.top, 5)
                                    }.foregroundColor(Color.black)
                                    Slider(value: $rangeValue, in: 0...50)
                                        .padding(.leading, 15)
                                        .padding(.trailing, 15)
                                        .padding(.bottom, 5)
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                }.background(Color.white)
                            }.padding(.bottom, 15)
                            
                            //Legal Stuff
                            VStack (alignment: .leading, spacing: 0){
                                Text("LEGAL")
                                    .padding(.bottom, 5)
                                    .padding(.leading, 10)
                                    .foregroundColor(.gray)
                                VStack (alignment: .leading){
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    HStack {
                                        NavigationLink(destination: PrivacyPolicyView()) {
                                            Text("Privacy Policy")
                                                .padding(.leading, 15)
                                            Spacer()
                                        }
                                    }
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    .padding(.horizontal, 15)
                                    HStack {
                                        NavigationLink(destination: TermsConditionsView()) {
                                            Text("Terms and Conditions")
                                                .padding(.leading, 15)
                                            Spacer()
                                        }
                                    }
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                    .padding(.horizontal, 15)
                                    HStack {
                                        NavigationLink(destination: LicensesView()) {
                                            Text("Licenses")
                                                .padding(.leading, 15)
                                            Spacer()
                                        }
                                    }
                                    
                                    VStack {
                                        HStack {
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 1.0/(UIScreen.main.scale)).background(Color.gray)
                                }
                                .background(Color.white)
                            }.padding(.bottom, 15)
                            
                        }.navigationBarTitle("Settings", displayMode: .inline)
                            .navigationBarColor(UIColor.init(displayP3Red: 1, green: 1, blue: 1, alpha: 1), .black, .black, .systemBlue)
                            .navigationBarItems(trailing:
                                Button("Done") {
                                    self.isPresentedSettings.toggle()
                                }.foregroundColor(Color.purple)
                        )
                            .background(Color.init(red: 0.9, green: 0.9, blue: 0.9))
                    }.background(Color.init(red: 0.9, green: 0.9, blue: 0.9))
                        .accentColor(Color.purple)
                }.navigationViewStyle(StackNavigationViewStyle())
                    .background(Color.init(red: 0.9, green: 0.9, blue: 0.9))
            }
            
        }
        
    }
}

extension Binding where Value == Bool {
    var not: Binding<Value>  {
        return Binding<Value>(get: { return !self.wrappedValue},
                              set: { b in self.wrappedValue = b})
    }
}

