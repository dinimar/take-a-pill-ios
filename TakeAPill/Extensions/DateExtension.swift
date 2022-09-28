//
//  DateUtils.swift
//  TakeAPill
//
//  Created by  Dinir on 01.09.2022.
//

import Foundation

extension Date {
    var hours: Int {
        Calendar.current.component(.hour, from: self)
    }
    var minutes: Int {
        Calendar.current.component(.minute, from: self) +
        hours * 60
    }
    
    init(fromString dateString: String, format dateType: DateType) {
        var dateFormatStr = ""
        switch dateType {
            case .OnlyDate:
                dateFormatStr = "yyyy-MM-dd"
            case .OnlyTime:
                dateFormatStr = "HH:mm"
            case .DateTime:
                dateFormatStr = "yyyy-MM-dd HH:mm"
        }

        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = dateFormatStr
        dateStringFormatter.locale = NSLocale(localeIdentifier: "ru_RU_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }

    enum DateType {
        case OnlyDate, OnlyTime, DateTime
    }
}
