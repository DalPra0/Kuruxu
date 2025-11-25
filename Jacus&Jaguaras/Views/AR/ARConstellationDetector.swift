import UIKit
import ARKit

struct ConstellationPattern {
    let name: String
    let cardMapping: [String: Int]
    let connections: [(Int, Int)]
    
    static let tenPointConstellation = ConstellationPattern(
        name: "Constelação de 10 Pontos",
        cardMapping: [
            "Carta 1": 0,
            "Carta 2": 1,
            "Carta 3": 2,
            "Carta 4": 3,
            "Carta 5": 4,
            "Carta 6": 5,
            "Carta 7": 6,
            "Carta 8": 7,
            "Carta 9": 8,
            "Carta 10": 9
        ],
        connections: [
            (0, 1),
            (0, 9),
            (1, 2),
            (2, 3),
            (3, 4),
            (3, 6),
            (3, 5),
            (6, 9),
            (6, 7),
            (6, 8)
        ]
    )
}

class ARConstellationDetector {
    private(set) var constellationDetected: Bool = false
    var onConstellationDetected: ((String, ConstellationPattern, [String: simd_float3]) -> Void)?
    var onConstellationLost: (() -> Void)?

    private let patterns: [ConstellationPattern] = [
        .tenPointConstellation
    ]

    func checkForConstellation(detectedCards: [String: ARAnchor]) {
        print("\nVerificando constelações...")
        print("   Cartas detectadas: \(detectedCards.count)")

        var cardPositions: [String: simd_float3] = [:]
        for (name, anchor) in detectedCards {
            if let imageAnchor = anchor as? ARImageAnchor {
                let pos = simd_float3(imageAnchor.transform.columns.3.x,
                                     imageAnchor.transform.columns.3.y,
                                     imageAnchor.transform.columns.3.z)
                cardPositions[name] = pos
                print("   \(name): (\(String(format: "%.2f", pos.x)), \(String(format: "%.2f", pos.y)), \(String(format: "%.2f", pos.z)))")
            }
        }

        for pattern in patterns {
            if let matchedConstellation = tryMatchPattern(pattern, with: cardPositions) {
                if !constellationDetected {
                    print("CONSTELAÇÃO DETECTADA: \(matchedConstellation)")
                    onConstellationDetected?(matchedConstellation, pattern, cardPositions)
                    constellationDetected = true
                }
                return
            }
        }

        if constellationDetected {
            print("Constelação perdida")
            onConstellationLost?()
            constellationDetected = false
        }
    }

    private func tryMatchPattern(_ pattern: ConstellationPattern, with cardPositions: [String: simd_float3]) -> String? {
        print("   Testando padrão: \(pattern.name)")

        var points: [simd_float3?] = Array(repeating: nil, count: pattern.cardMapping.count)
        var foundCards: [String] = []
        
        for (cardName, pointIndex) in pattern.cardMapping {
            if let position = cardPositions[cardName] {
                points[pointIndex] = position
                foundCards.append(cardName)
            }
        }
        
        guard foundCards.count == pattern.cardMapping.count else {
            let missing = pattern.cardMapping.keys.filter { !foundCards.contains($0) }
            print("      Faltam cartas: \(missing.joined(separator: ", "))")
            return nil
        }
        
        let validPoints = points.compactMap { $0 }
        
        print("      Todas as cartas encontradas!")
        print("      Validando conexões...")
        
        let minDist: Float = 0.10
        let maxDist: Float = 0.55
        
        var validConnections = 0
        for (i, j) in pattern.connections {
            let dist = simd_distance(validPoints[i], validPoints[j])
            let isValid = dist >= minDist && dist <= maxDist
            print("         Conexão \(i)-\(j): \(String(format: "%.3f", dist))m \(isValid ? "OK" : "FORA")")
            if isValid {
                validConnections += 1
            }
        }
        
        let successRate = Float(validConnections) / Float(pattern.connections.count)
        print("      Taxa de sucesso: \(validConnections)/\(pattern.connections.count) (\(String(format: "%.0f", successRate * 100))%)")
        
        if successRate >= 0.8 {
            print("      Constelação válida!")
            return pattern.name
        } else {
            print("      Muitas conexões fora do range")
            return nil
        }
    }
}
