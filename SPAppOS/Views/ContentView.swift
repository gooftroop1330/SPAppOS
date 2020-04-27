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
    @State var positionsArray: [Position] = []
    @State var popPositionArray: [PositionDates] = []
    
    
    
    func createStartDate() -> Date {
        let timeTrimmer = 60.0 * 60 * 24
        let toTrim = Date()
        
        var trim = toTrim.timeIntervalSince1970
        trim = trim - (trim.truncatingRemainder(dividingBy: timeTrimmer))
        
        let startDate = Date(timeIntervalSince1970: trim)
        
        return startDate
    }
    
    func trimTime(toBeTrimmed: Date) -> Date {
        let timeTrimmer = 60.0 * 60 * 24
        
        var trim = toBeTrimmed.timeIntervalSince1970
        
        trim = trim - (trim.truncatingRemainder(dividingBy: timeTrimmer))
        
        let trimmed = Date(timeIntervalSince1970: trim)
        
        return trimmed
    }
    
    
    
    
//    func getPositionInfo(findDate: Date) -> [String] {
//        var currPos: Position = Position(context: self.moc)
//        for posDate in posDates {
//            if (posDate.dateAssigned == findDate) {
//                for position in positions {
//                    if (posDate.positionNum == position.positionNum) {
//                        currPos = position
//                        self.selectedPosition = position
//                    }
//                }
//            }
//        }
//        return [currPos.positionName!, currPos.positionDescription!, currPos.positionImage!]
//    }
    
    @State var selectedDate = Date()
    @State var selectedPosition: Position?
    @State var selectedPosInfo = [String]()
    @State var singleIsPresented = false
    
    var rkm = RKManager(calendar: Calendar.current, minimumDate: Date(timeIntervalSinceReferenceDate: 599529600).addingTimeInterval(60*60*24), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    func prepDate(toBePrepped: Date) -> String {
        let firstStep = toBePrepped.description.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: false)
        let secondStep = firstStep.description.split(separator: "-", maxSplits: 2, omittingEmptySubsequences: false)
        let thirdStep = secondStep[2].description.split(separator: "\"", maxSplits: 1, omittingEmptySubsequences: false)
        let final = secondStep[1].description + "-" + thirdStep[0].description + "-" + secondStep[0].description.suffix(4)
        return final
    }
    
    func dislike() {
        print("disliked")
    }
    
    func like() {
        print("liked")
    }
    
    var body: some View {
        VStack() {
            if (self.currView == "splash") {
                SplashView(currView: self.$currView, positionArray: self.$positionsArray, popPositionArray: self.$popPositionArray)
            } else if (self.currView == "welcome") {
                WelcomeView(currView: self.$currView)
            }
        }
    }
            
//            if(self.currView == "dsp") {
//                ZStack() {
//                    Color.black.edgesIgnoringSafeArea(.all)
//                    VStack(){
//                        DSPBanner()
//                        Spacer()
//                        HStack() {
//                        Text(prepDate(toBePrepped: self.selectedDate))
//                            .foregroundColor(Color.white)
//                            .bold()
//                            .font(.system(size: 30.0))
//                            .padding(.leading, 10)
//                        Spacer()
//                        Button(action: {
//                            self.rkm.maximumDate = self.rkm.minimumDate.addingTimeInterval(60.0 * 60 * 24 * Double(self.posDates.count - 1))
//                            self.singleIsPresented.toggle()
//
//                        }) {
//                            Image("calendar-icon")
//                                .resizable().frame(width: 30.0, height: 30.0)
//                                .foregroundColor(Color(red: 237/255, green: 119/255, blue: 229/255))
//                                .padding(.trailing, 10)
//                        }
//                        .padding()
//                        .sheet(isPresented: self.$singleIsPresented, content: {
//                            RKViewController(isPresented: self.$singleIsPresented, rkManager: self.rkm)
//                                .onDisappear(){
//                                    self.selectedDate = self.trimTime(toBeTrimmed: self.rkm.selectedDate)
//                                    self.selectedPosInfo = self.getPositionInfo(findDate: self.selectedDate)
//                            }})
//                        }
//                        Spacer()
//                        Text(self.selectedPosInfo[0].capitalized)
//                            .foregroundColor(Color.white)
//                            .font(.system(size: 30))
//                        Spacer()
//                        Image(self.selectedPosInfo[2]).resizable().frame(width: 350.0, height: 200.0)
//                        Spacer()
//                        Text(self.selectedPosInfo[1])
//                            .foregroundColor(Color.white)
//                            .padding(5)
//                        Spacer()
//                    }
//                    VStack() {
//                        HStack() {
//                            Button(action: dislike) {
//                                Text("Dislike")
//                            }
//                            Button(action: like) {
//                                Text("Like")
//                            }
//                        }
//                    }
//                }
            
}


