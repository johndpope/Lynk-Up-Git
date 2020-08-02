//
//  AnnotationPlacementErrorView.swift
//  Meep
//
//  Created by Katia K Brinsmade on 5/19/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//

import Foundation
import SwiftUI

struct AnnotationPlacementErrorView: View {

    @Environment(\.presentationMode) var presentationMode
    @Binding var annotationPlacementFailed: Bool
    @ObservedObject var annotation: AnnotationsVM
    @Binding var searchedText: String

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack (alignment: .leading){
                    Text("Error Occured")
                        .padding(.leading, 0)
                        
                        Spacer()
                    }.frame(height: 5)
                        .padding(.leading, 12)
                        .padding(.top, 7)
                        .foregroundColor(.white)

                    Spacer()
                    
                    VStack {
                        Button("X") {
                            self.annotationPlacementFailed = false
                        }
                        
                        Spacer()
                        
                    }.frame(width: 10, height: 5)
                    .padding(.top, 7)
                    .padding()
                    .foregroundColor(.white)
                }.background(Color.orange)
                
                VStack (alignment: .leading){
                Text("The annotation failed to place. Please try again.")
                    .padding(.leading, 12)
                    .padding(.top, 15)
                    .padding(.bottom, 15)
                    .padding(.trailing, 5)
                }.frame(width: textWidth())
                
                VStack {
                    Button("Try again") {
                        //Call the function again to add the annotation
                        self.annotationPlacementFailed = false
                        self.annotation.addNextAnnotation(address: "\(self.searchedText)")
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
        return UIScreen.main.bounds.width / 1.5
    }
    
}

//struct AnnotationPlacementErrorView_Previews: PreviewProvider {
//    static var previews: some View {
//        //this works, but idk why but not complaining
//        AnnotationPlacementErrorView(annotationPlacementFailed: .constant(true), annotation: AnnotationsVM(), searchText: )
//    }
//}
