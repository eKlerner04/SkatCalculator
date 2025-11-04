import SwiftUI

struct SkatCalculatorView: View {
    let hasCrossJack: Bool
    let hasPikJack: Bool
    let hasHeartJack: Bool
    let hasDiamondJack: Bool
    
    @State private var Farbspiel = false
    @State private var FarbspielClub = false
    @State private var FarbspielSpade = false
    @State private var FarbspielHeart = false
    @State private var FarbspielDiamond = false
    
    @State private var Grand = false
    @State private var Nullspiel = false
    @State private var SäsischeSpitze = false
    
    @State private var hand = false
    @State private var ouvert = false
    @State private var schneider = false
    @State private var schneiderAngesagt = false
    @State private var schwarz = false
    @State private var schwarzAngesagt = false
    
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
                VStack(spacing: 24) {
                    reizwertCard
                    
                    bubenAnzeige
                    
                    spielartSection
                    
                    zusatzansagenSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
        .navigationTitle(LocalizedStrings.reizwert.localized(languageManager.currentLanguage))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(darkGreen.opacity(0.95), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        #endif
    }
    
    
    // MARK: - Berechnungslogik
                
                var mit: Int {
                    if hasCrossJack && hasPikJack && hasHeartJack && hasDiamondJack { return 4 }
                    else if hasCrossJack && hasPikJack && hasHeartJack { return 3 }
                    else if hasCrossJack && hasPikJack { return 2 }
                    else if hasCrossJack { return 1 }
                    else { return 0 }
                }
                
                var ohne: Int {
                    if !hasCrossJack && !hasPikJack && !hasHeartJack && !hasDiamondJack { return 4 }
                    else if !hasCrossJack && !hasPikJack && !hasHeartJack { return 3 }
                    else if !hasCrossJack && !hasPikJack { return 2 }
                    else if !hasCrossJack { return 1 }
                    else { return 0 }
                }
                
                var spielwert: Int {
                    max(mit, ohne) + 1
                }
                
                var mitS: Int {
                    if hasDiamondJack && hasHeartJack && hasPikJack && hasCrossJack { return 4 }
                    else if hasDiamondJack && hasHeartJack && hasPikJack { return 3 }
                    else if hasDiamondJack && hasHeartJack { return 2 }
                    else if hasDiamondJack { return 1 }
                    else { return 0 }
                }
                
                var ohneS: Int {
                    if !hasDiamondJack && !hasHeartJack && !hasPikJack && !hasCrossJack { return 4 }
                    else if !hasDiamondJack && !hasHeartJack && !hasPikJack { return 3 }
                    else if !hasDiamondJack && !hasHeartJack { return 2 }
                    else if !hasDiamondJack { return 1 }
                    else { return 0 }
                }
                
                var spielwertS: Int {
                    max(mitS, ohneS) + 1
                }
                
                var multiplikatorZusatz: Int {
                    var m = 0
                    if hand { m += 1 }
                    
                    if schwarzAngesagt { m += 3 }
                    else if schwarz { m += 2 }
                    else if schneiderAngesagt { m += 2 }
                    else if schneider { m += 1 }
                    
                    if ouvert && !Nullspiel { m += 1 }
                    return m
                }
                
                var effektiverSpielwert: Int {
                    let basis = SäsischeSpitze ? spielwertS : spielwert
                    return basis + multiplikatorZusatz
                }
                
                var Reizwert: Int {
                    if Nullspiel {
                        if ouvert { return 59 }
                        if hand { return 35 }
                        return 23
                    }
                    
                    if SäsischeSpitze { return effektiverSpielwert * 20 }
                    if Grand { return effektiverSpielwert * 24 }
                    if FarbspielClub { return effektiverSpielwert * 12 }
                    if FarbspielSpade { return effektiverSpielwert * 11 }
                    if FarbspielHeart { return effektiverSpielwert * 10 }
                    if FarbspielDiamond { return effektiverSpielwert * 9 }
                    
                    return 0
                }
                
    var aktMit: Int { SäsischeSpitze ? mitS : mit }
    var aktOhne: Int { SäsischeSpitze ? ohneS : ohne }
    var aktText: String {
        if aktMit > aktOhne {
            return "\(LocalizedStrings.mit.localized(languageManager.currentLanguage)) \(aktMit)"
        } else {
            return "\(LocalizedStrings.ohne.localized(languageManager.currentLanguage)) \(aktOhne)"
        }
    }
    
    // MARK: - View Components
    
    var reizwertCard: some View {
        VStack(spacing: 16) {
            Text(Reizwert == 0 ? "—" : "\(Reizwert)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(goldAccent)
            
            Text(LocalizedStrings.reizwert.localized(languageManager.currentLanguage))
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(cardWhite.opacity(0.8))
            
            if Reizwert > 0 {
                Divider()
                    .background(cardWhite.opacity(0.3))
                    .padding(.horizontal, 40)
                
                if Nullspiel {
                    Text(LocalizedStrings.nullspiel.localized(languageManager.currentLanguage))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(cardWhite)
                } else {
                    VStack(spacing: 6) {
                        Text("\(aktText) • \(LocalizedStrings.spiel.localized(languageManager.currentLanguage)) \(effektiverSpielwert)")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(cardWhite)
                        
                        if let spielart = getCurrentSpielart() {
                            Text(spielart)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(cardWhite.opacity(0.7))
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(darkGreen.opacity(0.8))
                .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(goldAccent.opacity(0.3), lineWidth: 1)
        )
    }
    
    var bubenAnzeige: some View {
        HStack(spacing: 20) {
            jackIcon("suit.club.fill", hasJack: hasCrossJack, color: .white)
            jackIcon("suit.spade.fill", hasJack: hasPikJack, color: .white)
            jackIcon("suit.heart.fill", hasJack: hasHeartJack, color: .red)
            jackIcon("suit.diamond.fill", hasJack: hasDiamondJack, color: .red)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(cardWhite.opacity(0.1))
        )
    }
    
    var spielartSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: LocalizedStrings.spielart.localized(languageManager.currentLanguage), icon: "suit.spade")
            
            VStack(spacing: 10) {
                GameTypeButton(
                    title: LocalizedStrings.farbspiel.localized(languageManager.currentLanguage),
                    isSelected: Farbspiel,
                    goldAccent: goldAccent
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        switchGame(.farbspiel)
                    }
                }
                
                    if Farbspiel {
                    HStack(spacing: 12) {
                        SuitSelectionButton(icon: "suit.club.fill", color: .white, isSelected: FarbspielClub, goldAccent: goldAccent) {
                            selectFarbspiel(.club)
                        }
                        SuitSelectionButton(icon: "suit.spade.fill", color: .white, isSelected: FarbspielSpade, goldAccent: goldAccent) {
                            selectFarbspiel(.spade)
                        }
                        SuitSelectionButton(icon: "suit.heart.fill", color: .red, isSelected: FarbspielHeart, goldAccent: goldAccent) {
                            selectFarbspiel(.heart)
                        }
                        SuitSelectionButton(icon: "suit.diamond.fill", color: .red, isSelected: FarbspielDiamond, goldAccent: goldAccent) {
                            selectFarbspiel(.diamond)
                        }
                    }
                    .padding(.horizontal, 8)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                GameTypeButton(
                    title: LocalizedStrings.grand.localized(languageManager.currentLanguage),
                    isSelected: Grand,
                    goldAccent: goldAccent
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        switchGame(.grand)
                    }
                }
                
                GameTypeButton(
                    title: LocalizedStrings.nullspiel.localized(languageManager.currentLanguage),
                    isSelected: Nullspiel,
                    goldAccent: goldAccent
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        switchGame(.nullspiel)
                    }
                }
                
                GameTypeButton(
                    title: LocalizedStrings.saechsischeSpitze.localized(languageManager.currentLanguage),
                    isSelected: SäsischeSpitze,
                    goldAccent: goldAccent
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        switchGame(.saechsisch)
                    }
                }
            }
        }
    }
    
