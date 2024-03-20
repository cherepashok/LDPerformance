//
//  SQLite.swift
//  Landing Performance
//
//  Created by Mikhail Stepanov on 20.05.2023.
//


import SQLite
import Foundation






enum AutobrakeType: String, CaseIterable, Identifiable {
    case Manual, Low
    var id: Self { self }
}

enum Condition: String, CaseIterable, Identifiable {
    case DRY, GOOD, GOOD_TO_MEDIUM, MEDIUM, MEDIUM_TO_POOR, POOR
    var id: Self { self }
}


enum AircraftType: String, CaseIterable, Identifiable {
    case A321_1A33, A321_1A32, A320
    var id: Self { self }
}

enum Flaps: String, CaseIterable, Identifiable {
    case FULL, F3
    var id: Self { self }
}


enum YESNO: String, CaseIterable, Identifiable {
    case YES, NO
    var id: Self { self }
}

class PerformanceDatabase {
    private var db_path : String
    
    var failures : [Failure] = []

    public init(){
        let fileName  = "landing_performance_test_";
        let suffix = "db";
        db_path = "";
        
        if let path = Bundle.main.path(forResource: fileName, ofType: suffix) {
            // use path
            print(path)
            db_path = path
        }
    }
    
    func getVapp(Weight: String, Flaps: String, AircraftType:String, Athr: String, Headwind: Double, deltaVref: String)->Int{
        var vapp : Double
        vapp = 0
        
        do {
            let db = try Connection(db_path)
            let VAPP = Table("VAPP")
            
            let vls    = Expression<Int64>("Vls")
            let weight = Expression<Double>("Weight")
            let flaps  = Expression<String>("Flaps")
            let atype  = Expression<String>("aircraftType")
            
            let dVref = Double(deltaVref)!
            
            var flaps_ = Flaps
            if(dVref > 0)
            {
                flaps_ = "FULL"
            }
            
            let query = VAPP.select(weight,vls).filter(flaps == flaps_).filter(atype == AircraftType).order(weight)

            
            //let query = VAPP.select(weight,vls).filter(flaps == Flaps).filter(atype == AircraftType).order(weight)
            
            let curWeight = Double(Weight)!
            var nextW = 0.0, prevW = 0.0, nextV = 0.0, prevV=0.0
            
            for row in try db.prepare(query) {
                //print(row)
                prevW = nextW
                prevV = nextV
                nextV = Double(row[vls])
                nextW = Double(row[weight])
                if curWeight < nextW {
                    break
                }
            }
            
            print(nextW,nextV,prevW,prevV);
            
            let vls_ = Double(ceil(prevV + (curWeight - prevW) * (nextV - prevV)/(nextW - prevW)));
            
            vapp = vls_
            
            let headwind = Headwind
            var dVathr = 5.0

            if Athr !=  YESNO.YES.rawValue {
                dVathr = 0.0
            }
            //vapp = vapp + Int(ceil(max(min(headwind/3,15),dVathr)))
            
            var appcor = 0.0
            
            if (dVref <= 15.0){
                appcor = Double(ceil(max(min(headwind/3,15),dVathr)))
                if((appcor+dVref) > 25.0){
                    appcor = 25.0
                }
                //appcor = min(appcor+dVref,25.0);
            } else if (dVref < 25){
                appcor = Double(ceil(max(min(headwind/3,10),0)))
                if((appcor+dVref) > 25.0){
                    appcor = 25.0
                }

            }
            
            vapp = vls_ + dVref + appcor

        } catch {
            print (error)
        }

        return Int(vapp)
    }
    
