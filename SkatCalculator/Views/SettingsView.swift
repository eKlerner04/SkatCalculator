import SwiftUI

struct SettingsView: View {
    @ObservedObject var languageManager = LanguageManager.shared
    @Environment(\.dismiss) var dismiss
    
    private let pokerGreen = Color(red: 0.09, green: 0.35, blue: 0.25)
    private let darkGreen = Color(red: 0.05, green: 0.25, blue: 0.18)
    private let goldAccent = Color(red: 0.85, green: 0.65, blue: 0.13)
    private let cardWhite = Color.white
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [darkGreen, pokerGreen]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    languageSection
                    
                    privacySection
                    
                    aboutSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
        .navigationTitle(LocalizedStrings.settings.localized(languageManager.currentLanguage))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(darkGreen.opacity(0.95), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        #endif
    }
    
    var languageSection: some View {
        VStack(spacing: 12) {
            SectionHeader(
                title: LocalizedStrings.language.localized(languageManager.currentLanguage),
                icon: "globe"
            )
            
            VStack(spacing: 12) {
                Text(LocalizedStrings.selectLanguage.localized(languageManager.currentLanguage))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(cardWhite.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)
                
                ForEach(LanguageManager.Language.allCases, id: \.self) { language in
                    LanguageButton(
                        language: language,
                        isSelected: languageManager.currentLanguage == language,
                        goldAccent: goldAccent
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            languageManager.currentLanguage = language
                        }
                    }
                }
            }
        }
    }
    
    var privacySection: some View {
        VStack(spacing: 12) {
            SectionHeader(
                title: LocalizedStrings.privacyPolicy.localized(languageManager.currentLanguage),
                icon: "lock.shield"
            )
            
            NavigationLink(destination: PrivacyPolicyView()) {
                HStack(spacing: 16) {
                    Image(systemName: "hand.raised.fill")
                        .font(.system(size: 24))
                        .foregroundColor(goldAccent)
                    
                    Text(LocalizedStrings.privacyPolicy.localized(languageManager.currentLanguage))
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.1))
                )
            }
        }
    }
    
    var aboutSection: some View {
        VStack(spacing: 12) {
            SectionHeader(
                title: LocalizedStrings.about.localized(languageManager.currentLanguage),
                icon: "info.circle"
            )
            
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "suit.club.fill")
                        .font(.system(size: 50))
                        .foregroundColor(goldAccent)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("SkatCalculator")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(cardWhite)
                        
                        HStack(spacing: 6) {
                            Text(LocalizedStrings.appVersion.localized(languageManager.currentLanguage))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(cardWhite.opacity(0.6))
                            Text("1.0.0")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(goldAccent)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 8)
                
                Divider()
                    .background(cardWhite.opacity(0.2))
                
                Text(LocalizedStrings.appDescription.localized(languageManager.currentLanguage))
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(cardWhite.opacity(0.8))
                    .lineSpacing(4)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(darkGreen.opacity(0.6))
            )
        }
    }
}

struct LanguageButton: View {
    let language: LanguageManager.Language
    let isSelected: Bool
    let goldAccent: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(language.flag)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(language.displayName)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(isSelected ? Color(red: 0.05, green: 0.25, blue: 0.18) : .white)
                    
                    Text(language.rawValue.uppercased())
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(isSelected ? Color(red: 0.05, green: 0.25, blue: 0.18).opacity(0.7) : .white.opacity(0.5))
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(red: 0.05, green: 0.25, blue: 0.18))
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? goldAccent : Color.white.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? goldAccent.opacity(0.5) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
