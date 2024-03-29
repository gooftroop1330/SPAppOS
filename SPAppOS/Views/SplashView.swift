//
// Created by John C Harrison on 03/28/2020.
// Copyright (c) 2020 Preston Smith. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    
    // Fetch Core Data and create MOC
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Position.entity(), sortDescriptors: []) var positions: FetchedResults<Position>
    @FetchRequest(entity: PositionDates.entity(), sortDescriptors: []) var posDates: FetchedResults<PositionDates>
    
    @Binding var currView: String
    @Binding var positionDictionary: [Date : Position]
    @Binding var positionArray: [(Position, Date)]
    
    
    //ONLY FOR TESTING PURPOSES - DELETES ALL MOC DATA
    func deleteCoreStuff() {
        for deleteThis in positions {
            self.moc.delete(deleteThis)
        }
        for deleteThese in posDates {
            self.moc.delete(deleteThese)
        }
        try? self.moc.save()
    }
    
    // Self explanatory
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
    
    // What it says, it does
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\"", with: "")
        return cleanFile
    }
    
    // CSV Parsing
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
    
    // It does what it says
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
    
    // Assigns dates and place Position objects in array
    func initialize() {
        
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
    
    //Checks to see if a Date 30 days in the future is populated with a Position
    func checkDateFound() -> Bool {
        let checkDate = createExtensionStartDate()
        
        for dates in posDates {
            if(dates.dateAssigned! == checkDate) {
                return true
            }
        }
        
        return false
    }
    
    //Creates a Date 30 days from today
    func createExtensionStartDate() -> Date {
        let timeTrimmer = 60.0 * 60 * 24
        let additionalDays = timeTrimmer * 30
        let toTrim = Date()
        
        var trim = toTrim.timeIntervalSince1970
        trim = trim - (trim.truncatingRemainder(dividingBy: timeTrimmer))
        
        let futureDate = Date(timeIntervalSince1970: (trim + additionalDays))
        
        return futureDate
    }
    
    
    //Loads Position data into State variables
    func loadData() {
        for posDate in posDates {
            innerLoop: for pos in positions {
                if (posDate.positionNum == pos.positionNum) {
                    self.positionDictionary[posDate.dateAssigned!] = pos
                    break innerLoop
                }
            }
        }
        makePositionArray()
    }
    
    func makePositionArray() {
        let lastDate = Date(timeIntervalSinceReferenceDate: 599529600).addingTimeInterval(60.0 * 60 * 24 * Double(self.positionDictionary.count - 1))
        for i in 0...399 {
            let newPosIndex: (Position, Date) = (self.positionDictionary[lastDate.addingTimeInterval(60.0 * 60.0 * -24 * Double(i))]!, lastDate.addingTimeInterval(60.0 * 60.0 * -24 * Double(i)))
            self.positionArray.append(newPosIndex)
        }
        let sorted = self.positionArray.sorted(by: {$0.0.positionName!.lowercased() < $1.0.positionName!.lowercased()})
        self.positionArray = sorted
    }

    //Adds 400 new populated days
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
    
    var body: some View {
        VStack(){
            ActivityIndicator().frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.width * 0.5).foregroundColor(Color("ourPink")).onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    //DELETE THIS LINE BEFORE DEPLOYING
                    //self.deleteCoreStuff()
                    if (self.positions.count == 0) {
                        self.initialize()
                    } else if (!self.checkDateFound()) {
                        while(!self.checkDateFound()) {
                            self.addNewDays()
                        }
                    }
                    self.loadData()
                    self.currView = "welcome"
                }
            })
            Text("Loading").foregroundColor(Color.primary).fontWeight(.thin).font(.system(size: UIScreen.main.bounds.width * 0.07))
            
        }
    }
}

