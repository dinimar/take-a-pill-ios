//
//  WeekDayPicker.swift
//  TakeAPill
//
//  Created by  Dinir on 04.09.2022.
//

import UIKit

protocol WeekDayPickerDelegate {
    func weekdaySelected()
}

class WeekDayPicker: UIStackView, OnOffButtonDelegate {
    private var weekdayButtons = [OnOffButton]()
    var selectedWeekdays: [Int] {
        get {
            var selectedWeekdays = [Int]()
            for i in 0...weekdayButtons.count-1 {
                if (weekdayButtons[i].isOn) {
                    selectedWeekdays.append(i)
                }
            }

            return selectedWeekdays
        }

        set {
            for button in weekdayButtons {
                button.isOn = false
            }
            
            for i in newValue {
                if i < weekdayButtons.count {
                    weekdayButtons[i].isOn = true
                }
            }
        }
    }

    var delegate: WeekDayPickerDelegate?

    required init(coder: NSCoder) {
        super.init(coder: coder)
        initButtons(coder: coder)

        self.axis = .horizontal
        self.distribution = .fillEqually
        self.spacing = 2.0
        self.alignment = .fill

        for button in weekdayButtons {
            self.addArrangedSubview(button)
        }
    }

    private func initButtons(coder: NSCoder) {
        let buttonTitles = Calendar.localizedShortWeekdaySymbols
        weekdayButtons = buttonTitles.map({OnOffButton(title: $0, delegate: self)})
    }

    func pressed() {
        guard let delegate = delegate else { return }
        delegate.weekdaySelected()
    }
}
