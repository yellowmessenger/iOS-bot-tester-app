//
//  PayloadViewController.swift
//  Yellow Bot
//
//  Created by Kauntey Suryawanshi on 20/07/21.
//

import UIKit
import Combine

class PayloadViewController: UIViewController {
    @IBOutlet weak var payloadTextView: UITextView!

    var payloadSubject = PassthroughSubject<String, Never>()
    let botId, initialPayload: String

    init?(coder: NSCoder, botId: String, payload: String) {
        self.botId = botId
        self.initialPayload = payload
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        payloadTextView.text = initialPayload
    }

    @IBAction func saveTapped(_ sender: Any) {
        guard let data = payloadTextView.text!.data(using: .utf8) else {
            showErrorAlert("Invalid payload. Cannot convert to data")
            return
        }

        do {
            if let _ = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                payloadSubject.send(payloadTextView.text!)
                defaults.updatePayload(botId: botId, newPayload: payloadTextView.text!)
                navigationController?.popViewController(animated: true)
            } else {
                showErrorAlert("Payload not compatible with JSON format.")
            }
        } catch {
            showErrorAlert("Payload not compatible with JSON format")
        }
    }
}
