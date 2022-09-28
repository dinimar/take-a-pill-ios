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
                                   PeriodDatesPickerDelegate,
                                   ConsumtionTimeSetupBar {
    var schedule: MedicationSchedule?
    var isScheduleChanged: Bool = false
    var isNewSchedule: Bool = false
    var isButtonUnwindPerformed: Bool = false

    @IBOutlet var navigationBar: UINavigationItem!
    @IBOutlet var saveButton: UIBarButtonItem!

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var consumptionTimeSetupBar: ConsumptionTimeSetupBar!
    @IBOutlet var weekDayPicker: WeekDayPicker!
    @IBOutlet var periodDatesPicker: PeriodDatesPicker!

    @IBOutlet var nameCellContentView: UIView!
    @IBOutlet var periodCellContentView: UIView!
    @IBOutlet var consumptionTimeBarCellContentView: UIView!
    @IBOutlet var weekDaysCellContentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false
        weekDayPicker.delegate = self
        consumptionTimeSetupBar.delegate = self
        periodDatesPicker.delegate = self
        updateView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        guard isButtonUnwindPerformed else {
            performCancelUnwind()
            return
        }

        super.viewWillDisappear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else {
            return
        }

        let periodDates = periodDatesPicker.getPeriod()
        let consumptionTime = consumptionTimeSetupBar.timestamps
        let name = (nameTextField.text ?? "").lowercased()
        let weekDays = weekDayPicker.selectedWeekdays.map(
                       {WeekDays(rawValue: $0) ?? .WrongWeekday})

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
        if consumptionTimeSetupBar.timestamps.isEmpty {
            emptyFields.append("Consumption time")
        }

        guard emptyFields.isEmpty else {
            showEmptyFieldsAlert(emptyFields)
            return
        }

        isButtonUnwindPerformed = true
        self.performSegue(withIdentifier: "saveUnwind", sender: self)
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        isButtonUnwindPerformed = true

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
        initCellsColor()
        guard let schedule = schedule else {
            navigationBar.title = "New Schedule"
            isNewSchedule = true
            return
        }

        navigationBar.title = "Edit Schedule"
        nameTextField.text = schedule.name

        periodDatesPicker.setPeriod(startDate: schedule.periodDayStart, endDate: schedule.periodDayEnd)
        consumptionTimeSetupBar.timestamps = schedule.consumptionTime
        weekDayPicker.selectedWeekdays = schedule.weekDays.map({$0.rawValue})
    }

    private func initCellsColor() {
        let uiMode = self.traitCollection.userInterfaceStyle
        var color: UIColor = .white
        if uiMode == .dark {
            color = UIColor(white: 28/255, alpha: 1)
        }

        nameCellContentView.backgroundColor = color
        periodCellContentView.backgroundColor = color
        consumptionTimeBarCellContentView.backgroundColor = color
        weekDaysCellContentView.backgroundColor = color
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

    func timeBarChanged() {
        onScheduleChanged()
    }

    private func onScheduleChanged() {
        saveButton.isEnabled = true
        isScheduleChanged = true

        // Disable manual dismissal
        isModalInPresentation = true
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

        let saveAction = UIAlertAction(title: "Yes",
                                       style: .default,
                                       handler: {(action) in
            self.performSegue(withIdentifier: "saveUnwind", sender: self)})

        let discardAction = UIAlertAction(title: "No",
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
