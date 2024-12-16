//
//  LanguageManager.swift
//  TaskFlow
//
//  Created by Anish Pun on 14.12.2024.
//

import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set([currentLanguage], forKey: "AppleLanguages")
            Bundle.setLanguage(currentLanguage)
        }
    }
    
    init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "AppleLanguages") {
            currentLanguage = savedLanguage
        } else {
            currentLanguage = "en" // Default to English
        }
    }
    
    func switchLanguage(to language: String) {
        currentLanguage = language
    }
    
    // Localized names for the language options
    func localizedLanguageName() -> String {
        switch currentLanguage {
        case "en":
            return NSLocalizedString("Language", comment: "Language heading in English")
        case "fi":
            return NSLocalizedString("Kieli", comment: "Language heading in Finnish")
        default:
            return NSLocalizedString("Language", comment: "Language heading in English")
        }
    }
        
    // Localized switch option names for the language options
    func localizedSwitchOptionName(for languageCode: String) -> String {
        switch languageCode {
        case "en":
            return NSLocalizedString("Finnish", comment: "Language option for Finnish")
        case "fi":
            return NSLocalizedString("Suomi", comment: "Language option for Finnish in English")
        default:
            return NSLocalizedString("Finnish", comment: "Language option for Finnish")
        }
    }
}

extension Bundle {
    private static var bundle: Bundle!
    
    class func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return
        }
        self.bundle = bundle
    }
    
    // This method fetches localized strings from the custom bundle
    class func localizedString(forKey key: String, value: String? = nil, table tableName: String? = nil) -> String {
        return bundle?.localizedString(forKey: key, value: value, table: tableName) ?? key
    }
}
