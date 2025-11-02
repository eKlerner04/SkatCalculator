import SwiftUI

struct ContentView: View {
    @State private var hasCrossJack = false
    @State private var hasPikJack = false
    @State private var hasHeartJack = false
    @State private var hasDimondJack = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welche Buben hast du?")
                HStack{
                    Button {
                        if hasCrossJack{
                            hasCrossJack = false
                        } else {
                            hasCrossJack = true
                        }
                    } label: {
                        if hasCrossJack{
                            Image(systemName: "suit.club.fill")
                                .foregroundStyle(.black)
                                .padding(6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.green, lineWidth: 2)
                                )
                        } else {
                            Image(systemName: "suit.club.fill")
                                .foregroundStyle(.black)
                                .padding(6)
                        }
                    }
                    
                    Button {
                        if hasPikJack{
                            hasPikJack = false
                        } else{
                            hasPikJack = true
                        }
                    } label: {
                        if hasPikJack{
                            Image(systemName: "suit.spade.fill")
                                .foregroundStyle(.black)

                                .padding(6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.green, lineWidth: 2)
                                )
                        } else {
                            Image(systemName: "suit.spade.fill")
                                .foregroundStyle(.black)

                                .padding(6)
                        }
                    }
                    
                    Button {
                        if hasHeartJack{
                            hasHeartJack = false
                        } else{
                            hasHeartJack = true
                        }
                    } label: {
                        if hasHeartJack{
                            Image(systemName: "suit.heart.fill")
                                .foregroundStyle(.red)

                                .padding(6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.green, lineWidth: 2)
                                )
                        } else {
                            Image(systemName: "suit.heart.fill")
                                .foregroundStyle(.red)
                                .padding(6)
                        }
                    }
                    
                    Button {
                        if hasDimondJack{
                            hasDimondJack = false
                        } else {
                            hasDimondJack = true
                        }
                    } label: {
                        if hasDimondJack{
                            Image(systemName: "suit.diamond.fill")
                                .foregroundStyle(.red)
                                .padding(6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.green, lineWidth: 2)
                                )
                        } else {
                            Image(systemName: "suit.diamond.fill")
                                .foregroundStyle(.red)
                                .padding(6)
                        }
                    }
                    
                    
                }//HStack
                
                NavigationLink(destination: SkatCalculatorView(
                    hasCrossJack: hasCrossJack,
                    hasPikJack: hasPikJack,
                    hasHeartJack: hasHeartJack,
                    hasDiamondJack: hasDimondJack
                )) {
                    Text("Reiz wert berechnen")
                }
                
            }//VStack
            .navigationTitle("SkatCalculator")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
        }
    }
}

#Preview{
    ContentView()
}
