//
//  ContentView.swift
//  SPAppOS
//
//  Created by Preston Smith on 3/27/20.
//  Copyright © 2020 Preston Smith. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var currView = "splash"
    @State var positionArray = [Position]()
    @State var favoriteArray = [Position]()
    @State var positionDictionary = [Date : Position]()
    @State var selectedPosition: Position?
    @State var selectedDate: Date?
    @State var likeSelected: Bool = false
    @State var dislikeSelected: Bool = false
    @State var pastAvailable: Bool = true
    @State var futureAvailable: Bool = true
    
    
    var body: some View {
        ZStack() {
            Color("bg").edgesIgnoringSafeArea(.all)
            VStack() {
                if (self.currView == "splash") {
                    SplashView(currView: self.$currView, positionDictionary: self.$positionDictionary, positionArray: self.$positionArray, favoriteArray: self.$favoriteArray)
                } else if (self.currView == "welcome") {
                    WelcomeView(currView: self.$currView, selectedPosition: self.$selectedPosition, selectedDate: self.$selectedDate, positionDictionary: self.$positionDictionary, likeSelected: self.$likeSelected, dislikeSelected: self.$dislikeSelected, pastAvailable: self.$pastAvailable, futureAvailable: self.$futureAvailable)
                } else if (self.currView == "position") {
                    PositionView(currView: self.$currView, selectedPosition: self.$selectedPosition, positionDictionary: self.$positionDictionary, selectedDate: self.$selectedDate, likeSelected: self.$likeSelected, dislikeSelected: self.$dislikeSelected, pastAvailable: self.$pastAvailable, futureAvailable: self.$futureAvailable)
                }
            }
        }
    }
}