    var zusatzansagenSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: LocalizedStrings.zusatzansagen.localized(languageManager.currentLanguage), icon: "star.fill")
            
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    ToggleChipButton(title: LocalizedStrings.hand.localized(languageManager.currentLanguage), isActive: hand, goldAccent: goldAccent) {
                        withAnimation {
                            hand.toggle()
                            if ouvert { hand = true }
                        }
                    }
                    ToggleChipButton(title: LocalizedStrings.ouvert.localized(languageManager.currentLanguage), isActive: ouvert, goldAccent: goldAccent) {
                        withAnimation {
                            ouvert.toggle()
                            if ouvert { hand = true }
                        }
                    }
                }
                
                HStack(spacing: 10) {
                    ToggleChipButton(title: LocalizedStrings.schneider.localized(languageManager.currentLanguage), isActive: schneider, goldAccent: goldAccent) {
                        withAnimation {
                            schneider.toggle()
                            if schneider {
                                schneiderAngesagt = false
                                schwarz = false
                                schwarzAngesagt = false
                            }
                        }
                    }
                    ToggleChipButton(title: LocalizedStrings.schneiderAngesagt.localized(languageManager.currentLanguage), isActive: schneiderAngesagt, goldAccent: goldAccent) {
                        withAnimation {
                            schneiderAngesagt.toggle()
                            if schneiderAngesagt {
                                schneider = false
                                schwarz = false
                                schwarzAngesagt = false
                            }
                        }
                    }
                }
                
                HStack(spacing: 10) {
                    ToggleChipButton(title: LocalizedStrings.schwarz.localized(languageManager.currentLanguage), isActive: schwarz, goldAccent: goldAccent) {
                        withAnimation {
                            schwarz.toggle()
                            if schwarz {
                                schneider = false
                                schneiderAngesagt = false
                                schwarzAngesagt = false
                            }
                        }
                    }
                    ToggleChipButton(title: LocalizedStrings.schwarzAngesagt.localized(languageManager.currentLanguage), isActive: schwarzAngesagt, goldAccent: goldAccent) {
                        withAnimation {
                            schwarzAngesagt.toggle()
                            if schwarzAngesagt {
                                schwarz = false
                                schneider = false
                                schneiderAngesagt = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Views
    
    func jackIcon(_ suit: String, hasJack: Bool, color: Color) -> some View {
        VStack(spacing: 4) {
            if hasJack {
                Image(systemName: suit)
                    .font(.system(size: 32))
                    .foregroundColor(color)
            } else {
                Text("—")
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(cardWhite.opacity(0.3))
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Helper Functions
    
    enum GameOption { case farbspiel, grand, nullspiel, saechsisch }
    enum Suit { case club, spade, heart, diamond }
    
    func switchGame(_ option: GameOption) {
        Farbspiel = false; FarbspielClub = false; FarbspielSpade = false
        FarbspielHeart = false; FarbspielDiamond = false
        Grand = false; Nullspiel = false; SäsischeSpitze = false
        
        switch option {
        case .farbspiel: Farbspiel = true
        case .grand: Grand = true
        case .nullspiel: Nullspiel = true
        case .saechsisch: SäsischeSpitze = true
        }
        
        if option == .nullspiel {
            schneider = false
            schneiderAngesagt = false
            schwarz = false
            schwarzAngesagt = false
        }
    }
    
    func selectFarbspiel(_ suit: Suit) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            FarbspielClub = false
            FarbspielSpade = false
            FarbspielHeart = false
            FarbspielDiamond = false
            
            switch suit {
            case .club: FarbspielClub = true
            case .spade: FarbspielSpade = true
            case .heart: FarbspielHeart = true
            case .diamond: FarbspielDiamond = true
            }
        }
    }
    
    func getCurrentSpielart() -> String? {
        if FarbspielClub { return "\(LocalizedStrings.kreuz.localized(languageManager.currentLanguage)) (×12)" }
        if FarbspielSpade { return "\(LocalizedStrings.pik.localized(languageManager.currentLanguage)) (×11)" }
        if FarbspielHeart { return "\(LocalizedStrings.herz.localized(languageManager.currentLanguage)) (×10)" }
        if FarbspielDiamond { return "\(LocalizedStrings.karo.localized(languageManager.currentLanguage)) (×9)" }
        if Grand { return "\(LocalizedStrings.grand.localized(languageManager.currentLanguage)) (×24)" }
        if SäsischeSpitze { return "\(LocalizedStrings.saechsischeSpitze.localized(languageManager.currentLanguage)) (×20)" }
        return nil
    }
}

// MARK: - Custom Components

struct SectionHeader: View {
    let title: String
    let icon: String
    private let goldAccent = Color(red: 0.85, green: 0.65, blue: 0.13)
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(goldAccent)
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.bottom, 4)
    }
}

struct GameTypeButton: View {
    let title: String
    let isSelected: Bool
    let goldAccent: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(isSelected ? Color(red: 0.05, green: 0.25, blue: 0.18) : .white)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(red: 0.05, green: 0.25, blue: 0.18))
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? goldAccent : Color.white.opacity(0.1))
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct SuitSelectionButton: View {
    let icon: String
    let color: Color
    let isSelected: Bool
    let goldAccent: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(isSelected ? Color(red: 0.05, green: 0.25, blue: 0.18) : color)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? goldAccent : Color.white.opacity(0.15))
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ToggleChipButton: View {
    let title: String
    let isActive: Bool
    let goldAccent: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(isActive ? Color(red: 0.05, green: 0.25, blue: 0.18) : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isActive ? goldAccent : Color.white.opacity(0.1))
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    SkatCalculatorView(hasCrossJack: true, hasPikJack: true, hasHeartJack: false, hasDiamondJack: true)
}
