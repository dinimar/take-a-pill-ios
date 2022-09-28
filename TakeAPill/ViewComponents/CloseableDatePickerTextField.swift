//
//  CloseableDatePickerTextField.swift
//  TakeAPill
//
//  Created by  Dinir on 27.09.2022.
//

import UIKit

protocol CloseableDatePickerDelegate {
    func closeDatePicker()
}

class CloseableDatePickerTextField: DatePickerTextField {
    var closeableDelegate: CloseableDatePickerDelegate?
    var isCloseButtonClicked: Bool = false

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(dateType: Date.DateType, date: Date = Date()) {
        super.init(dateType: dateType, date: date)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let width = 16
        let offset = 6
        let x = Int(bounds.width) - width - offset
        return CGRect(x: x, y: Int(bounds.height) / 2 - 8, width: width, height: width)
    }

    override func initialize() {
        super.initialize()

        widthAnchor.constraint(equalToConstant: 80).isActive = true
        heightAnchor.constraint(equalToConstant: 34).isActive = true
        borderStyle = .roundedRect
        translatesAutoresizingMaskIntoConstraints = false

        let bounds = self.rightView?.bounds
        let clearButton = UIButton(frame: .zero)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .red

        self.rightView = clearButton
        clearButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)

        self.clearButtonMode = .never
        self.rightViewMode = .unlessEditing
    }

    @objc func closeButtonClicked() {
        isCloseButtonClicked = true
        closeableDelegate?.closeDatePicker()
    }
}
