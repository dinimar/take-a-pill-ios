//
//  QuestionViewController.swift
//  TakeAPill
//
//  Created by  Dinir on 19.07.2022.
//

import UIKit

class ScheduleSetupViewController: UITableViewController,
                                   WeekDayPickerDelegate,
                                   DatePickerTextFieldDelegate,
                                   PeriodDatesPickerDelegate {
    var schedule: MedicationSchedule?

    @IBOutlet var navigationBar: UINavigationItem!
    @IBOutlet var saveButton: UIBarButtonItem!

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var consumptionTimeTextField: DatePickerTextField!
    @IBOutlet var weekDayPicker: WeekDayPicker!
    @IBOutlet var periodDatesPicker: PeriodDatesPicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false
        weekDayPicker.delegate = self
        consumptionTimeTextField.datePickerDelegate = self
        periodDatesPicker.delegate = self
        updateView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.performSegue(withIdentifier: "manualUnwind", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else {
            return
        }

        let periodDates = periodDatesPicker.getPeriod()
        let consumptionTime = consumptionTimeTextField.getDate()
        let name = nameTextField.text ?? ""
        let weekDays = weekDayPicker.selectedWeekdays.map({WeekDays(rawValue: $0) ?? .WrongWeekday})
        
        self.schedule = MedicationSchedule(name: name,
                                           weekDays: weekDays,
                                           consumptionTime: consumptionTime,
                                           periodDayStart: periodDates.startDate,
                                           periodDayEnd: periodDates.endDate)
    }

    @IBAction func textFieldEditingChangedSchedule(_ sender: UITextField) {
        saveButton.isEnabled = true
    }

    func weekdaySelected() {
        saveButton.isEnabled = true
    }

    func dateSelected() {
        saveButton.isEnabled = true
    }

    func periodSelected() {
        saveButton.isEnabled = true
    }

    init?(coder: NSCoder, schedule: MedicationSchedule?) {
        self.schedule = schedule
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateView() {
        guard let schedule = schedule else {
            navigationBar.title = "New Schedule"
            consumptionTimeTextField.initializeType(.OnlyTime)
            return
        }

        navigationBar.title = "Edit Schedule"
        nameTextField.text = schedule.name

        periodDatesPicker.setPeriod(startDate: schedule.periodDayStart, endDate: schedule.periodDayEnd)
        consumptionTimeTextField.setDate(schedule.consumptionTime, dateType: .OnlyTime)
        weekDayPicker.selectedWeekdays = schedule.weekDays.map({$0.rawValue})
    }
}
