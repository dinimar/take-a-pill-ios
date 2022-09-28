//
//  ScheduleTabBarController.swift
//  TakeAPill
//
//  Created by  Dinir on 28.09.2022.
//

import UIKit

class ScheduleTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let uiMode = self.traitCollection.userInterfaceStyle
        self.tabBar.backgroundColor = getViewColor(forUiMode: uiMode)
    }
}
