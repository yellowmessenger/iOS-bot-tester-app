# Yellow.ai Chatbot SDK: iOS Demo App

A sample iOS app that shows how to add a Yellow.ai chatbot to a native iOS app with the [YMChatbot-iOS](https://github.com/yellowmessenger/YMChatbot-iOS) SDK.

Use it to:

- **See your bot running in an iOS app in a few minutes**, before you write any integration code.
- **Try different settings** (v1, v2 or v3 widget, auth token, payload, region) without rebuilding.
- **Copy working integration code**: starting the bot and registering for push notifications.

| | Version |
|---|---|
| YMChatbot-iOS | 2.4.3 (Swift Package Manager) |
| Language / UI | Swift, UIKit |
| Minimum iOS | 17.0 |

For the full SDK reference, see the [iOS SDK docs](https://docs.yellow.ai/docs/platform_concepts/mobile/chatbot/ios).

## Requirements

- A Mac with Xcode
- An iOS simulator or device running iOS 17 or later
- Your bot's **Bot ID**. Open your bot on the [Yellow.ai platform](https://cloud.yellow.ai); the Bot ID is in the URL and starts with `x` (for example `x1587041004122`).

## Run the app

1. Clone this repo and open `Yellow Bot.xcodeproj` in Xcode.
2. Wait for Xcode to fetch the Swift packages (YMChatbot-iOS and Firebase). If it doesn't start on its own, use **File > Packages > Resolve Package Versions**.
3. Pick a simulator or device and press **Run**.

The app runs without Firebase. Xcode shows a warning that `GoogleService-Info.plist` wasn't found; you can ignore it unless you want push notifications (see below).

## Try your bot

### Quick Start

Enter your **Bot ID** and tap **Start Chat Bot**. The bot opens with default settings: v1 widget, no auth token, no payload.

### Profiles

Save a bot with specific settings and reuse it. Profiles are stored on the device.

1. Open the **Profiles** tab and tap **+**.
2. Fill in the fields you need:

   | Field | What it does |
   |---|---|
   | Bot ID | Your bot's ID. Required. To change it later, delete the profile and add it again. |
   | Name | A label for the profile list. |
   | Version | Which chat widget to load: `v1`, `v2` or `v3`. |
   | Activation Mode | **v3 only.** Open the widget in `chat` or `voice` mode. |
   | Initial Message | **v3 only.** A message to start the conversation with. |
   | Enable Speech | **v1/v2 only.** Adds voice input to the widget. |
   | Use Lite Version | **v1/v2 only.** Loads the lite widget. |
   | YMAuthToken | A token that identifies the user, for bots that need an authenticated session. |
   | Api Key | Your Yellow.ai API key. Needed only for **Register Device** and **Unlink Device Token**. |
   | Push Notification | Sends this device's push token to the bot. Needs your Firebase setup (see below). |
   | Custom Base URL | Leave empty if your bot is in the default region. For other regions use `https://rx.cloud.yellow.ai` (for example `https://r5.cloud.yellow.ai`), or your on-premise URL. |
   | Payload | Any JSON object you want to send to the bot when the chat starts, such as user details. Must be valid JSON. |

   Fields marked v3 only or v1/v2 only appear when you pick that version.

3. Tap **Save**, then tap the profile:
   - **Start Bot** opens the chat with this profile's settings.
   - **Register Device** links this device to the user for push notifications. Shown when Api Key, YMAuthToken and Push Notification are set.
   - **Unlink Device Token** stops push notifications to this device, for example on logout. Shown when Api Key and Push Notification are set.
   - **Edit** / **Delete**

### Info

Shows the app version and the YMChatbot-iOS SDK version.

## Push notifications (optional)

To test push notifications from your bot:

1. In your own [Firebase project](https://console.firebase.google.com), add an iOS app with the bundle ID `ai.yellow.demoapp`, or change the app's bundle ID in Xcode to one you own. Push on a real device needs a bundle ID and signing team from your Apple Developer account.
2. Upload your APNs key to Firebase.
3. Download its `GoogleService-Info.plist` and put it in the `Yellow Bot/` folder. You don't need to add it in Xcode; the build picks it up from there. It's gitignored, so it won't be committed.
4. Map your Firebase service account key to your Bot ID, as described in [Push notifications for mobile SDKs](https://docs.yellow.ai/docs/platform_concepts/mobile/chatbot/sdk-faq-worflows/push-notifications-sdks).
5. Run on a device, turn on **Push Notification** in a profile, and use **Register Device**.

## Integration code to reuse

All SDK calls are in a few files under `Yellow Bot/`:

| File | What to look at |
|---|---|
| `BotModel.swift` | Building a `YMConfig` from your settings (`toYMConfig`) |
| `QuickStartViewController.swift` | The smallest possible integration: set a Bot ID and start the bot |
| `ProfileListTableViewController.swift` | Starting the bot with a full config, registering and unlinking the device |
| `AppDelegate.swift` | Setting up Firebase and getting the push token |

## Help

- [iOS SDK docs](https://docs.yellow.ai/docs/platform_concepts/mobile/chatbot/ios)
- [Mobile SDK FAQ](https://docs.yellow.ai/docs/platform_concepts/mobile/chatbot/sdk-faq-worflows/mobile-sdk-faq)
- Email [apps@yellow.ai](mailto:apps@yellow.ai)
