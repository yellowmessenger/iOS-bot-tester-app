//
//  Defaults.swift
//  Yellow Bot
//
//  Created by Kauntey Suryawanshi on 20/07/21.
//

import Foundation

extension UserDefaults {
    var botList: [String] {
        dictionaryRepresentation().keys
            .filter { $0.hasPrefix("bot-")}
            .map { "\($0.dropFirst(4))"}
    }

    func botDetails(botId: String) -> Bot? {
        if let jsonString = string(forKey: "bot-\(botId)") {
            let jsonData = Data(jsonString.utf8)
            let decoder = JSONDecoder()
            let bot = try! decoder.decode(Bot.self, from: jsonData)
            return bot
        }
        return nil
    }

    func deleteBot(botId: String) {
        removeObject(forKey: "bot-\(botId)")
    }

    func saveBot(_ bot: Bot) {
        let data = try! JSONEncoder().encode(bot)
        let jsonString = String(data: data, encoding: .ascii)
        set(jsonString, forKey:"bot-\(bot.id)")
        print("Saving \(jsonString)")
    }

    func updatePayload(botId: String, newPayload: String) {
        if var bot = botDetails(botId: botId) {
            bot.payload = newPayload
            saveBot(bot)
        }
    }

    @objc var fcmToken: String {
        get { string(forKey: #function) ?? ""  }
        set { set(newValue, forKey: #function) }
    }
}
