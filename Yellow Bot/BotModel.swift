//
//  BotModel.swift
//  Yellow Bot
//
//  Created by Kauntey Suryawanshi on 20/07/21.
//

import Foundation
import YMChat

struct Bot: Codable {
    let id, name, ymAuthToken, customBaseURL: String
    let apiKey: String?
    let version: Int
    let enableSpeech: Bool
    let enableLiteVersion: Bool?
    let enableNotification: Bool
    let date: Date
    var payload: String
    let activationMode: Int?
    let initialUserMessage: String?

    var toYMConfig: YMConfig {
        let config = YMConfig(botId: id)
        config.enableSpeech = enableSpeech
        config.useLiteVersion = enableLiteVersion ?? false
        config.version = version
        config.activationMode = YMActivationMode(rawValue: activationMode ?? 0) ?? .chat
        if let initialUserMessage = initialUserMessage, initialUserMessage.isEmpty == false {
            config.initialUserMessage = initialUserMessage
        }
        if ymAuthToken.isEmpty == false {
            config.ymAuthenticationToken = ymAuthToken
        }
        if enableNotification {
            config.deviceToken = defaults.fcmToken
        }
        if customBaseURL.isEmpty == false {
            config.customBaseUrl = customBaseURL
        }
        if !payload.isEmpty {
            config.payload = convertToDictionary(text: payload)
        }
        return config
    }

    func convertToDictionary(text: String) -> [String: Any] {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return [String: Any]()
    }
}
