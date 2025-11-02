import SwiftUI

struct SkatCalculatorView: View{
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
    
    
    
    
    
    var body: some View{
        NavigationStack{
            VStack {
                
                
        
                
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
                    if (mit+1) > (ohne+1){
                        return mit+1
                    } else{
                        return ohne+1
                    }
                }
                
                
                var mitSäsischeSpitze: Int {
                    if hasDiamondJack && hasHeartJack && hasPikJack && hasCrossJack {
                        return 4
                    } else if hasDiamondJack && hasHeartJack && hasPikJack {
                        return 3
                    } else if hasDiamondJack && hasHeartJack {
                        return 2
                    } else if hasDiamondJack {
                        return 1
                    } else {
                        return 0
                    }
                }
                
                var ohneSäsischeSpitze: Int{
                    if !hasDiamondJack && !hasHeartJack && !hasPikJack && !hasCrossJack {
                        return 4
                    } else if !hasDiamondJack && !hasHeartJack && !hasPikJack{
                        return 3
                    } else if !hasDiamondJack && !hasHeartJack {
                        return 2
                    } else if !hasDiamondJack {
                        return 1
                    } else {
                        return 0
                    }
                }
                
                var spielwertSäsischeSpitze: Int {
                    if (mitSäsischeSpitze+1) > (ohneSäsischeSpitze+1) {
                        return mitSäsischeSpitze+1
                    } else {
                        return ohneSäsischeSpitze+1
                    }
                }

                
                
                var mitOrOhneSäsischeSpitze: String {
                    if mit > ohne {
                        return "Mit"
                    } else {
                        return "Ohne"
                    }
                }
                
                var mitOrOhne: String {
                    if mit > ohne{
                        return "Mit"
                    } else {
                        return "Ohne"
                    }
                }
                
                var Reizwert: Int {
                    let wert = SäsischeSpitze ? spielwertSäsischeSpitze : spielwert
                    
                    if Nullspiel { return 23 }
                    if SäsischeSpitze { return spielwertSäsischeSpitze * 20 }
                    if Grand { return spielwert * 24 }

                    if FarbspielClub { return spielwert * 12 }
                    if FarbspielSpade { return spielwert * 11 }
                    if FarbspielHeart { return spielwert * 10 }
                    if FarbspielDiamond { return spielwert * 9 }
                    return 0
                }

                
                var aktMit: Int {
                    SäsischeSpitze ? mitSäsischeSpitze : mit
                }

                var aktOhne: Int {
                    SäsischeSpitze ? ohneSäsischeSpitze : ohne
                }

                var aktMitOderOhne: String {
                    aktMit > aktOhne ? "Mit" : "Ohne"
                }

                var aktSpielwert: Int {
                    max(aktMit, aktOhne) + 1
                }
                
                
                
                Text("Reizwert ist: \(Reizwert)")

                if Nullspiel {
                    Text("Nullspiel")
                } else {
                    Text("\(aktMitOderOhne) \(aktMitOderOhne == "Mit" ? aktMit : aktOhne) Spiel \(aktSpielwert)")
                }


                
                HStack{
                    if hasCrossJack{
                        Image(systemName: "suit.club.fill")
                    }else {
                        Text("/")
                    }
                    
                    if hasPikJack{
                        Image(systemName: "suit.spade.fill")
                    } else {
                        Text("/")
                    }
                    
                    if hasHeartJack {
                        Image(systemName: "suit.heart.fill")
                            .foregroundColor(.red)
                    } else {
                        Text("/")
                    }
                    if hasDiamondJack {
                        Image(systemName: "suit.diamond.fill")
                            .foregroundColor(.red)
                    } else {
                        Text("/")
                    }
                }
                
                
                
                Button{
                    Grand = false
                    Nullspiel = false
                    SäsischeSpitze = false
                    
                    if Farbspiel{
                        Farbspiel = false
                    } else {
                        Farbspiel = true
                    }
                }label: {
                    Text("Farbspiel")
                        .padding(6)
                }
                
                if Farbspiel{
                    HStack{
                        Button{
                            FarbspielClub = true
                            FarbspielSpade = false
                            FarbspielDiamond = false
                            FarbspielHeart = false
                        } label:{
                            if FarbspielClub{
                                Image(systemName: "suit.club.fill")
                                    .foregroundStyle(.black)
                                    .padding(6)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.green, lineWidth: 2)
                                    )
                            } else {
                                Image(systemName: "suit.club.fill")
                                    .padding(6)
                                    .foregroundStyle(.black)
                            }
                        }
                        
                        Button{
                            FarbspielSpade = true
                            FarbspielClub = false
                            FarbspielDiamond = false
                            FarbspielHeart = false
                        } label:{
                            if FarbspielSpade {
                                Image(systemName: "suit.spade.fill")
                                    .padding(6)
                                    .foregroundStyle(.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.green, lineWidth: 2)
                                    )
                            } else {
                                Image(systemName: "suit.spade.fill")
                                    .padding(6)
                                    .foregroundStyle(.black)
                            }
                        }
                        
                        Button{
                            FarbspielHeart = true
                            FarbspielClub = false
                            FarbspielSpade = false
                            FarbspielDiamond = false
                            
                        } label:{
                            if FarbspielHeart {
                                Image(systemName: "suit.heart.fill")
                                    .padding(6)
                                    .foregroundStyle(.red)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.green, lineWidth: 2)
                                    )
                            } else {
                                Image(systemName: "suit.heart.fill")
                                    .padding(6)
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        
                        Button{
                            FarbspielDiamond = true
                            FarbspielClub = false
                            FarbspielSpade = false
                            FarbspielHeart = false
                            
                        } label:{
                            if FarbspielDiamond {
                                Image(systemName: "suit.diamond.fill")
                                    .padding(6)
                                    .foregroundStyle(.red)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.green, lineWidth: 2)
                                    )
                            } else {
                                Image(systemName: "suit.diamond.fill")
                                    .padding(6)
                                    .foregroundStyle(.red)
                            }
                        }
                        
                    }
                }
                
                Button{
                    Farbspiel = false
                    Nullspiel = false
                    SäsischeSpitze = false
                    if Grand {
                        Grand = false
                    } else {
                        Grand = true
                    }
                } label:{
                    if Grand {
                        Text("Grand")
                            .padding(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.green, lineWidth: 2)
                            )
                    } else{
                        Text("Grand")
                            .padding(6)
                    }
                }
                
                
                Button {
                    Farbspiel = false
                    Grand = false
                    SäsischeSpitze = false
                    if Nullspiel{
                        Nullspiel = false
                    } else{
                        Nullspiel = true
                    }
                } label:{
                    if Nullspiel{
                        Text("Nullspiel")
                            .padding(6)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.green, lineWidth: 2)
                            )
                    } else{
                        Text("Nullspiel")
                            .padding(6)
                    }
                }
                
                Button {
                    Farbspiel = false
                    Grand = false
                    Nullspiel = false
                    
                    if SäsischeSpitze{
                        SäsischeSpitze = false
                    } else {
                        SäsischeSpitze = true
                    }
                } label: {
                    if SäsischeSpitze{
                        Text("Säsische Spitze")
                            .padding(6)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.green, lineWidth: 2))
                    } else {
                        Text("Säsische Spitze")
                            .padding(6)
                    }
                }
                
                
                    
            }
            .navigationTitle("Reiz Calculator")
        }
    }
}

#Preview {
    SkatCalculatorView(hasCrossJack: true, hasPikJack: true, hasHeartJack: false, hasDiamondJack: true)
}



