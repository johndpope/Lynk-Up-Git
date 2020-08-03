//
//  CreateEventSearchResults.swift
//  Lynk Up Git
//
//  Created by Nick Brinsmade on 8/2/20.
//  Copyright © 2020 Thomas D'Alessandro. All rights reserved.
//

import Foundation
import SwiftUI
import MapboxGeocoder
import Mapbox

struct CreateEventSearchResults: View {
    
    @ObservedObject var VModel: ViewModel
    var annotation: AnnotationsVM
    @Binding var showCreateEventResults: Bool
    @Binding var eventDescription: String
    var mapStyle: URL
    
    init(VModel: ViewModel, annotation: AnnotationsVM, showCreateEventResults: Binding<Bool>, eventDescription: Binding<String>, mapStyle: URL) {
        self.VModel = VModel
        self.annotation = annotation
        _showCreateEventResults = showCreateEventResults
        _eventDescription = eventDescription
        self.mapStyle = mapStyle
        if self.mapStyle == MGLStyle.darkStyleURL {
            UITableView.appearance().backgroundColor = .systemGray
            UITableViewCell.appearance().backgroundColor = .clear
        } else {
            UITableView.appearance().backgroundColor = UIColor.init(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            UITableViewCell.appearance().backgroundColor = .clear
        }
    }
    
    var body: some View {
        List {
            if self.mapStyle == MGLStyle.darkStyleURL {
                ForEach(self.VModel.searchResults, id: \.self) { result in
                    Button(action: {
                        self.showCreateEventResults = false
                        self.eventDescription = self.rowText(result: result).label
                    }, label: {
                        self.rowText(result: result).view.font(.system(size: 13))
                        
                    }).listRowBackground(Color.black)
                        .foregroundColor(Color.white)
                }
            } else {
                ForEach(self.VModel.searchResults, id: \.self) { result in
                    Button(action: {
                        self.showCreateEventResults = false
                        self.eventDescription = self.rowText(result: result).label
                    }, label: {
                        self.rowText(result: result).view.font(.system(size: 13))
                        
                    }).background(Color.init(red: 0.9, green: 0.9, blue: 0.9))
                }
            }
        }
            //.frame(height: 222)
            .frame(height: 445)
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

