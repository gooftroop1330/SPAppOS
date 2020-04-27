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
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                WelcomeBanner()
                Spacer()
                Image("dsp").resizable().frame(width:312.0,height:312.0).shadow(radius: 10)
                Button(action: {withAnimation {
                    self.currView = "dsp"
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

