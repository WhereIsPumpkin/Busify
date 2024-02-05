//
//  TravelCard.swift
//  iNet
//
//  Created by Saba Gogrichiani on 04.02.24.
//

import Foundation

struct TransitCard: Identifiable {
    let id = UUID()
    let cardName: String
    let price: Int
    let duration: String
    let descriptions: [String]

    static let allCards = [
        TransitCard(cardName: "MetroQuick", price: 1, duration: "duration_90min", descriptions: ["90-Minute Freedom", "Brief adventure"]),
        TransitCard(cardName: "MetroDay", price: 3, duration: "duration_Daily", descriptions: ["All-Day Access", "Tourist's Favorite"]),
        TransitCard(cardName: "MetroWeek", price: 20, duration: "duration_Weekly", descriptions: ["Week-Long Travel", "7-Day Explorer"]),
        TransitCard(cardName: "MetroMonth", price: 40, duration: "duration_Monthly", descriptions: ["Monthly Commuter", "30-Day Pass"]),
        TransitCard(cardName: "MetroSeasonal", price: 100, duration: "duration_Quarterly", descriptions: ["Quarter-Year Tour", "Seasonal Freedom"]),
        TransitCard(cardName: "MetroBiannual", price: 150, duration: "duration_Semiannual", descriptions: ["Six-Month Journey", "Half-Year Pass"]),
        TransitCard(cardName: "MetroYearly", price: 250, duration: "duration_Annual", descriptions: ["Year-Round Travel", "Annual Unlimited"])
    ]
}

/// used for request body
struct BuyTicketRequest: Codable {
    let cardName: String
    let price: Int
    let duration: String
}
