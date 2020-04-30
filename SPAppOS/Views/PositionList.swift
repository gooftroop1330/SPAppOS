//
//  PositionList.swift
//  SPAppOS
//
//  Created by John C Harrison on 04/29/2020.
//  Copyright © 2020 Preston Smith. All rights reserved.
//

import SwiftUI

struct PositionList: View {
    
    @Binding var selectedPosition: Position?
    @Binding var positionArray: [(Position, Date)]
    @Binding var selectedDate: Date?
    @Binding var showList: Bool
    @Binding var likeSelected: Bool
    @Binding var dislikeSelected: Bool
    @Binding var futureAvailable: Bool
    @Binding var pastAvailable: Bool
    
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 15) {
            
            VStack(alignment: .center) {
                Text("Positions").fontWeight(.light).font(.system(size: UIScreen.main.bounds.width * 0.05))
                        
                Divider()
                
                ScrollView{
                    VStack(alignment: .leading, spacing: 15){
                        ForEach(self.positionArray, id: \.0) { pos, date in
                            Group{
                                Button(action: {self.setPosition(date: date, pos: pos)}){
                                    Text(pos.positionName!.description.capitalized).font(.system(size: UIScreen.main.bounds.width * 0.03)).fontWeight(.light).foregroundColor(Color.primary)
                                }.padding(.leading, 15)
                                Divider()
                            }
                            
                        }
                    }
                }
            }.padding(.top, 15)
            
            Divider()
            VStack(alignment: .center) {
                Text("Favorites").fontWeight(.light).font(.system(size: UIScreen.main.bounds.width * 0.05))
                Divider()
                
                ScrollView{
                    VStack(alignment: .leading, spacing: 15){
                        ForEach(self.positionArray, id: \.0) { pos, date in
                            Group{
                                if(pos.like == 1){
                                    Button(action: {self.setPosition(date: date, pos: pos)}){
                                        Text(pos.positionName!.description.capitalized).font(.system(size: UIScreen.main.bounds.width * 0.03)).fontWeight(.light).foregroundColor(Color("ourPink"))
                                    }.padding(.leading, 15)
                                    Divider()
                                }
                            }
                        }
                    }
                }
            }.padding(.top, 15)
        }
    }
    
    func setPosition(date: Date, pos: Position) {
        self.selectedDate = date
        self.selectedPosition = pos
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
        } else if (date == Date(timeIntervalSinceReferenceDate: 599529600).addingTimeInterval(60.0 * 60 * 24 * Double(self.positionArray.count - 1))) {
            self.futureAvailable = false
        }
        self.showList.toggle()
    }
    
}
