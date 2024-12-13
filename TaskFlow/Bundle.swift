//
//  Bundle.swift
//  TaskFlow
//
//  Created by Mamita Gurung on 13.12.2024.
//

import Foundation

extension Bundle {
    static var current: Bundle {
        let languageCode = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        let path = Bundle.main.path(forResource: languageCode, ofType: "lproj")!
        return Bundle(path: path)!
    }

    static func localizedString(forKey key: String) -> String {
        return NSLocalizedString(key, tableName: nil, bundle: Bundle.current, value: "", comment: "")
    }
    
    static func setLanguage(languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}






