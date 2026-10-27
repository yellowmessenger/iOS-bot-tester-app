//
//  Other.swift
//  Yellow Bot
//
//  Created by Kauntey Suryawanshi on 20/07/21.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    func showInfoAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }

}

