//
//  AlertManager.swift
//  EvaluatonTestIos
//
//  Created by Константин Сабицкий on 09.09.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import Foundation
import UIKit
class AlertManager {

    static func createAlert(with title: String, message: String, prefferedStyle: UIAlertController.Style, actions: [UIAlertAction]) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: prefferedStyle)
        for action in actions {
            alertController.addAction(action)
        }
        return alertController
    }
    
}
