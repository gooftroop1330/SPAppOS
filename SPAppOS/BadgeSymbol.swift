//
// Created by John C Harrison on 03/28/2020.
// Copyright (c) 2020 Preston Smith. All rights reserved.
//

import SwiftUI

struct BadgeSymbol: View {
    static let symbolColor1 = Color(red: 20 / 255, green: 20 / 255, blue: 20 / 255)
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = min(geometry.size.width, geometry.size.height)
                let height = width * 0.75
                let spacing = width * 0.005
                let middle = width / 2
                let topWidth = 0.24 * width
                let topHeight = 0.4 * height

                path.addLines([
                    CGPoint(x: middle, y: spacing),
                    CGPoint(x: middle - topWidth, y: topHeight - spacing),
                    CGPoint(x: middle, y: topHeight / 2 + spacing),
                    CGPoint(x: middle + topWidth, y: topHeight - spacing),
                    CGPoint(x: middle, y: spacing)
                ])

                path.move(to: CGPoint(x: middle, y: topHeight / 2 + spacing * 3))
                path.addLines([
                    CGPoint(x: middle - topWidth, y: topHeight + spacing),
                    CGPoint(x: middle, y: topHeight / 2 + spacing * 6),
                    CGPoint(x: middle + topWidth, y: topHeight + spacing),
                    CGPoint(x: middle, y: topHeight / 2 * 2.6)
                ])
            }.fill(Self.symbolColor1)
        }
    }
}
