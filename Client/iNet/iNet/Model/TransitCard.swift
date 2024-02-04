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
        TransitCard(cardName: "MetroQuick", price: 1, duration: "90min", descriptions: ["90-Minute Freedom", "Brief adventure"]),
        TransitCard(cardName: "MetroDay", price: 3, duration: "Daily", descriptions: ["All-Day Access", "Tourist's Favorite"]),
        TransitCard(cardName: "MetroWeek", price: 20, duration: "Weekly", descriptions: ["Week-Long Travel", "7-Day Explorer"]),
        TransitCard(cardName: "MetroMonth", price: 40, duration: "Monthly", descriptions: ["Monthly Commuter", "30-Day Pass"]),
        TransitCard(cardName: "MetroSeasonal", price: 100, duration: "Quarterly", descriptions: ["Quarter-Year Tour", "Seasonal Freedom"]),
        TransitCard(cardName: "MetroBiannual", price: 150, duration: "Semiannual", descriptions: ["Six-Month Journey", "Half-Year Pass"]),
        TransitCard(cardName: "MetroYearly", price: 250, duration: "Annual", descriptions: ["Year-Round Travel", "Annual Unlimited"])
    ]
}
