//
//  ViewUtils.swift
//  TakeAPill
//
//  Created by  Dinir on 28.09.2022.
//

import Foundation
import UIKit

func getViewColor(forUiMode uiMode: UIUserInterfaceStyle,
                  defaultColor: UIColor = UIColor(white: 242/255, alpha: 1.0)) -> UIColor {
    return uiMode == .dark ? defaultColor.inverted : defaultColor
}
