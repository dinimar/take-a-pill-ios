//
//  PeriodDatesPicker.swift
//  TakeAPill
//
//  Created by  Dinir on 05.09.2022.
//

import UIKit

struct DatePeriod {
    var startDate: Date
    var endDate: Date
}

protocol PeriodDatesPickerDelegate {
    func periodSelected();
}

class PeriodDatesPicker: UIStackView, DatePickerTextFieldDelegate {
    var startDateField = DatePickerTextField(dateType: .OnlyDate)
    var endDateField = DatePickerTextField(dateType: .OnlyDate)
    var delegate: PeriodDatesPickerDelegate?

    required init(coder: NSCoder) {
        super.init(coder: coder)

        self.axis = .horizontal
        self.distribution = .fillEqually
        self.alignment = .fill
        self.spacing = 10.0

        startDateField.datePickerDelegate = self
        endDateField.datePickerDelegate = self

        startDateField.placeholder = "Start Date"
        endDateField.placeholder = "End Date"
        updateEndDate()

        self.addArrangedSubview(startDateField)
        self.addArrangedSubview(endDateField)
    }

    func setPeriod(startDate: Date, endDate: Date) {
        startDateField.setDate(startDate, dateType: .OnlyDate)
        endDateField.setDate(endDate, dateType: .OnlyDate)
    }

    func getPeriod() -> DatePeriod {
        return DatePeriod(startDate: startDateField.getDate(),
                          endDate: endDateField.getDate())
    }

    func dateSelected() {
        updateEndDate()
        delegate?.periodSelected()
    }

    private func updateEndDate() {
        let startDate = startDateField.getDate()
        let endDate = endDateField.getDate()

        let dateComparisonResult = Calendar.current.compare(endDate, to: startDate, toGranularity: .day)
        if (dateComparisonResult == .orderedSame ||
            dateComparisonResult == .orderedAscending) {
            let nextDayAfterStartDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
            endDateField.setMinimumDate(date: nextDayAfterStartDate!)
        }
    }
}