    func getHeadwind(strWindDirection: String, strVelocity: String, strGust: String, strRunwayCourse: String) -> Double
    {
        
        let windDirection = Double(strWindDirection) ?? 0
        let velocity      = Double(strVelocity) ?? 0
        let gust          = Double(strGust) ?? 0
        let runwayCourse  = Double(strRunwayCourse) ?? 0
        let pi = Double.pi
        
        let cos_a = sin(2*pi*windDirection/360)*sin(2*pi*runwayCourse/360) + cos(2*pi*windDirection/360)*cos(2*pi*runwayCourse/360)
        
        return max(velocity,gust) * cos_a
    }
    func getCrosswind(strWindDirection: String, strVelocity: String, strGust: String, strRunwayCourse: String)->Double
    {
        let windDirection = Double(strWindDirection) ?? 0
        let velocity      = Double(strVelocity) ?? 0
        let gust          = Double(strGust) ?? 0
        let runwayCourse  = Double(strRunwayCourse) ?? 0
        let pi = Double.pi

        let cos_a = sin(2*pi*windDirection/360)*sin(2*pi*runwayCourse/360) + cos(2*pi*windDirection/360)*cos(2*pi*runwayCourse/360)
        
        return max(velocity,gust) * sqrt(1 - cos_a * cos_a)
    }
    
    func getACTypes() -> [String]
    {
        var acs: [String] = []

        do {
            let db = try Connection(db_path)
            let sql = "SELECT aircraftType FROM Distance GROUP BY aircraftType;"
            for row in try db.prepare(sql){
                acs.append(row[0] as! String)
            }

        } catch {
            print(error)
        }
        return acs;
    }

//    func getInterpolatedDistance(ac_type:String, flaps: String, condition: String, elevation:String, weight:String) -> Double
//    {
//        var lnd_distance: Double;
//        lnd_distance = 1;
//
//        var elevation_ = (0,0)
//        var weight_   = (0,0)
//        var e = Int(elevation)!
//        var w = Int(weight)!
//
//        do {
//            let db = try Connection(db_path)
//            var sql = " SELECT Elevation"
//                    + " FROM Distance"
//                    + " WHERE Distance.aircraftType = \'"+ac_type+"\' "
//                    + " AND Distance.flaps = \'"+flaps+"\'"
//                    + " AND Distance.Condition = \'"+condition + "\'"
//                    + " GROUP BY Elevation;"
//
//            print(sql)
//
//            for row in try db.prepare(sql){
//
//                if (nil != row[0])
//                {
//                    elevation_.1 = elevation_.0
//                    elevation_.0 = Int((row[2]) as! Int)
//
//                    if ((e <= elevation_.1) && (e >= elevation_.0)) {
//                        break
//                    }
//                }
//            }
//
//            sql = " SELECT Weight"
//                    + " FROM Distance"
//                    + " WHERE Distance.aircraftType = \'"+ac_type+"\' "
//                    + " AND Distance.flaps = \'"+flaps+"\'"
//                    + " AND Distance.Condition = \'"+condition + "\'"
//                    + " GROUP BY Weight;"
//
//            print(sql)
//
//            for row in try db.prepare(sql){
//                if (nil != row[0])
//                {
//                    weight_.1 = weight_.0
//                    weight_.0 = Int((row[2]) as! Int)
//
//                    if ((w <= weight_.1) && (w >= weight_.0)) {
//                        break
//                    }
//                }
//            }
//
//            sql = " SELECT Elevation, Weight, Distance"
//                    + " FROM Distance"
//                    + " WHERE Distance.aircraftType = \'"+ac_type+"\' "
//                    + " AND Distance.flaps = \'"+flaps+"\'"
//                    + " AND Distance.Condition = \'"+condition + "\';"
//                    + " WHERE (Elevation = \(elevation_.0) OR Elevation = \(elevation_.1))"
//                    + " AND   (Weight = \(weight_.0)       OR Weight = \(weight_.1))"
//                    + " GROUP BY Elevation"
//
//            print(sql)
//
//
//            var points = [(Int,Int,Double)]()
//            for row in try db.prepare(sql){
//                let p = (row[0] as! Int, row[1] as! Int,row[2] as! Double)
//                points.append(p)
//            }
//
//            lnd_distance = mine(points:points)
//
//        } catch {
//            print (error)
//        }
//        return lnd_distance;
//    }
//
//    func mine(points: [(Int,Int,Double)]) -> Double{
//
//        //interpolation()
//
//        return 0
//    }
    



    
    func getDistance(ac_type:String, flaps: String, condition: String, elevation:String, weight:String) -> Double
    {
        var lnd_distance: Double;
        lnd_distance = 1;

        
        do {
            let db = try Connection(db_path)
            let sql = "SELECT Elevation, min(Weight), Distance.Distance"
                    + " FROM Distance"
                    + " WHERE Distance.aircraftType = \'"+ac_type+"\' "
                    + " and Distance.flaps = \'"+flaps+"\'"
                    + " and Distance.Condition = \'"+condition + "\'"
                    + " and Elevation >="+elevation+" and Weight >= "+weight+";"
            
            print(sql)
            for distance in try db.prepare(sql){
                print(distance[0] ??  0,distance[1] ?? "67.4" ,distance[2] ??  "1200")
                if (nil != distance[2])
                {
                    let ww = distance[1] as! Double;
                    lnd_distance = Double((distance[2]) as! Int64)
                }
            }
                    
        } catch {
            print (error)
        }
        return lnd_distance;
    }
    
    
//    func getDistance_(ac_type:String, flaps: String, condition: String, elevation:String, weight:String) -> Double{
//        let elevation = Expression<String>("Elevation");
//        let weight    = Expression<Double>("Weight");
//        let
//
//
//    }
    
