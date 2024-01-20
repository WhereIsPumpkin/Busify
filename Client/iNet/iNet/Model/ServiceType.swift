//
//  ServiceType.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import Foundation

enum ServiceType: CaseIterable {
    case busSchedule
    case personalizedSuggestions
    case cinemaTickets
    
    var title: String {
        switch self {
        case .busSchedule: return "Bus Schedule"
        case .personalizedSuggestions: return "Personalized Suggestions"
        case .cinemaTickets: return "Cinema Tickets"
        }
    }
    
    var iconName: String {
        switch self {
        case .busSchedule: return "bus.fill"
        case .personalizedSuggestions: return "message"
        case .cinemaTickets: return "popcorn"
        }
    }
}
