//
//  ViewController.swift
//  Yellow Bot
//
//  Created by Kauntey Suryawanshi on 19/07/21.
//

import UIKit
import YMChat

class QuickStartViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var botTextField: UITextField!
    @IBAction func startQuickChat(_ sender: Any) {
        guard botTextField.text?.isEmpty == false else {
            showErrorAlert("Enter a valid bot id to start")
            return
        }
        let config = YMConfig(botId: botTextField.text!)
        YMChat.shared.config = config
        try! YMChat.shared.startChatbot(on: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
