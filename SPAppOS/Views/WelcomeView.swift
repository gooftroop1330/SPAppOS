//
//  WelcomeView.swift
//  SPAppOS
//
//  Created by John C Harrison on 03/28/2020.
//  Copyright © 2020 Preston Smith. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var currView: String
    @Binding var selectedPosition: Position?
    @Binding var positionArray: [Position]
    @Binding var popPositionArray: [PositionDates]
    
    func setInitialPosition() {
        let today = trimTime(toBeTrimmed: createStartDate())
        mainLoop: for pop in popPositionArray {
            if (pop.dateAssigned == today) {
                for pos in positionArray {
                    if (pos.positionNum == pop.positionNum) {
                        self.selectedPosition = pos
                        break mainLoop
                    }
                }
            }
        }
    }
    
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
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                WelcomeBanner()
                Spacer()
                Image("dsp").resizable().frame(width:312.0,height:312.0).shadow(radius: 10)
                Button(action: {withAnimation {
                    self.setInitialPosition()
                    self.currView = "position"
                    }}) {
                        Text("Let's Get It On")
                            .font(.title)
                            .fontWeight(.thin)
                            .foregroundColor(Color(red: 237/255, green: 119/255, blue: 229/255))
                            .multilineTextAlignment(.center)
                            .frame(width: 200.0, height: 50.0)
                    }
                Spacer()
            }
        }
    }
}

