//
//  PositionView.swift
//  SPAppOS
//
//  Created by Preston Smith on 4/27/20.
//  Copyright © 2020 Preston Smith. All rights reserved.
//

import SwiftUI

struct PositionView: View {
    
    @Binding var currView: String
    @Binding var selectedPosition: Position?
    @Binding var positionArray: [Position]
    @Binding var popPositionArray: [PositionDates]
    
    var body: some View {
        VStack() {
            if (selectedPosition != nil) {
                Text("Position Num: " + selectedPosition!.positionNum.description).foregroundColor(Color.black)
                Text("Name: " + selectedPosition!.positionName!).foregroundColor(Color.black)
                Text("Description: " + selectedPosition!.positionDescription!).foregroundColor(Color.black)
                Text("Image: " + selectedPosition!.positionImage!).foregroundColor(Color.black)
            } else {
                Text("Shit").foregroundColor(Color.black)
            }
        }
    }
}
