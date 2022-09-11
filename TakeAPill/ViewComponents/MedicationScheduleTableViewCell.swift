//
//  MedicationScheduleTableViewCell.swift
//  TakeAPill
//
//  Created by  Dinir on 11.09.2022.
//

import UIKit

class MedicationScheduleTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var consumptionTimeLabel: UILabel!
    @IBOutlet var weekdaysLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func update(schedule: MedicationSchedule) {
        nameLabel.text = schedule.name
        consumptionTimeLabel.text = schedule.consumptionTime.formatted(date: .omitted, time: .shortened)
        weekdaysLabel.text = schedule.weekDays
            .map({Calendar.localizedShortWeekdaySymbols[$0.rawValue]})
            .joined(separator: ", ")
    }
}
