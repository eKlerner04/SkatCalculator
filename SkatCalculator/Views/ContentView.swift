import SwiftUI

struct ContentView: View {
    @State private var hasCrossJack = false
    @State private var hasPikJack = false
    @State private var hasHeartJack = false
    @State private var hasDimondJack = false
    @ObservedObject var languageManager = LanguageManager.shared
    
    private let pokerGreen = Color(red: 0.09, green: 0.35, blue: 0.25)
    private let darkGreen = Color(red: 0.05, green: 0.25, blue: 0.18)
    private let goldAccent = Color(red: 0.85, green: 0.65, blue: 0.13)
    private let cardWhite = Color.white
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [darkGreen, pokerGreen]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Image(systemName: "suit.club.fill")
                            .font(.system(size: 40))
                            .foregroundColor(goldAccent)
                        
                        Text(LocalizedStrings.chooseYourJacks.localized(languageManager.currentLanguage))
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(cardWhite)
                        
                        Text(LocalizedStrings.tapCards.localized(languageManager.currentLanguage))
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(cardWhite.opacity(0.7))
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 16) {
                            JackCardView(
                                suit: "suit.club.fill",
                                suitName: LocalizedStrings.kreuz.localized(languageManager.currentLanguage),
                                color: .black,
                                isSelected: hasCrossJack
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    hasCrossJack.toggle()
                                }
                            }
                            
                            JackCardView(
                                suit: "suit.spade.fill",
                                suitName: LocalizedStrings.pik.localized(languageManager.currentLanguage),
                                color: .black,
                                isSelected: hasPikJack
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    hasPikJack.toggle()
                                }
                            }
                        }
                        
                        HStack(spacing: 16) {
                            JackCardView(
                                suit: "suit.heart.fill",
                                suitName: LocalizedStrings.herz.localized(languageManager.currentLanguage),
                                color: .red,
                                isSelected: hasHeartJack
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    hasHeartJack.toggle()
                                }
                            }
                            
                            JackCardView(
                                suit: "suit.diamond.fill",
                                suitName: LocalizedStrings.karo.localized(languageManager.currentLanguage),
                                color: .red,
                                isSelected: hasDimondJack
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    hasDimondJack.toggle()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if hasCrossJack || hasPikJack || hasHeartJack || hasDimondJack {
                        VStack(spacing: 10) {
                            Text("\(LocalizedStrings.selected.localized(languageManager.currentLanguage)): \(selectedJacksCount)")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(goldAccent)
                            
                            HStack(spacing: 12) {
                                if hasCrossJack {
                                    selectedBadge(suit: "suit.club.fill", color: .white)
                                }
                                if hasPikJack {
                                    selectedBadge(suit: "suit.spade.fill", color: .white)
                                }
                                if hasHeartJack {
                                    selectedBadge(suit: "suit.heart.fill", color: .red)
                                }
                                if hasDimondJack {
                                    selectedBadge(suit: "suit.diamond.fill", color: .red)
                                }
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(darkGreen.opacity(0.6))
                        )
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: SkatCalculatorView(
                        hasCrossJack: hasCrossJack,
                        hasPikJack: hasPikJack,
                        hasHeartJack: hasHeartJack,
                        hasDiamondJack: hasDimondJack
                    )) {
                        HStack {
                            Text(LocalizedStrings.calculateReizwert.localized(languageManager.currentLanguage))
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(pokerGreen)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [goldAccent, goldAccent.opacity(0.9)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(30)
                        .shadow(color: goldAccent.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(goldAccent)
                            .font(.system(size: 20))
                    }
                }
            }
            #if os(iOS)
            .toolbarBackground(.hidden, for: .navigationBar)
            #endif
        }
    }
    
    private var selectedJacksCount: String {
        let count = [hasCrossJack, hasPikJack, hasHeartJack, hasDimondJack].filter { $0 }.count
        let jackWord = count == 1 ? LocalizedStrings.jack.localized(languageManager.currentLanguage) : LocalizedStrings.jacks.localized(languageManager.currentLanguage)
        return "\(count) \(jackWord)"
    }
    
    private func selectedBadge(suit: String, color: Color) -> some View {
        Image(systemName: suit)
            .font(.system(size: 20))
            .foregroundColor(color)
    }
}

// MARK: - Jack Card Component
struct JackCardView: View {
    let suit: String
    let suitName: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    @ObservedObject var languageManager = LanguageManager.shared
    private let goldAccent = Color(red: 0.85, green: 0.65, blue: 0.13)
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: suit)
                    .font(.system(size: 50))
                    .foregroundColor(isSelected ? goldAccent : color)
                
                Text(LocalizedStrings.jackLetter.localized(languageManager.currentLanguage))
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(isSelected ? goldAccent : .black.opacity(0.8))
                
                Text(suitName)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(
                        color: isSelected ? goldAccent.opacity(0.6) : Color.black.opacity(0.15),
                        radius: isSelected ? 15 : 8,
                        x: 0,
                        y: isSelected ? 8 : 4
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected ? goldAccent : Color.clear,
                        lineWidth: isSelected ? 4 : 0
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .rotationEffect(.degrees(isSelected ? 2 : 0))
        }
        .buttonStyle(CardButtonStyle())
    }
}

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    ContentView()
}
