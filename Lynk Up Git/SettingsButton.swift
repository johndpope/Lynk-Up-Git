import SwiftUI
import Mapbox


struct SettingsButton: View {
    
    @Binding var isPresentedSettings: Bool
    @Binding var allowUserLocation: Bool
    //@Binding var allowUserLocationTwo: Bool
    @Binding var showToFriends: Bool
    @ObservedObject var locationManager: LocationManager
    @Binding var rangeValue: Double
    @Binding var selectedMapStyle: Int
    @Binding var token: String
    var mapStyle: URL
    
    var body: some View {
        VStack {
        if self.mapStyle == MGLStyle.darkStyleURL {
            Button(action: {
                self.isPresentedSettings.toggle() //trigger modal presentation
            }, label: {
                Image(systemName:"gear")
                    .font(.system(size: 30))
                    .foregroundColor(Color(.lightGray))
                    .shadow(radius: 8)
            }).padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                //.foregroundColor(.secondary)
                .background(Color.init(red: 7/255, green: 7/255, blue: 7/255))
                .cornerRadius(50.0)
                .sheet(isPresented: $isPresentedSettings, content:{
                    SettingsPageView(isPresentedSettings: self.$isPresentedSettings, allowUserLocation: self.$allowUserLocation, showToFriends: self.$showToFriends, rangeValue: self.$rangeValue, selectedMapStyle: self.$selectedMapStyle, mapStyle: self.mapStyle, locationManager: self.locationManager, token: self.$token).background(Color.red)
                    })
        } else {
            Button(action: {
                self.isPresentedSettings.toggle() //trigger modal presentation
            }, label: {
                Image(systemName:"gear").font(.system(size: 30)).foregroundColor(Color(.darkGray)).shadow(radius: 8)
            }).padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(50.0)
                .sheet(isPresented: $isPresentedSettings, content:{
                    SettingsPageView(isPresentedSettings: self.$isPresentedSettings, allowUserLocation: self.$allowUserLocation, showToFriends: self.$showToFriends, rangeValue: self.$rangeValue, selectedMapStyle: self.$selectedMapStyle, mapStyle: self.mapStyle, locationManager: self.locationManager, token: self.$token).background(Color.red)
                    })
            }
        }
//        NavigationLink (destination: SettingsPageView(isPresentedSettings: $isPresentedSettings, allowUserLocation: self.$allowUserLocation, showToFriends: self.$showToFriends, rangeValue: self.$rangeValue, selectedMapStyle: self.$selectedMapStyle, locationManager: self.locationManager).transition(.move(edge: .leading)), isActive: self.$isPresentedSettings) {
//                    Button(action: {
//                        self.isPresentedSettings = true //trigger modal presentation
//                    }, label: {
//                        Image(systemName:"gear").font(.system(size: 30)).foregroundColor(Color(.darkGray)).shadow(radius: 8)
//                    }).padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
//                        .foregroundColor(.secondary)
//                        .background(Color(.secondarySystemBackground))
//                        .cornerRadius(50.0)
//                }
    }
}
