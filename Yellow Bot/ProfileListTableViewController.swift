//
//  ProfileListTableViewController.swift
//  Yellow Bot
//
//  Created by Kauntey Suryawanshi on 26/07/21.
//

import UIKit
import YMChat

class ProfileListTableViewController: UITableViewController {

    var botList = [Bot]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    func reload() {
        botList = defaults.botList.compactMap { defaults.botDetails(botId: $0) }
        botList.sort(by: {$0.date > $1.date})
        tableView.reloadData()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        botList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        let bot = botList[indexPath.row]
        cell.textLabel?.text = bot.name.isEmpty ? "Unnamed" : bot.name
        cell.detailTextLabel?.text = bot.id
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let botId = botList[indexPath.row].id
        let alertController = UIAlertController(title: botId, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "🤖 Start Bot", style: .default, handler: { _ in
            self.startBot(botId: botId)
        }))

        if let bot = defaults.botDetails(botId: botId), !(bot.apiKey?.isEmpty ?? true), !bot.ymAuthToken.isEmpty, bot.enableNotification {
            alertController.addAction(UIAlertAction(title: "Register Device", style: .default, handler: { _ in
                self.registerDevice(bot: bot)
            }))
        }
        
        if let bot = defaults.botDetails(botId: botId), !(bot.apiKey?.isEmpty ?? true), bot.enableNotification {
            alertController.addAction(UIAlertAction(title: "Unlink Device Token", style: .default, handler: { _ in
                self.unlinkDeviceToken(bot: bot)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            self.editProfile(botId: botId)
        }))
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteProfile(botId: botId)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    @objc func startBot(botId: String) {
        guard let bot = defaults.botDetails(botId: botId) else {
            showErrorAlert("Cannot find bot \(botId). Please reinstall the app")
            return
        }

        YMChat.shared.config = bot.toYMConfig
        try! YMChat.shared.startChatbot(on: self)
    }

    @objc func editProfile(botId: String) {
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileVC.editBotId = botId
        self.navigationController?.pushViewController(profileVC, animated: true)
    }

    @objc func deleteProfile(botId: String) {
        defaults.deleteBot(botId: botId)
        reload()
    }

    func registerDevice(bot: Bot) {
        YMChat.shared.config = bot.toYMConfig
        YMChat.shared.registerDevice(
            apiKey: bot.apiKey!,
            ymConfig: YMChat.shared.config,
            success: { DispatchQueue.main.async {
                self.showInfoAlert("Device Registered Successfully") }
            },
            failure: { error in
                DispatchQueue.main.async {
                    self.showErrorAlert(error)
                }
            })
    }
    
    func unlinkDeviceToken(bot: Bot) {
        YMChat.shared.config = bot.toYMConfig
        YMChat.shared.unlinkDeviceToken(
            apiKey: bot.apiKey!,
            ymConfig: YMChat.shared.config,
            success: { DispatchQueue.main.async {
                self.showInfoAlert("Device Unlinked Successfully") }
            },
            failure: { error in
                DispatchQueue.main.async {
                    self.showErrorAlert(error)
                }
            })
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
