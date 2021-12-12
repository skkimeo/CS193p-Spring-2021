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
    var body: some Scene {
        WindowGroup {
            FlightsEnrouteView(flightSearch: FlightSearch(destination: "KSFO"))
        }
    }
}
