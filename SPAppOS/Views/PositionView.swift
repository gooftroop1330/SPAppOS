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
    @Binding var positionDictionary: [Date : Position]
    @Binding var selectedDate: Date?
    @State var calIsPresented = false
    @Binding var likeSelected: Bool
    @Binding var dislikeSelected: Bool
    @State var dragOffset = CGSize.zero
    @State var rightDrag = false
    @State var leftDrag = false
    @Binding var pastAvailable: Bool
    @Binding var futureAvailable: Bool
    @State var showList: Bool = false
    
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
        self.selectedPosition = positionDictionary[date]
        self.pastAvailable = true
        self.futureAvailable = true
        if (self.selectedPosition!.like == -1) {
            self.dislikeSelected = true
            self.likeSelected = false
        } else if (self.selectedPosition!.like == 1) {
            self.likeSelected = true
            self.dislikeSelected = false
        } else {
            self.likeSelected = false
            self.dislikeSelected = false
        }
        if (date == Date(timeIntervalSinceReferenceDate: 599529600)) {
            self.pastAvailable = false
        } else if (date == Date(timeIntervalSinceReferenceDate: 599529600).addingTimeInterval(60.0 * 60 * 24 * Double(self.positionDictionary.count - 1))) {
            self.futureAvailable = false
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
            VStack {
                DSPBanner()
            }.padding(.bottom, 10)
            VStack {
                HStack {
                    Button(action: {self.showList.toggle()}){
                        Image("menu").resizable().frame(width: UIScreen.main.bounds.width * 0.06, height: UIScreen.main.bounds.width * 0.06).foregroundColor(Color.primary)
                    }.sheet(isPresented: self.$showList){
                        PositionList(selectedPosition: self.$selectedPosition, positionDictionary: self.$positionDictionary, selectedDate: self.$selectedDate, showList: self.$showList, dates: [], likeSelected: self.$likeSelected, dislikeSelected: self.$dislikeSelected, futureAvailable: self.$futureAvailable, pastAvailable: self.$pastAvailable)
                        
                    }.padding(.leading, 10).onDisappear(){
                        self.setPosition(date: self.selectedDate!)
                    }
                    Spacer()
                    Text(prepDate(toBePrepped: self.selectedDate!))
                        .foregroundColor(Color.primary)
                        .bold()
                        .font(.system(size: UIScreen.main.bounds.width * 0.05))
                        .fontWeight(.thin)
                        .padding(.leading, 10)
                    Spacer()
                    Button(action: {
                        self.rkm.maximumDate = self.rkm.minimumDate.addingTimeInterval(60.0 * 60 * 24 * Double(self.positionDictionary.count - 1))
                        self.rkm.selectedDate = self.selectedDate!.addingTimeInterval(60.0 * 60.0 * 4)
                        self.calIsPresented.toggle()

                    }) {
                        Image("calendar-icon")
                            .resizable().frame(width: UIScreen.main.bounds.width * 0.06, height: UIScreen.main.bounds.width * 0.06)
                            .foregroundColor(Color.primary)
                            .padding(.trailing, 10)
                    }
                    .padding(.trailing, 10)
                    .sheet(isPresented: self.$calIsPresented, content: {
                        RKViewController(isPresented: self.$calIsPresented, rkManager: self.rkm)
                            .onDisappear(){
                                if (self.rkm.selectedDate != nil) {
                                    self.selectedDate = self.trimTime(toBeTrimmed: self.rkm.selectedDate)
                                }
                                self.setPosition(date: self.selectedDate!)
                        }})
                }.padding([.leading, .trailing], 15)
                Spacer()
                Text(self.selectedPosition!.positionName!.capitalized)
                    .foregroundColor(Color.primary)
                    .font(.system(size: UIScreen.main.bounds.width * 0.06))
                    .fontWeight(.thin)
                Spacer()
                HStack {
                    if (self.pastAvailable) {
                        Button(action: self.back){
                            Image("back").resizable()
                            .frame(width: UIScreen.main.bounds.width * 0.06, height: UIScreen.main.bounds.width * 0.06)
                            .foregroundColor(Color.primary)
                            .padding()
                        }
                    }
                    Spacer()
                    Image(self.selectedPosition!.positionImage!).resizable().frame(width: UIScreen.main.bounds.width * 0.76, height: UIScreen.main.bounds.width * 0.4275)
                    Spacer()
                    if (self.futureAvailable) {
                        Button(action: self.forward){
                            Image("forward").resizable()
                            .frame(width: UIScreen.main.bounds.width * 0.06, height: UIScreen.main.bounds.width * 0.06)
                            .foregroundColor(Color.primary)
                            .padding()
                        }
                    }
                }
                Spacer()
                ScrollView {
                    Text(self.selectedPosition!.positionDescription!)
                        .foregroundColor(Color.primary)
                        .font(.system(size: UIScreen.main.bounds.width * 0.0375))
                        .padding(15)
                }.padding(15)
            }.animation(.spring())
                .offset(x: self.dragOffset.width)
                .gesture(DragGesture().onChanged{value in
                    if (value.translation.width > 0){
                        if (value.translation.width > 30) {
                            self.rightDrag = true
                        }
                    } else if (value.translation.width < 0) {
                        if (value.translation.width < -30) {
                            self.leftDrag = true
                        }
                    }
                    
                    self.dragOffset = value.translation}
                    .onEnded{value in
                        if (self.leftDrag) {
                            self.forward()
                        } else if (self.rightDrag) {
                            self.back()
                        }
                        self.leftDrag = false
                        self.rightDrag = false
                        self.dragOffset = .zero
                })
            Group() {
                HStack() {
                    Spacer()
                    Button(action: self.dislike) {
                        Image("dislike").resizable()
                            .frame(width: UIScreen.main.bounds.width * 0.06, height: UIScreen.main.bounds.width * 0.06)
                            .foregroundColor(Color.primary)
                            .padding()
                        
                        }.frame(minWidth: 0, maxWidth: .infinity)
                        .background(Capsule().fill(self.dislikeSelected ? Color("ourPink") : Color("bg")).foregroundColor(Color("ourPink")).overlay(Capsule().stroke(lineWidth: 2).foregroundColor(Color("ourPink"))))
                    Spacer()
                    Button(action: self.like) {
                        Image("like").resizable()
                            .frame(width: UIScreen.main.bounds.width * 0.06, height: UIScreen.main.bounds.width * 0.06)
                            .foregroundColor(Color.primary)
                            .padding()
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                    .background(Capsule().fill(self.likeSelected ? Color("ourPink") : Color("bg")).foregroundColor(Color("ourPink")).overlay(Capsule().stroke(lineWidth: 2).foregroundColor(Color("ourPink"))))
                    Spacer()
                }.padding(15)
            }
            VStack{
                DescriptionBanner().padding([.top,.bottom], 10)
            }
        }
    }
    
    func forward() {
        if (self.futureAvailable) {
            self.selectedDate = self.selectedDate! + TimeInterval(60.0 * 60 * 24)
            self.setPosition(date: self.selectedDate!)
        }
    }
    func back() {
        if (self.pastAvailable) {
            self.selectedDate = self.selectedDate! - TimeInterval(60.0 * 60 * 24)
            self.setPosition(date: self.selectedDate!)
        }
    }
}
