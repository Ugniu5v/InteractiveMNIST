import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Draw a number")
                .font(.headline)
                .padding(.bottom)
            BoardView()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
