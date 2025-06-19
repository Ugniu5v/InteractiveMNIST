import SwiftUI

struct BoardView: View {
    @State public var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 28), count: 28)
    @State private var lastPoint: CGPoint?
    @State private var prediction: Int = -1
    private let boardHelper = BoardHelper()
    
    var body: some View {
        VStack(spacing: 20) {
            Grid(horizontalSpacing: 1, verticalSpacing: 1) {
                ForEach(0..<28) { row in
                    GridRow {
                        ForEach(0..<28) { col in
                            Rectangle()
                                .fill(grid[row][col] == 0 ? .black : .white)
                                .border(Color.gray .opacity(0.2))
                                .frame(width: 10, height: 10)
                        }
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let cellSize: CGFloat = 10
                        let spacing: CGFloat = 1
                        let totalSize = cellSize + spacing
                        let location = value.location
                        let col = Int(location.x / totalSize)
                        let row = Int(location.y / totalSize)
                        
                        // Only update if within bounds
                        if row >= 0 && row < 28 && col >= 0 && col < 28 {
                            boardHelper.updateGrid(grid: &grid, row: row, col: col, lastPoint: lastPoint, totalSize: totalSize)
                            lastPoint = location
                        }
                    }
                    .onEnded { _ in
                        lastPoint = nil
                    }
            )
            
            HStack{
                Spacer()
                Button(action: {
                    boardHelper.clearGrid(grid: &grid)
                    prediction = -1
                }) {
                    Text("Clear")
                        .font(.headline.bold())
                        .foregroundColor(.black)
                        .frame(width: 100)
                        .padding()
                        .background(.red)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                }
                Spacer()
                
                Button(action: {
                    prediction = boardHelper.makeAPrediction(grid: grid)
                }) {
                    Text("Predict")
                        .font(.headline.bold())
                        .foregroundColor(.black)
                        .frame(width: 100)
                        .padding()
                        .background(.blue)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                }
                Spacer()

            }
                
            Text("Number predicted:  \(prediction) ")
                .font(.largeTitle)
                .padding(.top)
        }
    }
}

#Preview {
    BoardView()
}
