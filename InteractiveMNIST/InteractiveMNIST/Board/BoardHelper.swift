import Foundation
import UIKit
import CoreGraphics

class BoardHelper {
    private let brushSize: Int = 1
    
    func updateGrid(grid: inout [[Int]], row: Int, col: Int, lastPoint: CGPoint?, totalSize: CGFloat) {
        // Draw a thicker brush
        for i in -brushSize...brushSize {
            for j in -brushSize...brushSize {
                let newRow = row + i
                let newCol = col + j
                if newRow >= 0, newRow < 28, newCol >= 0, newCol < 28 {
                    grid[newRow][newCol] = 1
                }
            }
        }
    }
    
    func clearGrid(grid: inout [[Int]]) {
        grid = Array(repeating: Array(repeating: 0, count: 28), count: 28)
    }
    
    
    func makeAPrediction(grid: [[Int]]) -> Int {
        
        guard let buffer = transformToBuffer(grid: grid) else {
            print("Failed to transform grid to buffer")
            return -1
        }
        
        let mlLogic = MLLogic()
        
        guard let prediction = mlLogic.makePrediction(buffer: buffer) else {
            print("Failed to make prediction")
            return -1
        }
        
        return prediction
        
    }
    
    
    func transformToBuffer(grid: [[Int]]) -> CVPixelBuffer? {
        let width = grid[0].count
        let height = grid.count
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                       width,
                                       height,
                                       kCVPixelFormatType_OneComponent8,
                                       nil,
                                       &pixelBuffer)
        
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            print("Could not create pixel buffer")
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, [])
        let bufferBaseAddress = CVPixelBufferGetBaseAddress(buffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
        
        if let baseAddress = bufferBaseAddress {
            let pixelBuffer = baseAddress.assumingMemoryBound(to: UInt8.self)
            for y in 0..<height {
                let rowOffset = y * bytesPerRow
                for x in 0..<width {
                    let value: UInt8 = grid[y][x] == 1 ? 255 : 0
                    pixelBuffer[rowOffset + x] = value
                }
            }
        }
        
        CVPixelBufferUnlockBaseAddress(buffer, [])
        return buffer
    }
}
