//
//  PositionView.swift
//  SPAppOS
//
//  Created by Preston Smith on 4/27/20.
//  Copyright © 2020 Preston Smith. All rights reserved.
//

import SwiftUI

struct PositionView: View {
    
    @Binding var currView: String
    @Binding var selectedPosition: Position?
    @Binding var positionArray: [Position]
    @Binding var popPositionArray: [PositionDates]
    @Binding var selectedDate: Date?
    @State var calIsPresented = false
    
    var rkm = RKManager(calendar: Calendar.current, minimumDate: Date(timeIntervalSinceReferenceDate: 599529600).addingTimeInterval(60*60*24), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    func prepDate(toBePrepped: Date) -> String {
        let firstStep = toBePrepped.description.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: false)
        let secondStep = firstStep.description.split(separator: "-", maxSplits: 2, omittingEmptySubsequences: false)
        let thirdStep = secondStep[2].description.split(separator: "\"", maxSplits: 1, omittingEmptySubsequences: false)
        let final = secondStep[1].description + "-" + thirdStep[0].description + "-" + secondStep[0].description.suffix(4)
        return final
    }
    
    func trimTime(toBeTrimmed: Date) -> Date {
        let timeTrimmer = 60.0 * 60 * 24
        
        var trim = toBeTrimmed.timeIntervalSince1970
        
        trim = trim - (trim.truncatingRemainder(dividingBy: timeTrimmer))
        
        let trimmed = Date(timeIntervalSince1970: trim)
        
        return trimmed
    }
    
    func setPosition(date: Date) {
        mainLoop: for pop in popPositionArray {
            if (pop.dateAssigned == date) {
                for pos in positionArray {
                    if (pos.positionNum == pop.positionNum) {
                        self.selectedPosition = pos
                        break mainLoop
                    }
                }
            }
        }
    }
    
    func dislike() {
        print("disliked")
    }
    
    func like() {
        print("liked")
    }
    
    var body: some View {
        Group() {
            VStack() {
                DSPBanner()
                Spacer()
                HStack() {
                    Text(prepDate(toBePrepped: self.selectedDate!))
                        .foregroundColor(Color.black)
                        .bold()
                        .font(.system(size: 30.0))
                        .padding(.leading, 10)
                    Spacer()
                    Button(action: {
                        self.rkm.maximumDate = self.rkm.minimumDate.addingTimeInterval(60.0 * 60 * 24 * Double(self.popPositionArray.count - 1))
                        self.calIsPresented.toggle()

                    }) {
                        Image("calendar-icon")
                            .resizable().frame(width: 30.0, height: 30.0)
                            .foregroundColor(Color(red: 237/255, green: 119/255, blue: 229/255))
                            .padding(.trailing, 10)
                    }
                    .padding()
                    .sheet(isPresented: self.$calIsPresented, content: {
                        RKViewController(isPresented: self.$calIsPresented, rkManager: self.rkm)
                            .onDisappear(){
                                self.selectedDate = self.trimTime(toBeTrimmed: self.rkm.selectedDate)
                                self.setPosition(date: self.selectedDate!)
                        }})
                }
                Spacer()
                Text(self.selectedPosition!.positionName!.capitalized)
                    .foregroundColor(Color.black)
                    .font(.system(size: 30))
                Spacer()
                Image(self.selectedPosition!.positionImage!).resizable().frame(width: 350.0, height: 200.0)
                Spacer()
                Text(self.selectedPosition!.positionDescription!)
                    .foregroundColor(Color.black)
                    .padding(5)
                Spacer()
            }
            Group() {
                HStack() {
                    Button(action: self.dislike) {
                        Text("Dislike")
                    }
                    Spacer()
                    Button(action: self.like) {
                        Text("Like")
                    }
                }.padding(15)
            }
        }
    }
}
