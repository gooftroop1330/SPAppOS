//
// Created by John C Harrison on 03/28/2020.
// Copyright (c) 2020 Preston Smith. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    @State var spin3D_y = false

    var badgeSymbols: some View {
        BadgeSymbol().opacity(0.9)
                .rotation3DEffect(
                        .degrees(spin3D_y ? 180 : 1),
                        axis: (
                                x: 0,
                                y: spin3D_y ? 1: 0,
                                z: 0)).animation(Animation.easeOut(duration: 1).repeatForever(autoreverses: false))
                                .onAppear(){
                                    self.spin3D_y.toggle()

                                }
    }

    var body: some View {
        ZStack{
            BadgeBackground().animation(.easeOut(duration: 4.5))
            GeometryReader { geometry in
                self.badgeSymbols
                        .scaleEffect(1.5 / 2.0, anchor: .top)
                        .position(x: geometry.size.width / 2.0, y: (3.6 / 4.0) * geometry.size.height)

            }
        }
    }
}

