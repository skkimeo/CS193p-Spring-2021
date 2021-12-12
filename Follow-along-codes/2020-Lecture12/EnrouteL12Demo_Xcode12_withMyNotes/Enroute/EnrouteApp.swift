//
//  EnrouteApp.swift
//  Enroute
//
//  Created by CS193p Instructor.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

@main
struct EnrouteApp: App {
    let persistenceController = PersistenceController.shared
    let defaultAirport: Airport
    
    init() {
        defaultAirport = Airport.withICAO("KSFO", context: PersistenceController.shared.container.viewContext)
        defaultAirport.fetchIncomingFlights()
    }

    var body: some Scene {
        WindowGroup {
            FlightsEnrouteView(flightSearch: FlightSearch(destination: defaultAirport))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
