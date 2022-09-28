//
//  ConsumptionTimesPicker.swift
//  TakeAPill
//
//  Created by  Dinir on 24.09.2022.
//

import UIKit

protocol ConsumtionTimeSetupBar {
    func timeBarChanged()
}

class ConsumptionTimeSetupBar: UIStackView,
                               CloseableDatePickerDelegate,
                               DatePickerTextFieldDelegate {
    private var addButton: UIButton!
    private var scrollView: UIScrollView!
    private var timestampsContainer: UIStackView!

    var delegate: ConsumtionTimeSetupBar?
    var timestamps: [Date]
    {
        get {
            return timestampsContainer.arrangedSubviews
                                      .map({($0 as! DatePickerTextField).getDate()})
        }

        set {
            let sortedTimestamps = newValue.sorted(by: {$0.minutes < $1.minutes})
            sortedTimestamps.map(
                {timestampsContainer.addArrangedSubview(createDatePicker(timestamp: $0))})
        }
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)

        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .fill
        self.spacing = 8

        addButton = UIButton(type: .contactAdd)
        addButton.addAction(UIAction(handler: { _ in self.addDatePicker()}), for: .touchUpInside)
        setupScrollView()

        self.addArrangedSubview(scrollView)
        self.addArrangedSubview(addButton)
    }

    private func addDatePicker() {
        let datePicker = createDatePicker(timestamp: Date())
        datePicker.sendActions(for: .touchUpInside)
        timestampsContainer.addArrangedSubview(datePicker)
        delegate?.timeBarChanged()
    }

    func dateSelected() {
        delegate?.timeBarChanged()
    }

    func closeDatePicker() {
        for subview in timestampsContainer.arrangedSubviews {
            if let subview = subview as? CloseableDatePickerTextField,
               subview.isCloseButtonClicked {
                timestampsContainer.removeArrangedSubview(subview)
                subview.removeFromSuperview()
            }
        }
        delegate?.timeBarChanged()
    }

    private func setupScrollView() {
        setupTimestampsContainer()

        scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.layer.borderColor = UIColor.systemBlue.cgColor
        scrollView.layer.borderWidth = 0.5
        scrollView.layer.cornerRadius = 8.0
        scrollView.addSubview(timestampsContainer)

        scrollView.widthAnchor.constraint(equalToConstant: 301).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 58).isActive = true

        timestampsContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        timestampsContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -15).isActive = true
        timestampsContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        timestampsContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        timestampsContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
    }

    private func setupTimestampsContainer() {
        timestampsContainer = UIStackView()
        timestampsContainer.translatesAutoresizingMaskIntoConstraints = false
        timestampsContainer.axis = .horizontal
        timestampsContainer.distribution = .fill
        timestampsContainer.alignment = .center
        timestampsContainer.spacing = 20.0
    }

    private func createDatePicker(timestamp: Date) -> DatePickerTextField {
        let datePicker = CloseableDatePickerTextField(dateType: .OnlyTime, date: timestamp)
        datePicker.closeableDelegate = self
        datePicker.datePickerDelegate = self

        return datePicker
    }
}
