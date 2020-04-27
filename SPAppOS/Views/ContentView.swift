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
    @State var positionArray: [Position] = []
    @State var popPositionArray: [PositionDates] = []
    @State var selectedPosition: Position?
    @State var selectedDate: Date?
    
    var body: some View {
        VStack() {
            if (self.currView == "splash") {
                SplashView(currView: self.$currView, positionArray: self.$positionArray, popPositionArray: self.$popPositionArray)
            } else if (self.currView == "welcome") {
                WelcomeView(currView: self.$currView, selectedPosition: self.$selectedPosition, selectedDate: self.$selectedDate, positionArray: self.$positionArray, popPositionArray: self.$popPositionArray)
            } else if (self.currView == "position") {
                PositionView(currView: self.$currView, selectedPosition: self.$selectedPosition, positionArray: self.$positionArray, popPositionArray: self.$popPositionArray, selectedDate: self.$selectedDate)
            }
        }
    }
}
