//
// Created by John C Harrison on 03/28/2020.
// Copyright (c) 2020 Preston Smith. All rights reserved.
//

import SwiftUI

struct BadgeBackground: View{

    var body: some View {
        GeometryReader { geometry in
            Path { path in

                var width: CGFloat = min(geometry.size.width, geometry.size.height)
                let height = width
                let xScale: CGFloat = 0.832
                let xOffset = (width * (1.0 - xScale)) / 2.0
                width *= xScale

                path.move(
                        to: CGPoint(
                                x: xOffset + width * 0.95,
                                y: height * (0.20 + HexagonParameters.adjustment)
                        )
                )

                HexagonParameters.points.forEach {
                    path.addLine(
                            to: .init(
                                    x: xOffset + width * $0.useWidth.0 * $0.xFactors.0,
                                    y: height * $0.useHeight.0 * $0.yFactors.0
                            )
                    )

                    path.addQuadCurve(
                            to: .init(
                                    x: xOffset + width * $0.useWidth.1 * $0.xFactors.1,
                                    y: height * $0.useHeight.1 * $0.yFactors.1
                            ),
                            control: .init(
                                    x: xOffset + width * $0.useWidth.2 * $0.xFactors.2,
                                    y: height * $0.useHeight.2 * $0.yFactors.2
                            )
                    )
                }

            }.fill(LinearGradient (
                    gradient: Gradient(colors: [Self.gradientStart, Self.gradientEnd, Self.gradientStart]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
            )).aspectRatio(1, contentMode: .fit)
        }.background(Color.black).edgesIgnoringSafeArea(.all)
    }
    static let gradientStart = (Color(red: 237/255, green: 119/255, blue: 229/255))
    static let gradientEnd = (Color(red: 240/255, green: 180/255, blue: 220/255))
}

