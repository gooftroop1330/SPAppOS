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
            HStack(alignment: .center, spacing: 15.0){
                ForEach(0..<7) { index in
                    Capsule()
                        .frame(width: geometry.size.width / 10, height: geometry.size.height / 2)
                        .scaleEffect(x: 1, y:!self.isAnimating ? 0.75 : 1.25, anchor: .bottom)
                        .animation(Animation
                            .timingCurve(0.5, Double(index) / 4, 0.1, 1, duration: 1.25)
                            .repeatForever(autoreverses: true))
                }
            }
            
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            self.isAnimating = true
        }
        
    }
}

