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
        setConsumptionTimeLabelText(timestamps: schedule.consumptionTime)
        weekdaysLabel.text = schedule.weekDays
            .map({Calendar.localizedShortWeekdaySymbols[$0.rawValue]})
            .joined(separator: ", ")
    }

    private func setConsumptionTimeLabelText(timestamps: [Date]) {
        var consumptionTime = timestamps.sorted(by: {$0.minutes < $1.minutes})

        let isLongString = timestamps.count > 3
        if (isLongString) {
            consumptionTime = Array(consumptionTime[0..<3])
        }

        var labelText = consumptionTime.map(
            {$0.formatted(date: .omitted, time: .shortened)})
            .joined(separator: ", ")
        if (isLongString) {
            labelText.append(", ...")
        }

        consumptionTimeLabel.text = labelText
    }
}