    func interpolation(x0: Double,x1: Double,y0: Double,y1: Double,x2: Double) -> Double {
        return (y1-y0) * (x2-x0)/(x1-x0) + y0
    }
    
    func getCorrectedDistance(ac_type:String, flaps: String, condition: String, elevation:String, t:String, weight:String, headwind: Double, reverser: String, autobrk: String, penalty: String) -> Double {
        var ld_corrected = 0.0;
        do {
            let db = try Connection(db_path)
            let Adjustment = Table("Adjustment")
            
            let dslope     = Expression<Double>("downslope")
            let uslope     = Expression<Double>("upslope")
            let twind      = Expression<Double>("tailwind")
            let hwind      = Expression<Double>("headwind")
            let isa        = Expression<Double>("isa")
            let reverse    = Expression<Double>("reverse")
            let omaxbrake  = Expression<Double>("ovw_max_brake")
            let olowbrake  = Expression<Double>("ovw_low_brake")
            let lowbrake   = Expression<Double>("autobrake_low")
            
            let rwconditon = Expression<String>("rw_condition")
            let flapsconf  = Expression<String>("flaps_settings")
            let atype      = Expression<String>("ac_type")
            
            let temperature   = Double(t)!
            let elev          = Double(elevation)!
            let penaltyfactor = Double(penalty)!
            
            
            let ldist = getDistance(
                ac_type   : ac_type,
                flaps     : flaps,
                condition : condition,
                elevation : elevation,
                weight    : weight);
            
            let query = Adjustment.select(dslope,uslope,twind,hwind,isa,reverse,omaxbrake,olowbrake,lowbrake).filter(flaps == flapsconf).filter(atype == ac_type).filter(rwconditon == condition)
            
            //print(query)
            
            ld_corrected = ldist
            
            print("from DB:"+String(ld_corrected))
            
            for row in try db.prepare(query) {
                let tw  = row[twind]
                let hw  = row[hwind]
                let rev = row[reverse]
                let low = row[lowbrake]
                let tcf = row[isa]
                
                if(headwind > 0){
                    ld_corrected = ld_corrected + hw * headwind
                } else {
                    ld_corrected = ld_corrected - tw * headwind
                }
                
                print("wind:"+String(ld_corrected))
                
            
                
                if reverser == YESNO.YES.rawValue{
                    ld_corrected = ld_corrected - rev * 2
                }
                
                print("reverser:"+String(ld_corrected))
         	       
                let isa_t = 15 - elev/500;
                
                if ((temperature - isa_t) > 0)  {
                    ld_corrected = ld_corrected +  tcf * min((temperature - isa_t), 40);
                }
                
                //let a = Double("") ?? 0
            
                
                print("temperature:"+String(ld_corrected))
                
                if autobrk == AutobrakeType.Low.rawValue{
                    ld_corrected = ld_corrected * low
                }
                print("auto brk:"+String(ld_corrected))
                
                ld_corrected = ld_corrected * 1.15 * (penaltyfactor)

            }
            
        } catch {
            print (error)
        }
        return ld_corrected
    }
    
}
