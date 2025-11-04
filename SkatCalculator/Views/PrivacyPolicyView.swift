import SwiftUI

struct PrivacyPolicyView: View {
    @ObservedObject var languageManager = LanguageManager.shared
    
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
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    
                    privacyContent
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
        .navigationTitle(LocalizedStrings.privacyPolicy.localized(languageManager.currentLanguage))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(darkGreen.opacity(0.95), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        #endif
    }
    
    var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 60))
                .foregroundColor(goldAccent)
            
            Text(LocalizedStrings.privacyPolicy.localized(languageManager.currentLanguage))
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(cardWhite)
                .multilineTextAlignment(.center)
            
            Text(LocalizedStrings.lastUpdated.localized(languageManager.currentLanguage))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(cardWhite.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
    }
    
    var privacyContent: some View {
        VStack(spacing: 20) {
            PrivacySection(
                icon: "info.circle.fill",
                title: LocalizedStrings.privacyIntroTitle.localized(languageManager.currentLanguage),
                content: LocalizedStrings.privacyIntroText.localized(languageManager.currentLanguage),
                goldAccent: goldAccent,
                cardWhite: cardWhite,
                darkGreen: darkGreen
            )
            
            PrivacySection(
                icon: "tray.fill",
                title: LocalizedStrings.dataCollectionTitle.localized(languageManager.currentLanguage),
                content: LocalizedStrings.dataCollectionText.localized(languageManager.currentLanguage),
                goldAccent: goldAccent,
                cardWhite: cardWhite,
                darkGreen: darkGreen
            )
            
            PrivacySection(
                icon: "gear",
                title: LocalizedStrings.dataUsageTitle.localized(languageManager.currentLanguage),
                content: LocalizedStrings.dataUsageText.localized(languageManager.currentLanguage),
                goldAccent: goldAccent,
                cardWhite: cardWhite,
                darkGreen: darkGreen
            )
            
            PrivacySection(
                icon: "lock.fill",
                title: LocalizedStrings.dataStorageTitle.localized(languageManager.currentLanguage),
                content: LocalizedStrings.dataStorageText.localized(languageManager.currentLanguage),
                goldAccent: goldAccent,
                cardWhite: cardWhite,
                darkGreen: darkGreen
            )
            
            PrivacySection(
                icon: "person.fill.checkmark",
                title: LocalizedStrings.userRightsTitle.localized(languageManager.currentLanguage),
                content: LocalizedStrings.userRightsText.localized(languageManager.currentLanguage),
                goldAccent: goldAccent,
                cardWhite: cardWhite,
                darkGreen: darkGreen
            )
            
            PrivacySection(
                icon: "arrow.triangle.2.circlepath",
                title: LocalizedStrings.changesTitle.localized(languageManager.currentLanguage),
                content: LocalizedStrings.changesText.localized(languageManager.currentLanguage),
                goldAccent: goldAccent,
                cardWhite: cardWhite,
                darkGreen: darkGreen
            )
        }
    }
}

struct PrivacySection: View {
    let icon: String
    let title: String
    let content: String
    let goldAccent: Color
    let cardWhite: Color
    let darkGreen: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(goldAccent)
                
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(cardWhite)
            }
            
            Text(content)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(cardWhite.opacity(0.85))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(darkGreen.opacity(0.6))
        )
    }
}

#Preview {
    NavigationStack {
        PrivacyPolicyView()
    }
}

