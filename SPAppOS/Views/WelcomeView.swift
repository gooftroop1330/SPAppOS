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
    @Binding var selectedDate: Date?
    @Binding var positionArray: [Position]
    @Binding var popPositionArray: [PositionDates]
    
    func setInitialPosition() {
        let today = trimTime(toBeTrimmed: createStartDate())
        mainLoop: for pop in popPositionArray {
            if (pop.dateAssigned == today) {
                for pos in positionArray {
                    if (pos.positionNum == pop.positionNum) {
                        self.selectedPosition = pos
                        self.selectedDate = today
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
        VStack() {
            WelcomeBanner()
            Spacer()
            Image("dsp").resizable().frame(width:UIScreen.main.bounds.width * 0.7,height: UIScreen.main.bounds.width * 0.7).shadow(radius: 10)
            Button(action: {withAnimation {
                self.setInitialPosition()
                self.currView = "position"
                }}) {
                    Text("Let's Get It On")
                        .font(.title)
                        .fontWeight(.thin)
                        .foregroundColor(Color("ourPink"))
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.width - 75, height: 50.0)
                        .padding()
            }.background(Capsule().stroke(lineWidth: 2).foregroundColor(Color("ourPink")))
            Spacer()
        }
    }
}

