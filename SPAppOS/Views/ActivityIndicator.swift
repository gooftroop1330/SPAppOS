//
//  ActivityIndicator.swift
//  SPAppOS
//
//  Created by John C Harrison on 04/28/2020.
//  Copyright © 2020 Preston Smith. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: View {

    @State private var isAnimating: Bool = false
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            ForEach(0..<5) { index in
                Group {
                    Capsule()
                        .frame(width: geometry.size.width / 8, height: geometry.size.height / 2)
                        .offset(x: geometry.size.width / 5 - geometry.size.height / 2)
                    }.frame(width: geometry.size.width, height: geometry.size.height)
                    .padding(15)
                    .scaleEffect(!self.isAnimating ? 1.0 : 0.5, anchor: .leading)
                    .animation(Animation
                        .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
                        .repeatForever(autoreverses: true))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            self.isAnimating = true
        }
    }
}

struct Line: View {
    var body: some View{
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 100))
            path.addLine(to: CGPoint(x: 20, y: 100))
            path.addLine(to: CGPoint(x: 20, y: 0))
        }
    }
    
}
