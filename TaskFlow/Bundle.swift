//
//  Bundle.swift
//  TaskFlow
//
//  Created by Mamita Gurung on 13.12.2024.
//

import Foundation

extension Bundle {
    /// Returns the bundle corresponding to the currently selected language, or the default bundle if unavailable.
    static var current: Bundle {
        guard let languageCode = UserDefaults.standard.string(forKey: "selectedLanguage"),
              let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return Bundle.main
        }
        return bundle
    }

    /// Fetches a localized string for the given key from the current bundle.
    /// - Parameters:
    ///   - key: The key for the localized string.
    ///   - value: A fallback value if the key is not found (optional).
    /// - Returns: The localized string or the fallback value if unavailable.
    static func localizedString(forKey key: String, value: String? = nil) -> String {
        return NSLocalizedString(key, tableName: nil, bundle: Bundle.current, value: value ?? "", comment: "")
    }

    /// Sets the application's language by saving the code to UserDefaults and updating the AppleLanguages setting.
    /// - Parameter languageCode: The ISO language code (e.g., "en", "fi").
    static func setLanguage(languageCode: String) {
        UserDefaults.standard.set(languageCode, forKey: "selectedLanguage")
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Post a notification to inform the app that the language has changed.
        NotificationCenter.default.post(name: .languageDidChange, object: nil)
    }
}

extension Notification.Name {
    /// Notification fired when the language changes.
    static let languageDidChange = Notification.Name("LanguageDidChangeNotification")
}







