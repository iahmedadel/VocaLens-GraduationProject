import Foundation
import SwiftUI

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "language")
            updateLanguage()
        }
    }
    
    @Published var isRTL: Bool = false
    
    private init() {
        self.currentLanguage = UserDefaults.standard.string(forKey: "language") ?? "System"
        updateLanguage()
    }
    
    func updateLanguage() {
        if currentLanguage == "System" {
            if let languageCode = Locale.current.language.languageCode?.identifier {
                Bundle.setLanguage(languageCode)
                isRTL = languageCode == "ar"
            }
        } else {
            let languageCode = currentLanguage == "Arabic" ? "ar" : "en"
            Bundle.setLanguage(languageCode)
            isRTL = languageCode == "ar"
        }
        
        // Post notification to update UI
        NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
    }
}

extension Bundle {
    private static var bundle: Bundle!
    
    public static func localizedBundle() -> Bundle! {
        if bundle == nil {
            let appLang = UserDefaults.standard.string(forKey: "language") ?? "System"
            let language: String
            
            if appLang == "System" {
                language = Locale.current.language.languageCode?.identifier ?? "en"
            } else {
                language = appLang == "Arabic" ? "ar" : "en"
            }
            
            // Try to find the localization bundle
            if let path = Bundle.main.path(forResource: language, ofType: "lproj"),
               let languageBundle = Bundle(path: path) {
                bundle = languageBundle
            } else {
                // Fallback to main bundle if localization not found
                bundle = Bundle.main
            }
        }
        return bundle
    }
    
    public static func setLanguage(_ language: String) {
        if let path = Bundle.main.path(forResource: language, ofType: "lproj"),
           let languageBundle = Bundle(path: path) {
            bundle = languageBundle
        } else {
            // Fallback to main bundle if localization not found
            bundle = Bundle.main
        }
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.localizedBundle(), value: "", comment: "")
    }
} 