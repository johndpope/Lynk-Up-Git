//
//  SearchBar.swift
//  Meep
//
//  Created by Katia K Brinsmade on 4/23/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//




import SwiftUI
import Mapbox
import MapboxGeocoder

struct SearchBar: View {
    
    
    var annotation: AnnotationsVM
    @State var searchText: String = ""
    //@State var typing: Bool = false
    @State private var showCancelButton: Bool = false
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var VModel : ViewModel
    @Binding var searchedText: String
    @Binding var showResults: Bool
    @Binding var showMoreDetails: Bool
    @Binding var position: CardPosition
    var mapStyle: URL

    var body: some View {

     let binding = Binding<String>(get: {
        self.searchText
        }, set: {
        self.searchText = $0
        self.searchedText = self.searchText
        self.VModel.findResults(address: self.searchedText)
        if self.VModel.searchResults.count >= 0 {
            self.showResults = true
            self.showMoreDetails = false
            self.position = CardPosition.top(50)
        } else {
            self.showResults = false
        }
            if self.searchText == "" {
                self.position = CardPosition.bottom(UIScreen.main.bounds.height - 77.5)
            }
     }
     )
        
        
            return VStack {
                // Search view
                HStack {
                    if self.mapStyle == MGLStyle.darkStyleURL {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            
                            TextField("Search", text: binding, onEditingChanged: { isEditing in
                                self.showCancelButton = true
                                self.showMoreDetails = false
                                
                            }, onCommit: {
                                if self.VModel.searchResults.first != nil {
                                    self.annotation.addNextAnnotation(address: self.rowText(result: self.VModel.searchResults.first!).label)
                                    self.searchedText = "\(self.rowText(result: self.VModel.searchResults.first!).label)"
                                }
                                self.position = CardPosition.bottom(UIScreen.main.bounds.height - 77.5)
                                self.showMoreDetails = false
                                self.showResults = false
                                })
                                .shadow(radius: 8)
                            
                            Button(action: {
                                self.searchText = ""
                                self.showResults = false
                                self.position = CardPosition.top(50)
                            }) {
                                Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0.0 : 1.0)
                            }
                        }
                        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                        .foregroundColor(Color(.lightGray))
                        .background(Color.init(red: 7/255, green: 7/255, blue: 7/255))
                        .cornerRadius(20.0)
                        .overlay(RoundedRectangle(cornerRadius: 20.0).stroke(Color.white, lineWidth: 1))
                    } else {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            
                            ZStack {
                                TextField("Search", text: binding, onEditingChanged: { isEditing in
                                    self.showCancelButton = true
                                    self.showMoreDetails = false
                                    
                                }, onCommit: {
                                    if self.VModel.searchResults.first != nil {
                                        self.annotation.addNextAnnotation(address: self.rowText(result: self.VModel.searchResults.first!).label)
                                        self.searchedText = "\(self.rowText(result: self.VModel.searchResults.first!).label)"
                                    }
                                    self.position = CardPosition.bottom(UIScreen.main.bounds.height - 77.5)
                                    self.showMoreDetails = false
                                    self.showResults = false
                                })
                                    .foregroundColor(Color(.lightGray))
                                    .shadow(radius: 8)
                                HStack {
                                    if self.searchText.isEmpty {
                                        Text("Search")
                                            .foregroundColor(Color.gray)
                                    }
                                    Spacer()
                                }
                            }
                            Button(action: {
                                self.searchText = ""
                                self.showResults = false
                                self.position = CardPosition.top(50)
                            }) {
                                Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0.0 : 1.0)
                            }
                        }
                        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                        .foregroundColor(Color.gray)
                        .background(Color.init(red: 235/255, green: 235/255, blue: 235/255))
                        .cornerRadius(20.0)
                    }

                    if showCancelButton  {
                        Button("Cancel") {
                            UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                            self.searchText = ""
                            self.showResults = false
                            self.showCancelButton = false
                            self.position = CardPosition.bottom(UIScreen.main.bounds.height - 77.5)
                        }
                        .foregroundColor(Color(.systemBlue))
                    }
                }
                .padding(.horizontal)
                //.navigationBarHidden(showCancelButton) // .animation(.default) // animation does not work properly
        }
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





struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
           ContentView()
              .environment(\.colorScheme, .light)

           ContentView()
              .environment(\.colorScheme, .dark)
        }
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
