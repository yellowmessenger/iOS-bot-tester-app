//
//  URLViewController.swift
//  Yellow Bot
//
//  Created by Kauntey Suryawanshi on 20/07/21.
//

import Foundation
import UIKit

class URLViewController: UIViewController  {
    @IBOutlet weak var urlLabel: UILabel!

    let bot: Bot
    init?(coder: NSCoder, bot: Bot) {
        self.bot = bot
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        urlLabel.text = bot.toYMConfig.url.absoluteString
    }
}
