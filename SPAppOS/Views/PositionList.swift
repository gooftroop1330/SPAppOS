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
    @Binding var positionDictionary: [Date : Position]
    @Binding var selectedDate: Date?
    @Binding var showList: Bool
    @State var dates: [Date]
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 15) {
            
            VStack(alignment: .center) {
                Text("Positions").fontWeight(.thin).font(.system(size: UIScreen.main.bounds.width * 0.05))
                        
                Divider().padding([.leading,.trailing], 25)
                
                ScrollView{
                    VStack(alignment: .leading, spacing: 15){
                        ForEach(self.dates, id: \.self) { date in
                            Group{
                                Button(action: {self.selectPosition(date: date, pos: self.positionDictionary[date]!)}){
                                    Text(self.positionDictionary[date]!.positionName!.description).font(.system(size: UIScreen.main.bounds.width * 0.03)).fontWeight(.thin).foregroundColor(Color.primary)
                                }.padding(.leading, 15)
                                Divider()
                            }
                            
                        }
                    }
                }
            }.padding(.top, 15)
            
            Divider()
            VStack(alignment: .center) {
                Text("Favorites").fontWeight(.thin).font(.system(size: UIScreen.main.bounds.width * 0.05))
                Divider().padding([.leading,.trailing], 25)
                
                ScrollView{
                    VStack(alignment: .leading, spacing: 15){
                        ForEach(self.dates, id: \.self) { date in
                            Group{
                                if(self.positionDictionary[date]!.like == 1){
                                    Button(action: {self.selectPosition(date: date, pos: self.positionDictionary[date]!)}){
                                        Text(self.positionDictionary[date]!.positionName!.description).font(.system(size: UIScreen.main.bounds.width * 0.03)).fontWeight(.thin).foregroundColor(Color("ourPink"))
                                    }.padding(.leading, 15)
                                    Divider()
                                }
                            }
                        }
                    }
                }
            }.padding(.top, 15)
        }.onAppear(){
            self.positionDictionary.forEach{ (date, position) in
                self.dates.append(date)
            }
            
        }
    }
    
    func selectPosition(date: Date, pos: Position) {
        self.selectedDate = date
        self.selectedPosition = pos
    }
    
}


