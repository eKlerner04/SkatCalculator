import SwiftUI


struct SplashScreenView: View {
    @State private var isActive = false
    var body: some View {
        VStack {
            if isActive {
                ContentView()
            } else {
                VStack{
                    Text("Willkommen")
                }
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation{
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
