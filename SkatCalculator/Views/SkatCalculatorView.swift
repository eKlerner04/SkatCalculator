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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                
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
                
                let aktMit = SäsischeSpitze ? mitS : mit
                let aktOhne = SäsischeSpitze ? ohneS : ohne
                let aktText = aktMit > aktOhne ? "Mit \(aktMit)" : "Ohne \(aktOhne)"
                
                Text("Reizwert: \(Reizwert)")
                    .font(.title2).bold()
                
                if Nullspiel {
                    Text("Nullspiel")
                } else {
                    Text("\(aktText) • Spiel \(effektiverSpielwert)")
                }
                
                HStack {
                    if hasCrossJack{
                        Image(systemName: "suit.club.fill")
                    } else {
                        Text("/")
                    }
                    if hasPikJack {
                        Image(systemName: "suit.spade.fill")
                    } else {
                        Text("/")
                    }
                    
                    if hasHeartJack{
                        Image(systemName: "suit.heart.fill").foregroundColor(.red)
                    } else {
                        Text("/")
                    }
                    
                    if hasDiamondJack{
                        Image(systemName: "suit.diamond.fill").foregroundColor(.red)
                    }else {
                        Text("/")
                    }
                }
                .font(.title)
                
                Group {
                    Button { switchGame(.farbspiel) } label: { textButton("Farbspiel", active: Farbspiel) }
                    if Farbspiel {
                        HStack {
                            suitButton("suit.club.fill", active: $FarbspielClub)
                            suitButton("suit.spade.fill", active: $FarbspielSpade)
                            suitButton("suit.heart.fill", active: $FarbspielHeart, color: .red)
                            suitButton("suit.diamond.fill", active: $FarbspielDiamond, color: .red)
                        }
                    }
                    
                    Button {
                        switchGame(.grand)
                    } label: { textButton("Grand", active: Grand) }
                    Button {
                        switchGame(.nullspiel) } label:  { textButton("Nullspiel", active: Nullspiel) }
                    Button { switchGame(.saechsisch) } label: { textButton("Sächsische Spitze", active: SäsischeSpitze) }
                }
                
                // MARK: Zusatzansagen
                VStack {
                    HStack {
                        toggleButton("Hand", flag: $hand, after: { if ouvert { hand = true } })
                        toggleButton("Ouvert", flag: $ouvert, after: { if ouvert { hand = true } })
                    }
                    HStack {
                        toggleButton("Schneider", flag: $schneider) {
                            schneiderAngesagt = false; schwarz = false; schwarzAngesagt = false
                        }
                        toggleButton("Schneider anges.", flag: $schneiderAngesagt) {
                            schneider = false; schwarz = false; schwarzAngesagt = false
                        }
                    }
                    HStack {
                        toggleButton("Schwarz", flag: $schwarz) {
                            schneider = false; schneiderAngesagt = false; schwarzAngesagt = false
                        }
                        toggleButton("Schwarz anges.", flag: $schwarzAngesagt) {
                            schwarz = false; schneider = false; schneiderAngesagt = false
                        }
                    }
                }
                
            }
            .navigationTitle("Reiz Calculator")
            .padding()
        }
    }
    
    
    func textButton(_ label: String, active: Bool) -> some View {
        Text(label)
            .padding(6)
            .overlay(active ? RoundedRectangle(cornerRadius: 8).stroke(.green, lineWidth: 2) : nil)
    }
    
    func suitButton(_ icon: String, active: Binding<Bool>, color: Color = .black) -> some View {
        Button {
            FarbspielClub = false; FarbspielSpade = false; FarbspielHeart = false; FarbspielDiamond = false
            active.wrappedValue = true
        } label: {
            Image(systemName: icon)
                .padding(6)
                .foregroundStyle(color)
                .overlay(active.wrappedValue ? RoundedRectangle(cornerRadius: 8).stroke(.green, lineWidth: 2) : nil)
        }
    }
    
    enum GameOption { case farbspiel, grand, nullspiel, saechsisch }
    
    func switchGame(_ option: GameOption) {
        // Reset alles
        Farbspiel = false; FarbspielClub = false; FarbspielSpade = false
        FarbspielHeart = false; FarbspielDiamond = false
        Grand = false; Nullspiel = false; SäsischeSpitze = false
        
        switch option {
        case .farbspiel: Farbspiel = true
        case .grand: Grand = true
        case .nullspiel: Nullspiel = true
        case .saechsisch: SäsischeSpitze = true
        }
        
        if option == .nullspiel { schneider = false; schneiderAngesagt = false; schwarz = false; schwarzAngesagt = false }
    }
    
    func toggleButton(_ name: String, flag: Binding<Bool>, after: (() -> Void)? = nil) -> some View {
        Button {
            flag.wrappedValue.toggle()
            after?()
        } label: {
            Text(name)
                .padding(6)
                .overlay(flag.wrappedValue ? RoundedRectangle(cornerRadius: 8).stroke(.green, lineWidth: 2) : nil)
        }
    }
}

#Preview {
    SkatCalculatorView(hasCrossJack: true, hasPikJack: true, hasHeartJack: false, hasDiamondJack: true)
}
