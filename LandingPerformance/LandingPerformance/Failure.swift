//
//  Failure.swift
//  LandingPerformance
//
//  Created by Mikhail Stepanov on 19.03.2024.
//

import Foundation

struct Failure: Identifiable, Hashable{
    let id: UUID
    var system : String
    var name : String
    
    init(id: UUID = UUID(), system: String, name: String) {
        self.id = id
        self.system = system
        self.name = name
     }
}


struct System: Identifiable, Hashable{
    let id: UUID
    var name : String
    var failures : [Failure]
    init(id: UUID = UUID(), system_name: String, failures: [Failure]){
        self.id = id
        self.name = system_name
        self.failures = failures
    }
    
    static let sampleData: [System] = [
        System(system_name: "AIR",failures: [Failure(system:"AIR",name:"Bleed failue"),Failure(system:"AIR",name:"Pack failue")]),
        System(system_name: "AUTOFLT",failures: []),
        System(system_name: "BRAKES",failures: []),
        System(system_name: "COND",failures: []),
        System(system_name: "ELEC",failures: []),
        System(system_name: "ENG",failures: []),
        System(system_name: "FCTL",failures: []),
        System(system_name: "HYD",failures: []),
        System(system_name: "LG",failures: []),
        System(system_name: "NAV",failures: []),
        System(system_name: "WHEEL",failures: []),
        System(system_name: "WING A.ICE",failures: [])
    ]

}




