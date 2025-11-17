import UIKit
import ARKit

class ARTriangleDetector {
    private(set) var triangleDetected: Bool = false
    var onTriangleDetected: (() -> Void)?
    var onTriangleLost: (() -> Void)?
    
    func checkForTriangle(detectedCards: [String: ARAnchor]) {
        print("\n🔍 Verificando triângulo...")
        print("   Cartas detectadas: \(detectedCards.count)")
        
        guard detectedCards.count >= 3 else {
            print("   ❌ Menos de 3 cartas")
            if triangleDetected {
                onTriangleLost?()
                triangleDetected = false
            }
            return
        }
        
        var positions: [simd_float3] = []
        for anchor in detectedCards.values {
            if let imageAnchor = anchor as? ARImageAnchor {
                let pos = simd_float3(imageAnchor.transform.columns.3.x,
                                     imageAnchor.transform.columns.3.y,
                                     imageAnchor.transform.columns.3.z)
                positions.append(pos)
                print("   Carta em: (\(String(format: "%.2f", pos.x)), \(String(format: "%.2f", pos.y)), \(String(format: "%.2f", pos.z)))")
            }
        }
        
        guard positions.count >= 3 else {
            if triangleDetected {
                onTriangleLost?()
                triangleDetected = false
            }
            return
        }
        
        var foundTriangle = false
        for i in 0..<positions.count {
            for j in (i+1)..<positions.count {
                for k in (j+1)..<positions.count {
                    if isValidTriangle(p1: positions[i], p2: positions[j], p3: positions[k]) {
                        foundTriangle = true
                        break
                    }
                }
                if foundTriangle { break }
            }
            if foundTriangle { break }
        }
        
        if foundTriangle && !triangleDetected {
            onTriangleDetected?()
            triangleDetected = true
        } else if !foundTriangle && triangleDetected {
            onTriangleLost?()
            triangleDetected = false
        }
    }
    
    private func isValidTriangle(p1: simd_float3, p2: simd_float3, p3: simd_float3) -> Bool {
        let d12 = simd_distance(p1, p2)
        let d23 = simd_distance(p2, p3)
        let d31 = simd_distance(p3, p1)
        
        print("   📏 Testando triângulo:")
        print("      Lado 1-2: \(String(format: "%.2f", d12))m")
        print("      Lado 2-3: \(String(format: "%.2f", d23))m")
        print("      Lado 3-1: \(String(format: "%.2f", d31))m")
        
        let minDist: Float = 0.10
        let maxDist: Float = 0.80
        
        guard d12 >= minDist && d12 <= maxDist,
              d23 >= minDist && d23 <= maxDist,
              d31 >= minDist && d31 <= maxDist else {
            print("      ❌ Distâncias fora do range (0.10m - 0.80m)")
            return false
        }
        
        guard (d12 + d23) > d31,
              (d23 + d31) > d12,
              (d31 + d12) > d23 else {
            return false
        }
        
        let maxSide = max(d12, d23, d31)
        let minSide = min(d12, d23, d31)
        
        guard (maxSide / minSide) < 3.0 else {
            return false
        }
        
        let s = (d12 + d23 + d31) / 2.0
        let area = sqrt(s * (s - d12) * (s - d23) * (s - d31))
        
        guard area > 0.005 else {
            return false
        }
        
        print("🔺 TRIÂNGULO DETECTADO!")
        print("   Lados: \(String(format: "%.2f", d12))m, \(String(format: "%.2f", d23))m, \(String(format: "%.2f", d31))m")
        print("   Área: \(String(format: "%.4f", area))m²")
        
        return true
    }
}
