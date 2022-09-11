//
//  DatePickerTextField.swift
//  TakeAPill
//
//  Created by  Dinir on 01.09.2022.
//

import UIKit

protocol DatePickerTextFieldDelegate {
    func dateSelected();
}

internal class DatePickerTextField: UITextField {
    private var dateType: Date.DateType?
    private let datePicker = UIDatePicker()
    var datePickerDelegate: DatePickerTextFieldDelegate?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    init(dateType: Date.DateType) {
        super.init(frame: .zero)
        setDate(Date(), dateType: .OnlyDate)
        initialize()
    }

    func initialize() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(datePickerDidSelect(_:)), for: .valueChanged)
        self.inputView = datePicker

        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissTextField))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        self.inputAccessoryView = toolBar

        self.borderStyle = .roundedRect
    }

    func setDate(_ date: Date, dateType: Date.DateType) {
        self.datePicker.setDate(date, animated: true)
        self.dateType = dateType
        switch dateType {
            case .OnlyTime:
                datePicker.datePickerMode = .time
                self.text = date.formatted(date: .omitted, time: .shortened)

            case .OnlyDate:
                datePicker.datePickerMode = .date
                self.text = date.formatted(date: .numeric, time: .omitted)

            default:
                datePicker.datePickerMode = .dateAndTime
                self.text = date.formatted()
        }
    }

    func getDate() -> Date {
        return datePicker.date
    }

    func setMinimumDate(date: Date) {
        self.datePicker.minimumDate = date

        guard let dateType = dateType else {
            return
        }
        setDate(date, dateType: dateType)
    }

    func initializeType(_ dateType: Date.DateType) {
        setDate(Date(), dateType: dateType)
    }

    @objc private func datePickerDidSelect(_ sender: UIDatePicker) {
        guard let dateType = dateType else {
            return
        }

        setDate(sender.date, dateType: dateType)
        datePickerDelegate?.dateSelected()
    }

    @objc private func dismissTextField() {
        resignFirstResponder()
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }

    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
