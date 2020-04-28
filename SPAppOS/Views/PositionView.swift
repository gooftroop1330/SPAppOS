//
//  PositionView.swift
//  SPAppOS
//
//  Created by Preston Smith on 4/27/20.
//  Copyright © 2020 Preston Smith. All rights reserved.
//

import SwiftUI

struct PositionView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @Binding var currView: String
    @Binding var selectedPosition: Position?
    @Binding var positionArray: [Position]
    @Binding var popPositionArray: [PositionDates]
    @Binding var selectedDate: Date?
    @State var calIsPresented = false
    @State var likeSelected: Bool = false
    @State var dislikeSelected: Bool = false
    
    
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
                        if (pos.like == -1) {
                            self.dislikeSelected = true
                            self.likeSelected = false
                        } else if (pos.like == 1) {
                            self.likeSelected = true
                            self.dislikeSelected = false
                        } else {
                            self.likeSelected = false
                            self.dislikeSelected = false
                        }
                        break mainLoop
                    }
                }
            }
        }
    }
    
    func dislike() {
        if (self.selectedPosition!.like != -1){
            self.selectedPosition!.like = -1
            self.dislikeSelected = true
        } else {
            self.selectedPosition!.like = 0
            self.dislikeSelected = false
        }
        self.likeSelected = false
        try? self.moc.save()
    }
    
    
    func like() {
        if (self.selectedPosition!.like != 1){
            self.selectedPosition!.like = 1
            self.likeSelected = true
        } else {
            self.selectedPosition!.like = 0
            self.likeSelected = false
        }
        self.dislikeSelected = false
        try? self.moc.save()
    }
    
    var body: some View {
        Group() {
            VStack() {
                DSPBanner().padding(.bottom, 50)
                HStack() {
                    Text(prepDate(toBePrepped: self.selectedDate!))
                        .foregroundColor(Color.primary)
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
                            .foregroundColor(Color("ourPink"))
                            .padding(.trailing, 10)
                    }
                    .padding()
                    .sheet(isPresented: self.$calIsPresented, content: {
                        RKViewController(isPresented: self.$calIsPresented, rkManager: self.rkm)
                            .onDisappear(){
                                if (self.rkm.selectedDate != nil) {
                                    self.selectedDate = self.trimTime(toBeTrimmed: self.rkm.selectedDate)
                                }
                                self.setPosition(date: self.selectedDate!)
                        }})
                }
                Spacer()
                Text(self.selectedPosition!.positionName!.capitalized)
                    .foregroundColor(Color.primary)
                    .font(.system(size: 30))
                Spacer()
                Image(self.selectedPosition!.positionImage!).resizable().frame(width: 350.0, height: 200.0)
                Spacer()
                ScrollView {
                    Text(self.selectedPosition!.positionDescription!)
                        .foregroundColor(Color.primary)
                        .padding(5)
                }
            }
            Group() {
                HStack() {
                    Button(action: self.dislike) {
                        Text("Dislike").padding().foregroundColor(Color.primary)
                    }.background(Capsule().fill(self.dislikeSelected ? Color("ourPink") : Color("bg")).foregroundColor(Color("ourPink")).overlay(Capsule().stroke(lineWidth: 2).foregroundColor(Color("ourPink")))).frame(width: 100)
                    Spacer()
                    Button(action: self.like) {
                        Text("Like").padding().foregroundColor(Color.primary)
                    }.background(Capsule().fill(self.likeSelected ? Color("ourPink") : Color("bg")).foregroundColor(Color("ourPink")).overlay(Capsule().stroke(lineWidth: 2).foregroundColor(Color("ourPink")))).frame(width: 100)
                }.padding(15)
            }
        }
    }
}
