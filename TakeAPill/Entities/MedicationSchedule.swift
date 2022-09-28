//
//  DrugSchedule.swift
//  TakeAPill
//
//  Created by  Dinir on 09.07.2022.
//

import Foundation

struct MedicationSchedule {
    var name: String = ""
    var weekDays = [WeekDays]()
    var consumptionTime = [Date]()
    var periodDayStart: Date = Date()
    var periodDayEnd:   Date = Date()
    
    static var all: [MedicationSchedule] {
        return [MedicationSchedule(name: "paracetamol",
                                   weekDays: [.Monday, .Friday],
                                   consumptionTime: [Date(fromString: "2022-09-01 12:30", format: .DateTime)],
                                   periodDayStart: Date(fromString: "2022-09-01 19:30", format: .DateTime),
                                   periodDayEnd: Date(fromString: "2022-09-19 19:30", format: .DateTime)),
                MedicationSchedule(name: "aspirin",
                                   weekDays: [.Tuesday, .Sunday],
                                   consumptionTime: [Date(fromString: "2022-09-01 10:30", format: .DateTime)],
                                   periodDayStart: Date(fromString: "2022-09-19 19:30", format: .DateTime),
                                   periodDayEnd: Date(fromString: "2022-09-29 19:30", format: .DateTime)),
                MedicationSchedule(name: "xanax",
                                   weekDays: [.Monday, .Tuesday, .Wednesday,
                                              .Thursday, .Friday, .Saturday, .Sunday],
                                   consumptionTime: [Date(fromString: "2022-09-01 21:00", format: .DateTime),
                                                     Date(fromString: "2022-09-01 11:00", format: .DateTime),
                                                     Date(fromString: "2022-09-01 14:00", format: .DateTime),
                                                     Date(fromString: "2022-09-01 13:00", format: .DateTime),
                                                     Date(fromString: "2022-09-01 23:00", format: .DateTime),
                                                     Date(fromString: "2022-09-01 08:00", format: .DateTime),
                                                     Date(fromString: "2022-09-01 08:00", format: .DateTime)],
                                   periodDayStart: Date(fromString: "2022-10-01 19:30", format: .DateTime),
                                   periodDayEnd: Date(fromString: "2022-10-21 19:30", format: .DateTime))]
    }
    
}

enum WeekDays: Int {
    case Monday     = 0,
         Tuesday    = 1,
         Wednesday  = 2,
         Thursday   = 3,
         Friday     = 4,
         Saturday   = 5,
         Sunday     = 6,
         WrongWeekday
}
