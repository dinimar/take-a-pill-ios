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
    var isScheduleChanged: Bool = false
    var isNewSchedule: Bool = false

    @IBOutlet var navigationBar: UINavigationItem!
    @IBOutlet var saveButton: UIBarButtonItem!

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var consumptionTimeTextField: DatePickerTextField!
    @IBOutlet var weekDayPicker: WeekDayPicker!
    @IBOutlet var periodDatesPicker: PeriodDatesPicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Disable manual dismissal
        isModalInPresentation = true

        saveButton.isEnabled = false
        weekDayPicker.delegate = self
        consumptionTimeTextField.datePickerDelegate = self
        periodDatesPicker.delegate = self
        updateView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else {
            return
        }

        let periodDates = periodDatesPicker.getPeriod()
        let consumptionTime = consumptionTimeTextField.getDate()
        let name = (nameTextField.text ?? "").lowercased()
        let weekDays = weekDayPicker.selectedWeekdays.map({WeekDays(rawValue: $0) ?? .WrongWeekday})

        self.schedule = MedicationSchedule(name: name,
                                           weekDays: weekDays,
                                           consumptionTime: consumptionTime,
                                           periodDayStart: periodDates.startDate,
                                           periodDayEnd: periodDates.endDate)
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        var emptyFields = [String]()
        if !nameTextField.hasText {
            emptyFields.append("Name")
        }
        if weekDayPicker.selectedWeekdays.isEmpty {
            emptyFields.append("Days of the week")
        }

        guard emptyFields.isEmpty else {
            showEmptyFieldsAlert(emptyFields)
            return
        }
        self.performSegue(withIdentifier: "saveUnwind", sender: self)
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        guard isNewSchedule else {
            performCancelUnwind()
            return
        }

        self.performSegue(withIdentifier: "cancelUnwind", sender: self)
    }

    @IBAction func textFieldEditingChangedSchedule(_ sender: UITextField) {
        onScheduleChanged()
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
            isNewSchedule = true
            return
        }

        navigationBar.title = "Edit Schedule"
        nameTextField.text = schedule.name

        periodDatesPicker.setPeriod(startDate: schedule.periodDayStart, endDate: schedule.periodDayEnd)
        consumptionTimeTextField.setDate(schedule.consumptionTime, dateType: .OnlyTime)
        weekDayPicker.selectedWeekdays = schedule.weekDays.map({$0.rawValue})
    }

    func weekdaySelected() {
        onScheduleChanged()
    }

    func dateSelected() {
        onScheduleChanged()
    }

    func periodSelected() {
        onScheduleChanged()
    }

    private func onScheduleChanged() {
        saveButton.isEnabled = true
        isScheduleChanged = true
    }

    private func performCancelUnwind() {
        guard isScheduleChanged else {
            self.performSegue(withIdentifier: "cancelUnwind", sender: self)
            return
        }

        showConfirmationAlert()
    }

    private func showConfirmationAlert() {
        let alert = UIAlertController(title: nil,
                                      message: "Do you want to save your changes?",
                                      preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Save",
                                       style: .default,
                                       handler: {(action) in
            self.performSegue(withIdentifier: "saveUnwind", sender: self)})

        let discardAction = UIAlertAction(title: "Discard",
                                          style: .cancel,
                                          handler: {(action) in
            self.performSegue(withIdentifier: "cancelUnwind", sender: self)})

        alert.addAction(discardAction)
        alert.addAction(saveAction)

        self.present(alert, animated: true, completion: nil)
    }

    private func showEmptyFieldsAlert(_ emptyFields: [String]) {
        guard !emptyFields.isEmpty else {
            return
        }

        let alertMessage = "Please, fill following fields: "
                            + emptyFields.joined(separator: ", ")

        let alert = UIAlertController(title: nil,
                                      message: alertMessage,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok",
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
    }
}
