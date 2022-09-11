//
//  SwitchButton.swift
//  TakeAPill
//
//  Created by  Dinir on 04.09.2022.
//

import UIKit

protocol OnOffButtonDelegate {
    func pressed()
}

internal class OnOffButton: UIButton {
    private var buttonTitle: String!
    private var enabledConfiguration: UIButton.Configuration {
        return createConfiguration(.filled())
    }
    private var disabledConfiguration: UIButton.Configuration {
        return createConfiguration(.plain())
    }

    var delegate: OnOffButtonDelegate?
    var isOn: Bool = false {
        didSet {
            if (isOn) {
                self.configuration = self.enabledConfiguration
            } else {
                self.configuration = self.disabledConfiguration
            }

            setTitle(buttonTitle, for: .normal)
        }
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                isHighlighted = false
            }
        }
    }

    init(title: String, delegate: OnOffButtonDelegate) {
        super.init(frame: .zero)

        initialize()

        self.buttonTitle = title
        self.delegate = delegate
        self.setTitle(title, for: .normal)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        initialize()
    }

    func initialize() {
        self.isOn = false
        self.configuration = self.disabledConfiguration
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isOn.toggle()

        guard let delegate = delegate else { return }
        delegate.pressed()
    }

    private func createConfiguration(_ initialConfig: UIButton.Configuration)
        -> UIButton.Configuration {
        var config: UIButton.Configuration = initialConfig
        config.titlePadding = 0
        config.titleAlignment = .center
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 14, weight: .bold)
            return outgoing
        }

        config.background.strokeWidth = 1.0
        config.background.strokeColor = .systemBlue

        return config
    }
}
