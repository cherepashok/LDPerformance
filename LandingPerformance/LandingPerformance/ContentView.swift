//
//  ContentView.swift
//  Landing Performance
//
//  Created by Mikhail Stepanov on 12.05.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var strLandingWeight: String = "0.0"
    @State private var strRunwayElevation: String = "0"
    @State private var strRunwayCourse: String = "0"
    @State private var strLandingDistance: String = ""
    @State private var strLandingDistanceNonFactored: String = ""

    
    @State private var strPenaltyFactor: String = "1.0"
    @State private var strDeltaVref: String = "0"

    @State private var strVapp: String = ""


    @State private var strDirection: String = "0"
    @State private var strVelocity: String = "0"
    @State private var strGust: String = "0"
    @State private var strOAT: String = "15"
    @State private var athr: Bool = true
    @State private var reverser: Bool = false

    

    @State private var selectedAutoBrake: AutobrakeType = .Low
    @State private var selectedCondition: Condition = .DRY
    @State private var selectedTypeCondition: AircraftType = .A320
    @State private var selectedFlapsCondition: Flaps = .F3
    @State private var selectedAthrCondition: YESNO = .YES
    @State private var selectedReverseCondition: YESNO = .NO
    
    //@Binding var systems: [System]

    //@State private var systems = System.sampleData
    
    var body: some View {
        
        VStack{
            List {
                // Eniroment
                Section("Weather"){
                        GeometryReader { metrics in
                            HStack{
                                Text("Wind direction")
                                    .frame(width: metrics.size.width * 0.7, alignment: .leading)
                                
                                TextField("Direction", text: $strDirection)
                                    .keyboardType(.decimalPad)
//                                    .onChange(of: $strDirection, perform: {
//                                        strDirection = "hui"
//                                    })
                                    .frame(width: metrics.size.width * 0.3, alignment: .leading)
                                    .multilineTextAlignment(.trailing)
                                    .textFieldStyle(.roundedBorder)
                                
//                                TextField("Velocity", text: $strVelocity)
//                                    .keyboardType(.phonePad)
//                                    .frame(width: metrics.size.width * 0.20, alignment: .leading)
//                                    .multilineTextAlignment(.trailing)
//                                    .textFieldStyle(.roundedBorder)
                                
//                                TextField("Gust", text: $strGust)
//                                    .keyboardType(.phonePad)
//                                    .frame(width: metrics.size.width * 0.20, alignment: .leading)
//                                    .multilineTextAlignment(.trailing)
//                                    .textFieldStyle(.roundedBorder)
                                    
                            }
                        }

                    GeometryReader { metrics in
                        HStack{
                            Text("Wind speed")
                                .frame(width: metrics.size.width * 0.7, alignment: .leading)
                            
                            TextField("Velocity", text: $strVelocity)
                                .keyboardType(.decimalPad)
                                .frame(width: metrics.size.width * 0.3, alignment: .leading)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.roundedBorder)
                            
//                                TextField("Gust", text: $strGust)
//                                    .keyboardType(.phonePad)
//                                    .frame(width: metrics.size.width * 0.20, alignment: .leading)
//                                    .multilineTextAlignment(.trailing)
//                                    .textFieldStyle(.roundedBorder)
                                
                        }
                    }
                    
                    GeometryReader { metrics in
                        HStack{
                            Text("Wind gust")
                                .frame(width: metrics.size.width * 0.7, alignment: .leading)
                            
//                            TextField("Velocity", text: $strVelocity)
//                                .keyboardType(.decimalPad)
//                                .frame(width: metrics.size.width * 0.3, alignment: .leading)
//                                .multilineTextAlignment(.trailing)
//                                .textFieldStyle(.roundedBorder)
                            
                                TextField("Gust", text: $strGust)
                                    .keyboardType(.phonePad)
                                    .frame(width: metrics.size.width * 0.30, alignment: .leading)
                                    .multilineTextAlignment(.trailing)
                                    .textFieldStyle(.roundedBorder)
                                
                        }
                    }

                        
                        
                        GeometryReader { metrics in
                            HStack{
                                Text("OAT")
                                    .frame(width: metrics.size.width * 0.70, alignment: .leading)
                                
                                
                                TextField("0", text: $strOAT)
                                    .keyboardType(.decimalPad)
                                    .frame(width: metrics.size.width * 0.30, alignment: .leading)
                                    .multilineTextAlignment(.trailing)
                                    .textFieldStyle(.roundedBorder)
                                    //.onChange(of: Equatable, perform: <#T##(Equatable) -> Void##(Equatable) -> Void##(_ newValue: Equatable) -> Void#>)
                            }
                        }
                        
                        Picker("Runway condition", selection: $selectedCondition) {
                            Text("Dry").tag(Condition.DRY)
//                            Text("Good").tag(Condition.GOOD)
//                            Text("Good to Medium").tag(Condition.GOOD_TO_MEDIUM)
//                            Text("Medium").tag(Condition.MEDIUM)
//                            Text("Medium to Poor").tag(Condition.MEDIUM_TO_POOR)
//                            Text("Poor").tag(Condition.POOR)
                        }
                    }
                // Runway
                Section("Runway"){
                    GeometryReader { metrics in
                        HStack{
                            Text("Runway elevation")
                                .frame(width: metrics.size.width * 0.70, alignment: .leading)
                            
                            //textField.leftView = plusLabel
                            //textField.leftViewMode = UITextFieldViewMode.Always
                            
                            
                            TextField("0", text: $strRunwayElevation)
                                .keyboardType(.decimalPad)
                                .frame(width: metrics.size.width * 0.30, alignment: .leading)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    
                    GeometryReader { metrics in
                        HStack{
                            Text("Runway course")
                                .frame(width: metrics.size.width * 0.70, alignment: .leading)
                            
                            
                            TextField("0", text: $strRunwayCourse)
                                .keyboardType(.decimalPad)
                                .frame(width: metrics.size.width * 0.30, alignment: .leading)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                }
                // Aircraft
                Section("Aircraft"){
                    Picker("Aircraft type", selection: $selectedTypeCondition) {
                        Text("A320neo").tag(AircraftType.A320)
                        Text("A321neo LEAP-1A32").tag(AircraftType.A321_1A33)
                        Text("A321neo LEAP-1A33").tag(AircraftType.A321_1A32)
                    }
                    
                    
                    Picker("Flaps", selection: $selectedFlapsCondition) {
                        Text("F3").tag(Flaps.F3)
                        Text("FULL").tag(Flaps.FULL)
                    }
                    
                    Picker("Reverser", selection: $selectedReverseCondition) {
                        Text("YES").tag(YESNO.YES)
                        Text("NO").tag(YESNO.NO)
                    }
                    
                    Picker("Autobrake", selection: $selectedAutoBrake) {
                        Text("LOW").tag(AutobrakeType.Low)
                        Text("Manual").tag(AutobrakeType.Manual)
                    }
                    
                    Picker("Autothrust", selection: $selectedAthrCondition) {
                        Text("YES").tag(YESNO.YES)
                        Text("NO").tag(YESNO.NO)
                    }
                    
                    GeometryReader { metrics in
                        HStack{
                            Text("Landing weight")
                                .frame(width: metrics.size.width * 0.70, alignment: .leading)
                            
                            TextField("64.7", text: $strLandingWeight)
                                .keyboardType(.decimalPad)
                                .frame(width: metrics.size.width * 0.30, alignment: .leading)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
//                    GeometryReader { metrics in
//                        HStack{
//                            Text("LD Penalty Factor")
//                                .frame(width: metrics.size.width * 0.70, alignment: .leading)
//
//                            TextField("1.0", text: $strPenaltyFactor)
//                                .keyboardType(.decimalPad)
//                                .frame(width: metrics.size.width * 0.30, alignment: .leading)
//                                .multilineTextAlignment(.trailing)
//                                .textFieldStyle(.roundedBorder)
//                        }
//                    }
                    
                }
                
                Section("Abnormal"){
                    
                    GeometryReader { metrics in
                        HStack{
                            Text("LD Penalty Factor")
                                .frame(width: metrics.size.width * 0.70, alignment: .leading)
                            
                            TextField("1.0", text: $strPenaltyFactor)
                                .keyboardType(.decimalPad)
                                .frame(width: metrics.size.width * 0.30, alignment: .leading)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.roundedBorder)
                        }
                    }

                    GeometryReader { metrics in
                        HStack{
                            Text("∆Vref")
                                .frame(width: metrics.size.width * 0.70, alignment: .leading)
                            
                            TextField("0", text: $strDeltaVref)
                                .keyboardType(.decimalPad)
                                .frame(width: metrics.size.width * 0.30, alignment: .leading)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    
                    NavigationStack{
                        NavigationLink(destination: SystemView()) {
                            Text("Add failure")
                        }
                    }
                }
                
                Section("Results"){
                    GeometryReader { metrics in
                        HStack{
                            
                            Text("Factored LD")
                                .bold()
                                .frame(width: metrics.size.width * 0.70, alignment: .leading)
                            
                            TextField("", text: ($strLandingDistance))
                                .disabled(true)
                                .bold()
                                .frame(width: metrics.size.width * 0.30, alignment: .leading)
                                .multilineTextAlignment(.trailing)
//                                .textFieldStyle(.roundedBorder)
                            
                        }
                    }
                    
                    GeometryReader { metrics in
                        HStack{
                            
                            Text("LD")
                                .bold()
                                .frame(width: metrics.size.width * 0.70, alignment: .leading)
                            
                            TextField("", text: ($strLandingDistanceNonFactored))
                                .disabled(true)
                                .bold()
                                .frame(width: metrics.size.width * 0.30, alignment: .leading)
                                .multilineTextAlignment(.trailing)
//                                .textFieldStyle(.roundedBorder)
                            
                        }
                    }


                    GeometryReader { metrics in
                        HStack{
                            
                            Text("Vapp")
                                .bold()
                                .frame(width: metrics.size.width * 0.70, alignment: .leading)
                            
                            TextField("", text: ($strVapp))
                                .disabled(true)
                                .bold()
                                .frame(width: metrics.size.width * 0.30, alignment: .leading)
                                .multilineTextAlignment(.trailing)
//                                .textFieldStyle(.roundedBorder)
                            
                        }
                    }
                    
                    Button("Compute"){
                        

                        let pd = PerformanceDatabase()
                        
                        let cross = pd.getCrosswind(strWindDirection: strDirection, strVelocity: strVelocity, strGust: strGust, strRunwayCourse: strRunwayCourse)
                        
                        var head = pd.getHeadwind(strWindDirection: strDirection, strVelocity: strVelocity, strGust: strGust, strRunwayCourse: strRunwayCourse)

                        print("Crosswind: " + String(cross))
                        print("Headwind:  " + String(head))
                        
                        //print("---" + selectedTypeCondition)
                        //print(pd.getACTypes())
                        
                        let ldist = pd.getCorrectedDistance(
                            ac_type:selectedTypeCondition.rawValue,
                            flaps: selectedFlapsCondition.rawValue,
                            condition:selectedCondition.rawValue,
                            elevation:strRunwayElevation,
                            t:strOAT,
                            weight:strLandingWeight,
                            headwind: head,
                            reverser:selectedReverseCondition.rawValue,
                            autobrk:selectedAutoBrake.rawValue,
                            penalty:strPenaltyFactor
                        );
                        
                        if(0 != Double(strLandingWeight)!){
                            strLandingDistance = String(Int64(ceil(ldist)));
                            strLandingDistanceNonFactored = String(Int64(ceil(ldist/1.15)));
                        }
                        
                        head = pd.getHeadwind(strWindDirection: strDirection, strVelocity: strVelocity, strGust: "0", strRunwayCourse: strRunwayCourse)
                        
                        let vapp = pd.getVapp(
                            Weight: strLandingWeight,
                            Flaps: selectedFlapsCondition.rawValue,
                            AircraftType: selectedTypeCondition.rawValue,
                            Athr: selectedAthrCondition.rawValue,
                            Headwind: head,
                            deltaVref: strDeltaVref)
                        
//                        if (1.0 == Double(strPenaltyFactor)!){
                            strVapp = String(vapp)

                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
