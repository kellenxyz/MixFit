//
//  HUDGreeting.swift
//  MixFit
//
//  Created by Kellen Pierson on 7/30/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import Foundation

struct HUDGreeting {

    static func displayGreetingForTimeOfDay() -> String {

        var greeting = "Hello!"
        let hour = (Calendar.current as NSCalendar).component(.hour, from: Date())

        if hour >= 0  && hour < 12 {
            greeting = "Good morning, Nathaniel!"
        } else if hour >= 12 && hour < 17 {
            greeting = "Good afternoon, Nathaniel!"
        } else if hour >= 17 {
            greeting = "Good evening, Nathaniel!"
        }

        return greeting.uppercased()
    }

    static func getQuoteForGreeting() -> String {

        let quotes = [
            "\"Conquer today with style.\"\n- Cool Guy",
            "Seize the day.",
            "You were born to do amazing things.",
            "Get after it hard.",
            "Crush it."
        ]

        let randomIndex = Int(arc4random_uniform(UInt32(quotes.count - 1)))

        return quotes[randomIndex]
    }
}
