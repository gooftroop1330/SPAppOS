//
//  ContentView.swift
//  SPAppOS
//
//  Created by Preston Smith on 3/27/20.
//  Copyright © 2020 Preston Smith. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Position.entity(), sortDescriptors: []) var positions: FetchedResults<Position>
    @FetchRequest(entity: PositionDates.entity(), sortDescriptors: []) var posDates: FetchedResults<PositionDates>
    
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\"", with: "")
        return cleanFile
    }
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columnIndexer = row.split(separator: ",", maxSplits: 2, omittingEmptySubsequences: false)
            let columns: [String] = [columnIndexer[1].description ,columnIndexer[2].description]
            result.append(columns)
        }
        result.remove(at: 0)
        return result
    }
    
    func randomize(seed: Int) -> [Int] {
        var firstShuffle = [Int]()
        var lastShuffle = [Int]()
        
        let base = (seed / 10) % 400
        
        var a = 0
        var b = base - 1
        var c = base
        var d = 399
        
        var counter = 0
        
        let aPartition = (b - a) / 2
        var aCounter = 0
        let bPartition = (b - a) / 2
        var bCounter = 0
        let cPartition = (d - c) / 2
        var cCounter = 0
        let dPartition = (d - c) / 2
        var dCounter = 0
        
        a = a + aPartition
        d = d - dPartition
        
        while (counter < 400) {
            if (cCounter <= cPartition) {
                firstShuffle.append(c)
                c += 1
                cCounter += 1
                counter += 1
            }
            if (dCounter <= dPartition) {
                firstShuffle.append(d)
                d += 1
                dCounter += 1
                counter += 1
            }
            if (aCounter <= aPartition) {
                firstShuffle.append(a)
                a -= 1
                aCounter += 1
                counter += 1
            }
            if (bCounter <= bPartition) {
                firstShuffle.append(b)
                b -= 1
                bCounter += 1
                counter += 1
            }
        }
        
        a = 0 + aPartition
        b = base - 1
        c = base
        d = 399 - dPartition
        
        counter = 0
        aCounter = 0
        bCounter = 0
        cCounter = 0
        dCounter = 0
        
        while (counter < 400) {
            if (cCounter <= cPartition) {
                lastShuffle.append(firstShuffle[c])
                c += 1
                cCounter += 1
                counter += 1
            }
            if (dCounter <= dPartition) {
                lastShuffle.append(firstShuffle[d])
                d += 1
                dCounter += 1
                counter += 1
            }
            if (aCounter <= aPartition) {
                lastShuffle.append(firstShuffle[a])
                a -= 1
                aCounter += 1
                counter += 1
            }
            if (bCounter <= bPartition) {
                lastShuffle.append(firstShuffle[b])
                b -= 1
                bCounter += 1
                counter += 1
            }
        }
        
        return lastShuffle
        
    }
    
    func intitalize() {
        
        let data = readDataFromCSV(fileName: "rescraped", fileType: ".csv")
        let allPositions = csv(data: data!)
        
        let startDate = Date(timeIntervalSinceReferenceDate: 599529600) //Jan 1, 2020
        let day = 24 * 60 * 60.0
        
        let randomDay = randomize(seed: 2020)
        
        var i: Int16 = 1
        
        for position in allPositions {
            let newPosition = Position(context: self.moc)
            let posDate = PositionDates(context: self.moc)
            
            newPosition.id = UUID()
            newPosition.positionName = position[0].split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)[1].description
            newPosition.positionDescription = position[1]
            newPosition.like = 0
            newPosition.positionNum = i
            newPosition.positionImage = "pos" + i.description
            
            posDate.id = UUID()
            posDate.positionNum = i
            posDate.dateAssigned = startDate.addingTimeInterval((Double(randomDay[Int(i) - 1]) * day))
            
            i += 1
            
            try? self.moc.save()
        }
    }
    
    func addNewDays() {
        let day = 24 * 60 * 60.0
        
        let randomDay = randomize(seed: posDates.count)
        
        let startDate = createExtensionStartDate()
        
        var i = 0
        
        for pos in positions {
            let newPosDate = PositionDates(context: self.moc)
            newPosDate.id = UUID()
            newPosDate.positionNum = pos.positionNum
            newPosDate.dateAssigned = startDate.addingTimeInterval((Double(randomDay[i]) * day))

            i += 1
            
            try? self.moc.save()
        }
    }
    
    func checkDateFound() -> Bool {
        let checkDate = createExtensionStartDate()
        
        for dates in posDates {
            if(dates.dateAssigned! == checkDate) {
                return true
            }
        }
        return false
    }
    
    func createExtensionStartDate() -> Date {
        let timeTrimmer = 60.0 * 60 * 24
        let additionalDays = timeTrimmer * 30
        let toTrim = Date()
        
        var trim = toTrim.timeIntervalSince1970
        trim = trim - (trim.truncatingRemainder(dividingBy: timeTrimmer))
        
        let futureDate = Date(timeIntervalSince1970: (trim + additionalDays))
        
        return futureDate
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
    
    func deleteCoreStuff() {
        for deleteThis in positions {
            self.moc.delete(deleteThis)
        }
        for deleteThese in posDates {
            self.moc.delete(deleteThese)
        }
        try? self.moc.save()
    }
    
    
    
    func getPositionInfo(findDate: Date) -> [String] {
        var currPos: Position = Position(context: self.moc)
        for posDate in posDates {
            if (posDate.dateAssigned == findDate) {
                for position in positions {
                    if (posDate.positionNum == position.positionNum) {
                        currPos = position
                        self.selectedPosition = position
                    }
                }
            }
        }
        return [currPos.positionName!, currPos.positionDescription!, currPos.positionImage!]
    }
    
    @State var showSplash = true
    @State var currView = "splash"
    @State var selectedDate = Date()
    @State var selectedPosition: Position?
    @State var selectedPosInfo = [String]()
    @State var singleIsPresented = false
    
    var rkm = RKManager(calendar: Calendar.current, minimumDate: Date(timeIntervalSinceReferenceDate: 599529600).addingTimeInterval(60*60*24), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    func prepDate(toBePrepped: Date) -> String {
        let firstStep = toBePrepped.description.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: false)
        let secondStep = firstStep.description.split(separator: "-", maxSplits: 2, omittingEmptySubsequences: false)
        let thirdStep = secondStep[2].description.split(separator: "\"", maxSplits: 1, omittingEmptySubsequences: false)
        let final = secondStep[1].description + "-" + thirdStep[0].description + "-" + secondStep[0].description.suffix(4)
        return final
    }
    
    func dislike() {
        print("disliked")
    }
    
    func like() {
        print("liked")
    }
    
    var body: some View {
        ZStack {
            SplashView().opacity(showSplash ? 1 : 0).onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.3) {
                    withAnimation() {
                     self.deleteCoreStuff()
                        if (self.positions.count == 0) {
                            self.intitalize()
                        }
                        else if (!self.checkDateFound()) {
                            while (!self.checkDateFound()) {
                                self.addNewDays()
                            }
                        }
                        self.selectedDate = self.createStartDate()
                        self.selectedPosInfo = self.getPositionInfo(findDate: self.selectedDate)
                        self.showSplash = false
                        self.currView = "welcome"
                    }
                }
            }
            if(self.currView == "welcome") {
                WelcomeView(currView: self.$currView)
            }
            if(self.currView == "dsp") {
                ZStack() {
                    Color.black.edgesIgnoringSafeArea(.all)
                    VStack(){
                        DSPBanner()
                        Spacer()
                        HStack() {
                        Text(prepDate(toBePrepped: self.selectedDate))
                            .foregroundColor(Color.white)
                            .bold()
                            .font(.system(size: 30.0))
                            .padding(.leading, 10)
                        Spacer()
                        Button(action: {
                            self.rkm.maximumDate = self.rkm.minimumDate.addingTimeInterval(60.0 * 60 * 24 * Double(self.posDates.count - 1))
                            self.singleIsPresented.toggle()
                            
                        }) {
                            Image("calendar-icon")
                                .resizable().frame(width: 30.0, height: 30.0)
                                .foregroundColor(Color(red: 237/255, green: 119/255, blue: 229/255))
                                .padding(.trailing, 10)
                        }
                        .padding()
                        .sheet(isPresented: self.$singleIsPresented, content: {
                            RKViewController(isPresented: self.$singleIsPresented, rkManager: self.rkm)
                                .onDisappear(){
                                    self.selectedDate = self.trimTime(toBeTrimmed: self.rkm.selectedDate)
                                    self.selectedPosInfo = self.getPositionInfo(findDate: self.selectedDate)
                            }})
                        }
                        Spacer()
                        Text(self.selectedPosInfo[0].capitalized)
                            .foregroundColor(Color.white)
                            .font(.system(size: 30))
                        Spacer()
                        Image(self.selectedPosInfo[2]).resizable().frame(width: 350.0, height: 200.0)
                        Spacer()
                        Text(self.selectedPosInfo[1])
                            .foregroundColor(Color.white)
                            .padding(5)
                        Spacer()
                    }
                    VStack() {
                        HStack() {
                            Button(action: dislike) {
                                Text("Dislike")
                            }
                            Button(action: like) {
                                Text("Like")
                            }
                        }
                    }
                }
            }
        }
    }
}


