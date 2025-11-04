import SwiftUI
import Combine

class LanguageManager: ObservableObject {
    @Published var currentLanguage: Language {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "selectedLanguage")
        }
    }
    
    enum Language: String, CaseIterable {
        case german = "de"
        case english = "en"
        
        var displayName: String {
            switch self {
            case .german: return "Deutsch"
            case .english: return "English"
            }
        }
        
        var flag: String {
            switch self {
            case .german: return "🇩🇪"
            case .english: return "🇬🇧"
            }
        }
    }
    
    static let shared = LanguageManager()
    
    private init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let language = Language(rawValue: savedLanguage) {
            self.currentLanguage = language
        } else {
            self.currentLanguage = .german
        }
    }
}

// MARK: - Localized Strings

extension String {
    func localized(_ language: LanguageManager.Language) -> String {
        guard let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return self
        }
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}

// MARK: - Localization Keys

struct LocalizedStrings {
    // ContentView
    static let chooseYourJacks = "choose_your_jacks"
    static let tapCards = "tap_cards"
    static let selected = "selected"
    static let jack = "jack"
    static let jacks = "jacks"
    static let jackLetter = "jack_letter"
    static let calculateReizwert = "calculate_reizwert"
    
    // Card Names
    static let kreuz = "kreuz"
    static let pik = "pik"
    static let herz = "herz"
    static let karo = "karo"
    
    // SkatCalculatorView
    static let reizwert = "reizwert"
    static let mit = "mit"
    static let ohne = "ohne"
    static let spiel = "spiel"
    
    // Game Types
    static let farbspiel = "farbspiel"
    static let grand = "grand"
    static let nullspiel = "nullspiel"
    static let saechsischeSpitze = "saechsische_spitze"
    static let spielart = "spielart"
    
    // Additional Options
    static let zusatzansagen = "zusatzansagen"
    static let hand = "hand"
    static let ouvert = "ouvert"
    static let schneider = "schneider"
    static let schneiderAngesagt = "schneider_angesagt"
    static let schwarz = "schwarz"
    static let schwarzAngesagt = "schwarz_angesagt"
    
    // Settings
    static let settings = "settings"
    static let language = "language"
    static let selectLanguage = "select_language"
    static let about = "about"
    static let appVersion = "app_version"
    static let appDescription = "app_description"
    static let privacyPolicy = "privacy_policy"
    
    // Privacy Policy
    static let lastUpdated = "last_updated"
    static let privacyIntroTitle = "privacy_intro_title"
    static let privacyIntroText = "privacy_intro_text"
    static let dataCollectionTitle = "data_collection_title"
    static let dataCollectionText = "data_collection_text"
    static let dataUsageTitle = "data_usage_title"
    static let dataUsageText = "data_usage_text"
    static let dataStorageTitle = "data_storage_title"
    static let dataStorageText = "data_storage_text"
    static let userRightsTitle = "user_rights_title"
    static let userRightsText = "user_rights_text"
    static let changesTitle = "changes_title"
    static let changesText = "changes_text"
}

