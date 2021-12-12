//
//  Airport.swift
//  Enroute
//
//  Created by CS193p Instructor.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import CoreData
import Combine

extension Airport: Comparable {
    static func withICAO(_ icao: String, context: NSManagedObjectContext) -> Airport {
        // look up icao in Core Data
        // sun
        // predicate : which ones do u want?
        // sort descriptors are needed b/c result is returned as array
        let request = fetchRequest(NSPredicate(format: "icao_ = %@", icao))
        // sun
        // need to try this b/c fetch could fail due to lost connection to database etc...
        let airports = (try? context.fetch(request)) ?? []
        if let airport = airports.first {
            // if found, return it
            return airport
        } else {
            // if not, create one and fetch from FlightAware
            // sun
            // passing in the context tells which database to create in
            let airport = Airport(context: context)
            airport.icao = icao
            AirportInfoRequest.fetch(icao) { airportInfo in
                self.update(from: airportInfo, context: context)
            }
            // sun
            // b/c it's async, an empty aiport object will be returned b/f the fetch happens
            return airport
        }
    }
    
    func fetchIncomingFlights() {
        Self.flightAwareRequest?.stopFetching()
        // sun
        // when u have an instance from the databse in ur hand,
        // u can always get the context from the database b/c
        // the instance knows where it came from
        // and so use that context to add/fetch other objects
        if let context = managedObjectContext {
            Self.flightAwareRequest = EnrouteRequest.create(airport: icao, howMany: 90)
            Self.flightAwareRequest?.fetch(andRepeatEvery: 60)
            Self.flightAwareResultsCancellable = Self.flightAwareRequest?.results.sink { results in
                // sun
                // asynchronous closure that's executed when the info
                // comes back from FlightAware
                for faflight in results {
                    Flight.update(from: faflight, in: context)
                }
                do {
                    try context.save()
                } catch(let error) {
                    print("couldn't save flight update to CoreData: \(error.localizedDescription)")
                }
            }
        }
    }

    private static var flightAwareRequest: EnrouteRequest!
    private static var flightAwareResultsCancellable: AnyCancellable?

    static func update(from info: AirportInfo, context: NSManagedObjectContext) {
        // sun
        // fetch the empty airport created previously
        if let icao = info.icao {
            let airport = self.withICAO(icao, context: context)
            airport.latitude = info.latitude
            airport.longitude = info.longitude
            airport.name = info.name
            airport.location = info.location
            airport.timezone = info.timezone
            // sun
            // tell sth changed! so that Views can redraw themselves
            airport.objectWillChange.send()
            airport.flightsTo.forEach { $0.objectWillChange.send() }
            airport.flightsFrom.forEach { $0.objectWillChange.send() }
            // sun
            // save to the databse
            try? context.save()
        }
    }

    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Airport> {
        let request = NSFetchRequest<Airport>(entityName: "Airport")
        request.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]
        request.predicate = predicate
        return request
    }

    var flightsTo: Set<Flight> {
        get { (flightsTo_ as? Set<Flight>) ?? [] }
        set { flightsTo_ = newValue as NSSet }
    }
    var flightsFrom: Set<Flight> {
        get { (flightsFrom_ as? Set<Flight>) ?? [] }
        set { flightsFrom_ = newValue as NSSet }
    }

    var icao: String {
        get { icao_! } // TODO: maybe protect against when app ships?
        set { icao_ = newValue }
    }

    var friendlyName: String {
        let friendly = AirportInfo.friendlyName(name: self.name ?? "", location: self.location ?? "")
        return friendly.isEmpty ? icao : friendly
    }

    public var id: String { icao }

    public static func < (lhs: Airport, rhs: Airport) -> Bool {
        lhs.location ?? lhs.friendlyName < rhs.location ?? rhs.friendlyName
    }
}
