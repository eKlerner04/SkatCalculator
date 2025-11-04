import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    @ObservedObject var languageManager = LanguageManager.shared
    
    private let pokerGreen = Color(red: 0.09, green: 0.35, blue: 0.25)
    private let darkGreen = Color(red: 0.05, green: 0.25, blue: 0.18)
    private let goldAccent = Color(red: 0.85, green: 0.65, blue: 0.13)
    
    var body: some View {
        VStack {
            if isActive {
                ContentView()
            } else {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [darkGreen, pokerGreen]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    VStack(spacing: 30) {
                        Image(systemName: "suit.club.fill")
                            .font(.system(size: 100))
                            .foregroundColor(goldAccent)
                            .scaleEffect(scale)
                            .opacity(opacity)
                        
                        Text("SkatCalculator")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .opacity(opacity)
                        
                        Text("♣️ ♠️ ♥️ ♦️ ")
                            .font(.system(size: 32))
                            .opacity(opacity)
                    }
                }
                .onAppear {
                    withAnimation(.easeOut(duration: 1.0)) {
                        scale = 1.0
                        opacity = 1.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
