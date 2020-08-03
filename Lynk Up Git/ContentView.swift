//
import SwiftUI
import Mapbox
import CoreLocation
import skpsmtpmessage




struct ContentView: View {
    @ObservedObject var annotationsVM: AnnotationsVM //= AnnotationsVM()
    @ObservedObject var VModel: ViewModel //= ViewModel()
    @ObservedObject var locationManager: LocationManager //= LocationManager()
    @ObservedObject var data: DataFetcher
    //@ObservedObject var mapViewCoordinator = MapViewCoordinator()
    
    init() {
        let vm = ViewModel()
        VModel = vm
        annotationsVM =  AnnotationsVM(VModel: vm)
        locationManager = LocationManager()
        data = DataFetcher()
    }
    
    var userLatitude: CLLocationDegrees {
        return (locationManager.lastLocation?.latitude ?? 0)
    }
    
    var userLongitude: CLLocationDegrees {
        return (locationManager.lastLocation?.longitude ?? 0)
    }
    
    var lat: Double {
        return (VModel.lat ?? 0)
    }
    var long: Double {
        return (VModel.lon ?? 0)
    }
    
    var Userlat: Double {
        return (VModel.userLatitude)
    }
    var Userlon: Double {
        return (VModel.userLongitude)
    }
    
    //@State var searchedLocation: String = ""
    @State private var annotationSelected: Bool = false
    @State private var renderingMap: Bool = true
    @State private var searchedText: String = ""
    @State private var showResults: Bool = false
    @State private var showMoreDetails: Bool = false
    @State private var selectedAnnotation: MGLAnnotation? = nil
    @State private var isPresentedSettings = false
    @State private var isPresentedMyEvents = false
    @State private var allowUserLocation: Bool = false
    @State private var showToFriends: Bool = false
    @State private var rangeValue: Double = 0
    @State private var selectedMapStyle: Int = 0
    @State private var selectedDay: Date = Date()
    @State private var showDaySelector: Bool = false
    @State private var DayRangeValue: Double = Double(Calendar.current.component(.hour, from: Date())) + (Double(Calendar.current.component(.minute, from: Date())) / 60.0)
    @State var position = CardPosition.bottom(UIScreen.main.bounds.height - 77.5)
    @State private var authToken: String = UserDefaults.standard.string(forKey: "Token") ?? ""
    @State private var didLogin: Bool = false
    @State private var needsAccount: Bool = false
    @State private var events: [eventdata] = []
    @State private var centerToUser: () -> () = { }
    @State private var eventDescription: String = ""
    @State private var showCreateEventResults: Bool = false
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)){
            Group{
                if self.data.dataHasLoaded{
                    if selectedMapStyle == 0 && UITraitCollection.current.userInterfaceStyle == .light {
                        MapView(annotationSelected: $annotationSelected, renderingMap: $renderingMap, visited: $annotationsVM.visited, showMoreDetails: $showMoreDetails, selectedAnnotation: $selectedAnnotation, showDateSelector: $showDaySelector, VModel: VModel, locationManager: locationManager, aVM: annotationsVM, annos: $annotationsVM.annos, mapStyle: MGLStyle.outdoorsStyleURL, data: data, token: authToken) { map in
                            self.centerToUser = {
                                map.setCenter(map.userLocation!.coordinate, zoomLevel: 13 , animated: true)
                            }
                        }
                        .edgesIgnoringSafeArea(.all)
                        
                    } else if selectedMapStyle == 0 && UITraitCollection.current.userInterfaceStyle == .dark {
                        MapView(annotationSelected: $annotationSelected, renderingMap: $renderingMap, visited: $annotationsVM.visited, showMoreDetails: $showMoreDetails, selectedAnnotation: $selectedAnnotation, showDateSelector: $showDaySelector, VModel: VModel, locationManager: locationManager, aVM: annotationsVM, annos: $annotationsVM.annos, mapStyle: MGLStyle.darkStyleURL, data: data, token: authToken) { map in
                            self.centerToUser = {
                                map.setCenter(map.userLocation!.coordinate, zoomLevel: 13 , animated: true)
                            }
                        }
                        .edgesIgnoringSafeArea(.all)
                    } else if selectedMapStyle == 1 {
                        MapView(annotationSelected: $annotationSelected, renderingMap: $renderingMap, visited: $annotationsVM.visited, showMoreDetails: $showMoreDetails, selectedAnnotation: $selectedAnnotation, showDateSelector: $showDaySelector, VModel: VModel, locationManager: locationManager, aVM: annotationsVM, annos: $annotationsVM.annos, mapStyle: MGLStyle.outdoorsStyleURL, data: data, token: authToken) { map in
                            self.centerToUser = {
                                map.setCenter(map.userLocation!.coordinate, zoomLevel: 13 , animated: true)
                            }
                        }
                        .edgesIgnoringSafeArea(.all)
                    } else if selectedMapStyle == 2 {
                        MapView(annotationSelected: $annotationSelected, renderingMap: $renderingMap, visited: $annotationsVM.visited, showMoreDetails: $showMoreDetails, selectedAnnotation: $selectedAnnotation, showDateSelector: $showDaySelector, VModel: VModel, locationManager: locationManager, aVM: annotationsVM, annos: $annotationsVM.annos, mapStyle: MGLStyle.darkStyleURL, data: data, token: authToken) { map in
                            self.centerToUser = {
                                map.setCenter(map.userLocation!.coordinate, zoomLevel: 13 , animated: true)
                            }
                        }
                        .edgesIgnoringSafeArea(.all)
                    }
                }else{
                    Text("Loading Map")
                }
            }.onAppear{
                //while(self.authToken == ""){
                self.data.fetchEvents()
                //}
            }
            VStack{
                HStack(alignment: .top){
                    Spacer()
                    VStack {
                        if showResults == false {
                            if (self.selectedMapStyle == 0 && UITraitCollection.current.userInterfaceStyle == .light) {
                                SettingsButton(isPresentedSettings: $isPresentedSettings, allowUserLocation: $allowUserLocation, showToFriends: $showToFriends, locationManager: locationManager, rangeValue: $rangeValue, selectedMapStyle: $selectedMapStyle, token: $authToken, mapStyle: MGLStyle.outdoorsStyleURL)
                            } else if (self.selectedMapStyle == 0 && UITraitCollection.current.userInterfaceStyle == .dark) {
                                SettingsButton(isPresentedSettings: $isPresentedSettings, allowUserLocation: $allowUserLocation, showToFriends: $showToFriends, locationManager: locationManager, rangeValue: $rangeValue, selectedMapStyle: $selectedMapStyle, token: $authToken, mapStyle: MGLStyle.darkStyleURL)
                            } else if (self.selectedMapStyle == 1) {
                                SettingsButton(isPresentedSettings: $isPresentedSettings, allowUserLocation: $allowUserLocation, showToFriends: $showToFriends, locationManager: locationManager, rangeValue: $rangeValue, selectedMapStyle: $selectedMapStyle, token: $authToken, mapStyle: MGLStyle.outdoorsStyleURL)
                            } else if (self.selectedMapStyle == 2) {
                                SettingsButton(isPresentedSettings: $isPresentedSettings, allowUserLocation: $allowUserLocation, showToFriends: $showToFriends, locationManager: locationManager, rangeValue: $rangeValue, selectedMapStyle: $selectedMapStyle, token: $authToken, mapStyle: MGLStyle.darkStyleURL)
                            }
                        }
                        
                        
                        
                        if showResults == false {
                            if (self.selectedMapStyle == 0 && UITraitCollection.current.userInterfaceStyle == .light) {
                                MessageButton(mapStyle: MGLStyle.outdoorsStyleURL)
                            } else if (self.selectedMapStyle == 0 && UITraitCollection.current.userInterfaceStyle == .dark) {
                                MessageButton(mapStyle: MGLStyle.darkStyleURL)
                            } else if (self.selectedMapStyle == 1) {
                                MessageButton(mapStyle: MGLStyle.outdoorsStyleURL)
                            } else if (self.selectedMapStyle == 2) {
                                MessageButton(mapStyle: MGLStyle.darkStyleURL)
                            }
                        }
                        
                        if showResults == false {
                            if (self.selectedMapStyle == 0 && UITraitCollection.current.userInterfaceStyle == .light) {
                                CenterToUserButton(centerToUser: $centerToUser, allowUserLocation: $allowUserLocation, locationManager: locationManager, mapStyle: MGLStyle.outdoorsStyleURL)
                            } else if (self.selectedMapStyle == 0 && UITraitCollection.current.userInterfaceStyle == .dark) {
                                CenterToUserButton(centerToUser: $centerToUser, allowUserLocation: $allowUserLocation, locationManager: locationManager, mapStyle: MGLStyle.darkStyleURL)
                            } else if (self.selectedMapStyle == 1) {
                                CenterToUserButton(centerToUser: $centerToUser, allowUserLocation: $allowUserLocation, locationManager: locationManager, mapStyle: MGLStyle.outdoorsStyleURL)
                            } else if (self.selectedMapStyle == 2) {
                                CenterToUserButton(centerToUser: $centerToUser, allowUserLocation: $allowUserLocation, locationManager: locationManager, mapStyle: MGLStyle.darkStyleURL)
                            }
                        }
                    }
                    
                }.padding()
                
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    if renderingMap {
                        //Text("The Map is Rendering...")
                        Text("")
                    }
                }
                
                
                //Side Note: If the Create Event Button is pressed, the currently selected annotation is unselected, so that'll need to be fixed
                //                HStack(alignment: .bottom) {
                //                    if annotationSelected {
                //                        if selectedMapStyle == 0 {
                //                            CreateEventButton(annotation: annotationsVM, annotationSelected: $annotationSelected, token: $authToken)
                //                        } else if selectedMapStyle == 1 {
                //                            CreateEventButton(annotation: annotationsVM, annotationSelected: $annotationSelected, token: $authToken)
                //                        } else if selectedMapStyle == 2 {
                //                            CreateEventButton(annotation: annotationsVM, annotationSelected: $annotationSelected, token: $authToken)
                //                        }
                //                    }
                //                }.padding()
                
                HStack(alignment: .bottom) {
                    if (self.selectedMapStyle == 0 && UITraitCollection.current.userInterfaceStyle == .light) {
                        TimeSelectorView(selectedDay: $selectedDay, showDaySelector: $showDaySelector, DayRangeValue: $DayRangeValue, mapStyle: MGLStyle.outdoorsStyleURL)
                    } else if (self.selectedMapStyle == 0 && UITraitCollection.current.userInterfaceStyle == .dark) {
                        TimeSelectorView(selectedDay: $selectedDay, showDaySelector: $showDaySelector, DayRangeValue: $DayRangeValue, mapStyle: MGLStyle.darkStyleURL)
                    } else if (self.selectedMapStyle == 1) {
                        TimeSelectorView(selectedDay: $selectedDay, showDaySelector: $showDaySelector, DayRangeValue: $DayRangeValue, mapStyle: MGLStyle.outdoorsStyleURL)
                    } else if (self.selectedMapStyle == 2 || UITraitCollection.current.userInterfaceStyle == .dark) {
                        TimeSelectorView(selectedDay: $selectedDay, showDaySelector: $showDaySelector, DayRangeValue: $DayRangeValue, mapStyle: MGLStyle.darkStyleURL)
                    }
                    
                }.padding(.bottom, 50)
                
                
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if annotationsVM.annotationPlacementFailed == true {
                        AnnotationPlacementErrorView(annotationPlacementFailed: $annotationsVM.annotationPlacementFailed, annotation: annotationsVM, searchedText: $searchedText)
                    }
                    Spacer()
                }
                Spacer()
            }
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    if self.showMoreDetails == true {
                        MoreDetailsView(searchedText: $searchedText, showMoreDetails: $showMoreDetails, selectedAnnotation: $selectedAnnotation, token: $authToken, data: data)
                        //Instead of passing in searchedText, we need to pass in the mapView...idk how though
                    }
                    Spacer()
                }
                Spacer()
            }
            
            if (self.selectedMapStyle == 0 && UITraitCollection.current.userInterfaceStyle == .light) {
                SlideOverCard(position: self.$position, mapStyle: MGLStyle.outdoorsStyleURL) {
                    VStack {
                        SearchBar(annotation: self.annotationsVM, VModel: self.VModel, searchedText: self.$searchedText, showResults: self.$showResults, showMoreDetails: self.$showMoreDetails, position: self.$position, mapStyle: MGLStyle.outdoorsStyleURL)
                        
                        if (self.showResults == true && self.searchedText.count >= 1) {
                            SearchResults(VModel: self.VModel, annotation: self.annotationsVM, showResults: self.$showResults, searchedText: self.$searchedText, position: self.$position, mapStyle: MGLStyle.outdoorsStyleURL)
                        }
                        
                        
                        HStack{
                            CreateEventButton(VModel: self.VModel, annotation: self.annotationsVM, annotationSelected: self.$annotationSelected, token: self.$authToken, eventDescription: self.$eventDescription, showCreateEventResults: self.$showCreateEventResults, mapStyle: MGLStyle.outdoorsStyleURL)
                            .padding(.leading, 15)
                            MyEventsButton(isPresentedMyEvents: self.$isPresentedMyEvents, token: self.$authToken, data: self.data)
                            Spacer()
                        }.padding(.top, 20)
                        Spacer()
                        
                    }
                }
            }
            else if (self.selectedMapStyle == 0 && UITraitCollection.current.userInterfaceStyle == .dark) {
                SlideOverCard(position: self.$position, mapStyle: MGLStyle.darkStyleURL) {
                    VStack {
                        SearchBar(annotation: self.annotationsVM, VModel: self.VModel, searchedText: self.$searchedText, showResults: self.$showResults, showMoreDetails: self.$showMoreDetails, position: self.$position, mapStyle: MGLStyle.darkStyleURL)
                        if self.showResults == true && self.searchedText.count >= 1 {
                            SearchResults(VModel: self.VModel, annotation: self.annotationsVM, showResults: self.$showResults, searchedText: self.$searchedText, position: self.$position, mapStyle: MGLStyle.darkStyleURL)
                        }
                        
                        HStack{
                            CreateEventButton(VModel: self.VModel, annotation: self.annotationsVM, annotationSelected: self.$annotationSelected, token: self.$authToken, eventDescription: self.$eventDescription, showCreateEventResults: self.$showCreateEventResults, mapStyle: MGLStyle.darkStyleURL)
                            .padding(.leading, 15)
                            MyEventsButton(isPresentedMyEvents: self.$isPresentedMyEvents, token: self.$authToken, data: self.data)
                            Spacer()
                        }.padding(.top, 20)
                        Spacer()
                    }
                }
            }
            else if (self.selectedMapStyle == 1) {
                SlideOverCard(position: self.$position, mapStyle: MGLStyle.outdoorsStyleURL) {
                    VStack {
                        
                        SearchBar(annotation: self.annotationsVM, VModel: self.VModel, searchedText: self.$searchedText, showResults: self.$showResults, showMoreDetails: self.$showMoreDetails, position: self.$position, mapStyle: MGLStyle.outdoorsStyleURL)
                        
                        if (self.showResults == true && self.searchedText.count >= 1) {
                            SearchResults(VModel: self.VModel, annotation: self.annotationsVM, showResults: self.$showResults, searchedText: self.$searchedText, position: self.$position, mapStyle: MGLStyle.outdoorsStyleURL)
                        }
                        
                        HStack{
                            CreateEventButton(VModel: self.VModel, annotation: self.annotationsVM, annotationSelected: self.$annotationSelected, token: self.$authToken, eventDescription: self.$eventDescription, showCreateEventResults: self.$showCreateEventResults, mapStyle: MGLStyle.outdoorsStyleURL)
                            .padding(.leading, 15)
                            MyEventsButton(isPresentedMyEvents: self.$isPresentedMyEvents, token: self.$authToken, data: self.data)
                            Spacer()
                        }.padding(.top, 20)
                        Spacer()
                    }
                }
            }
            else if (self.selectedMapStyle == 2) {
                SlideOverCard(position: self.$position, mapStyle: MGLStyle.darkStyleURL) {
                    VStack {
                        SearchBar(annotation: self.annotationsVM, VModel: self.VModel, searchedText: self.$searchedText, showResults: self.$showResults, showMoreDetails: self.$showMoreDetails, position: self.$position, mapStyle: MGLStyle.darkStyleURL)
                        if self.showResults == true && self.searchedText.count >= 1 {
                            SearchResults(VModel: self.VModel, annotation: self.annotationsVM, showResults: self.$showResults, searchedText: self.$searchedText, position: self.$position, mapStyle: MGLStyle.darkStyleURL)
                        }
                        
                        HStack{
                            CreateEventButton(VModel: self.VModel, annotation: self.annotationsVM, annotationSelected: self.$annotationSelected, token: self.$authToken, eventDescription: self.$eventDescription, showCreateEventResults: self.$showCreateEventResults, mapStyle: MGLStyle.darkStyleURL)
                                .padding(.leading, 15)
                            MyEventsButton(isPresentedMyEvents: self.$isPresentedMyEvents, token: self.$authToken, data: self.data)
                            Spacer()
                        }.padding(.top, 20)
                        Spacer()
                    }
                }
            }
            
            if self.authToken == "" {
                LogInView(didLogin: $didLogin, needsAccount: $needsAccount, token: $authToken)
            }
            
            if self.needsAccount == true {
                SignUpView(didLogin: $didLogin, needsAccount: $needsAccount, token: $authToken)
            }
            
        }
        
        
    }
}

struct NavigationBarModifier: ViewModifier {
    
    var backgroundColor: UIColor?
    var titleColor: UIColor?
    var largeTitleColor: UIColor?
    var tintColor: UIColor?
    
    init( backgroundColor: UIColor?, titleColor: UIColor?, largeTitleColor: UIColor?, tintColor: UIColor?) {
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.largeTitleColor = largeTitleColor
        self.tintColor = tintColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = tintColor
    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {
    
    func navigationBarColor(_ backgroundColor: UIColor?, _ titleColor: UIColor?, _ largeTitleColor: UIColor?, _ tintColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, titleColor: titleColor, largeTitleColor: largeTitleColor, tintColor: tintColor))
    }
    
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
