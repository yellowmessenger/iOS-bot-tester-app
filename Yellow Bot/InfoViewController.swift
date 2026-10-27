//
//  InfoViewController.swift
//  Yellow Bot
//
//  Created by Kauntey Suryawanshi on 21/07/21.
//

import UIKit
import YMChat

class InfoViewController: UIViewController {

    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var ymSDKVersionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
        appVersionLabel.text = "\(appVersion)(\(build))"

        let sdkVersion = Bundle(for: YMChat.self).infoDictionary?["CFBundleShortVersionString"] as? String
        ymSDKVersionLabel.text = sdkVersion
    }

    @IBAction func closeButtonTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
