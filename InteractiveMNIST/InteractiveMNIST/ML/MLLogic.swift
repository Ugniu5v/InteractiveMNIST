import Foundation
import UIKit
import CoreML

class MLLogic {
    
    func makePrediction(buffer: CVPixelBuffer) -> Int? {
        
        do {
            
            var modelURL: URL
            if let compiledURL = Bundle.main.url(forResource: "MNISTmodel", withExtension: "mlmodelc") {
                modelURL = compiledURL
            } else {
                print("\nCompiled model not found, attempting to compile source model")
                guard let sourceURL = Bundle.main.url(forResource: "MNISTmodel", withExtension: "mlmodel") else {
                    throw NSError(domain: "ModelError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Model not found"])
                }
                modelURL = try MLModel.compileModel(at: sourceURL)
                print("Model compiled successfully to: \(modelURL)")
            }
            
            // Loading and prediction of the pre-trained model
            let model = try MLModel(contentsOf: modelURL)
            let input = try MLDictionaryFeatureProvider(dictionary: ["image": buffer])
            let prediction = try model.prediction(from: input)
            var predictionText: String
            
            if let probabilities = prediction.featureValue(for: "targetProbability")?.dictionaryValue as? [String: Double] {
                let bestPrediction = probabilities.max(by: { $0.value < $1.value })
                
                // Console text for prediction list and return
                if let digit = bestPrediction?.key, let probability = bestPrediction?.value {
                    
                    predictionText = "Prediction: \(digit) (\(String(format: "%.2f", probability * 100))%)"
                    print("\nPrediction results ")
                    print(predictionText)
                    
                    var detailedText = "All Probabilities: \n"
                    for (digit, prob) in probabilities.sorted(by: {$0.value > $1.value}) {
                        detailedText += "\(digit): \(String(format: "%.2f", prob * 100))% \n"
                    }
                    print(detailedText)
                    return Int(digit)
                }
            }
            
        } catch {
            print("\nError in Prediction Process")
            print("Error details: \(error)")
            return nil
        }
            
        return nil
    }
}

