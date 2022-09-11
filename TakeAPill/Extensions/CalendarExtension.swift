//
//  CalendarExtension.swift
//  TakeAPill
//
//  Created by  Dinir on 04.09.2022.
//

import Foundation

extension Calendar {
    static var localizedWeekdaySymbols: [String] {
        return createLocalizedWeekdaySymbols(Calendar.current.weekdaySymbols)
    }

    static var localizedShortWeekdaySymbols: [String] {
        var shortWeekdaySymbols = [String]()
        for symbol in localizedWeekdaySymbols {
            shortWeekdaySymbols.append(String(symbol[..<symbol.index(symbol.startIndex, offsetBy: 2)]))
        }

        return shortWeekdaySymbols
    }

    static private func createLocalizedWeekdaySymbols(_ weekdaySymbols: [String]) -> [String] {
        let firstWeekdayIdx = Calendar.current.firstWeekday-1
        var localizedWeekdaySymbols = [String]()

        for i in firstWeekdayIdx...weekdaySymbols.count-1 {
            localizedWeekdaySymbols.append(weekdaySymbols[i])
        }

        if firstWeekdayIdx == 0 {
            return localizedWeekdaySymbols
        }

        for i in 0...firstWeekdayIdx-1 {
            localizedWeekdaySymbols.append(weekdaySymbols[i])
        }

        return localizedWeekdaySymbols
    }
}
