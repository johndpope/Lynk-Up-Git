//
//  SearchResults.swift
//  Meep
//
//  Created by Katia K Brinsmade on 5/24/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//
import Foundation
import SwiftUI
import MapboxGeocoder
import Mapbox

struct SearchResults: View {
    
    @ObservedObject var VModel: ViewModel
    var annotation: AnnotationsVM
    @Binding var showResults: Bool
    @Binding var searchedText: String
    var mapStyle: URL
    
    init(VModel: ViewModel, annotation: AnnotationsVM, showResults: Binding<Bool>, searchedText: Binding<String>, mapStyle: URL) {
        self.VModel = VModel
        self.annotation = annotation
        _showResults = showResults
        _searchedText = searchedText
        self.mapStyle = mapStyle
        if self.mapStyle == MGLStyle.darkStyleURL {
            UITableView.appearance().backgroundColor = .systemGray
            UITableViewCell.appearance().backgroundColor = .clear
        } else {
            UITableView.appearance().backgroundColor = .white
            UITableViewCell.appearance().backgroundColor = .clear
        }
    }
    
    var body: some View {
        List {
            if self.mapStyle == MGLStyle.darkStyleURL {
                ForEach(self.VModel.searchResults, id: \.self) { result in
                    Button(action: {
                        self.annotation.addNextAnnotation(address: self.rowText(result: result).label)
                        self.showResults = false
                        self.searchedText = self.rowText(result: result).label
                    }, label: {
                        self.rowText(result: result).view.font(.system(size: 13))
                        
                    }).listRowBackground(Color.gray)
                }
            } else {
                ForEach(self.VModel.searchResults, id: \.self) { result in
                    Button(action: {
                        self.annotation.addNextAnnotation(address: self.rowText(result: result).label)
                        self.showResults = false
                        self.searchedText = self.rowText(result: result).label
                    }, label: {
                        self.rowText(result: result).view.font(.system(size: 13))
                        
                    })
                }
            }
        }.padding(.trailing, 15)
            //.frame(height: 222)
            .frame(height: 450)
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
