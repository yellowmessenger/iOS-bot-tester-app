//
//  ProfileViewController.swift
//  Yellow Bot
//
//  Created by Kauntey Suryawanshi on 20/07/21.
//

import UIKit
import Combine

class ProfileViewController: UITableViewController {
    enum Mode { case add, edit(botId: String) }

    var editBotId: String?

    @IBOutlet weak var botIdInputField: UITextField!
    @IBOutlet weak var nameInputField: UITextField!
    @IBOutlet weak var versionSegment: UISegmentedControl!
    @IBOutlet weak var activationModeSegment: UISegmentedControl!
    @IBOutlet weak var initialUserMessageInputField: UITextField!
    @IBOutlet weak var enableSpeechSwitch: UISwitch!
    @IBOutlet weak var ymAuthTokenInputField: UITextField!
    @IBOutlet weak var enableNotificationSwitch: UISwitch!
    @IBOutlet weak var apiKeyInputField: UITextField!
    @IBOutlet weak var customBaseURLInputField: UITextField!
    @IBOutlet weak var payloadContentLabel: UILabel!
    @IBOutlet weak var enableLiteSwitch: UISwitch!

    private var storage = Set<AnyCancellable>()

    private enum Row: Int {
        case botId, name, version, activationMode, initialUserMessage, enableSpeech, useLiteVersion
    }

    private var isV3: Bool { versionSegment.selectedSegmentIndex == 2 }

    override func viewDidLoad() {
        super.viewDidLoad()
        payloadContentLabel.text = ""
        let isEditing = editBotId != nil
        navigationItem.title = isEditing ? "Edit Profile" : "Add Profile"
        botIdInputField.isEnabled = !isEditing
        botIdInputField.backgroundColor = isEditing ? .clear : nil
        if let id = editBotId {
            loadViewForBot(botId: id)
        }
    }

    func loadViewForBot(botId: String) {
        guard let bot = defaults.botDetails(botId: botId) else {
            showErrorAlert("Cannot find bot \(botId). Please reinstall the app")
            return
        }
        botIdInputField.text = bot.id
        nameInputField.text = bot.name
        versionSegment.selectedSegmentIndex = bot.version - 1
        activationModeSegment.selectedSegmentIndex = bot.activationMode ?? 0
        initialUserMessageInputField.text = bot.initialUserMessage
        enableSpeechSwitch.isOn = bot.enableSpeech
        enableLiteSwitch.isOn = bot.enableLiteVersion ?? false
        ymAuthTokenInputField.text = bot.ymAuthToken
        enableNotificationSwitch.isOn = bot.enableNotification
        apiKeyInputField.text = bot.apiKey
        customBaseURLInputField.text = bot.customBaseURL
        payloadContentLabel.text = bot.payload
    }

    @IBAction func versionOrModeChanged(_ sender: UISegmentedControl) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Row(rawValue: indexPath.row) {
        case .activationMode, .initialUserMessage:
            return isV3 ? super.tableView(tableView, heightForRowAt: indexPath) : 0
        case .enableSpeech, .useLiteVersion:
            return isV3 ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "payload", botIdInputField.text?.isEmpty == true {
            showInfoAlert("Enter the bot id first")
            return false
        }
        return true
    }

    private var payloadReference: AnyCancellable?

    @IBSegueAction
    func makePayloadController(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> PayloadViewController? {
        let vc = PayloadViewController(coder: coder, botId: botIdInputField.text!, payload: payloadContentLabel.text!)
        payloadReference = vc?.payloadSubject
            .sink { newPayload in
                self.payloadContentLabel.text = newPayload
            }
        return vc
    }

    func makeBotFromInputField() -> Bot {
        Bot(
            id: botIdInputField.text!,
            name: nameInputField.text!,
            ymAuthToken: ymAuthTokenInputField.text!,
            customBaseURL: customBaseURLInputField.text!,
            apiKey: apiKeyInputField.text,
            version: versionSegment.selectedSegmentIndex + 1, // starts at zero index
            enableSpeech: enableSpeechSwitch.isOn,
            enableLiteVersion: enableLiteSwitch.isOn,
            enableNotification: enableNotificationSwitch.isOn,
            date: Date(),
            payload: payloadContentLabel.text!,
            activationMode: activationModeSegment.selectedSegmentIndex,
            initialUserMessage: initialUserMessageInputField.text?.isEmpty == false ? initialUserMessageInputField.text : nil
        )
    }

    @IBAction func saveTapped(_ sender: Any) {
        guard botIdInputField.text?.isEmpty == false else {
            showErrorAlert("Bot ID cannot be empty")
            return
        }

        let bot = makeBotFromInputField()
        defaults.saveBot(bot)
        self.navigationController?.popViewController(animated: true)
    }
}

