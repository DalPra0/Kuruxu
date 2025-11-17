import UIKit
import SceneKit

class ARModelManager {
    
    func add3DModel(to node: SCNNode, cardName: String) {
        node.childNodes.forEach { $0.removeFromParentNode() }
        
        guard let modelURL = Bundle.main.url(forResource: "star", withExtension: "usdz"),
              let modelScene = try? SCNScene(url: modelURL),
              let modelNode = modelScene.rootNode.childNodes.first else {
            print("Erro ao carregar star.usdz")
            return
        }
        
        let (minVec, maxVec) = modelNode.boundingBox
        let center = SCNVector3(
            (maxVec.x + minVec.x) / 2,
            (maxVec.y + minVec.y) / 2,
            (maxVec.z + minVec.z) / 2
        )
        
        modelNode.pivot = SCNMatrix4MakeTranslation(center.x, center.y, center.z)
        
        let size = maxVec - minVec
        let largestDimension = max(size.x, size.y, size.z)
        let targetSize: Float = 0.04
        let scaleFactor = targetSize / largestDimension
        modelNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        
        modelNode.position.y = 0.05
        
        let rotation = SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 4)
        let repeatRotation = SCNAction.repeatForever(rotation)
        modelNode.runAction(repeatRotation)
        
        let colorIndex = abs(cardName.hashValue) % 10
        let colors: [UIColor] = [
            .systemCyan, .systemPink, .systemGreen, .systemOrange,
            .systemYellow, .systemPurple, .systemBlue, .systemRed,
            .systemIndigo, .systemTeal
        ]
        
        if let geometry = modelNode.geometry {
            let material = SCNMaterial()
            material.diffuse.contents = colors[colorIndex]
            geometry.materials = [material]
        }
        
        node.addChildNode(modelNode)
        
        let textNode = createTextNode(text: cardName, color: colors[colorIndex])
        textNode.position.y = 0.09
        node.addChildNode(textNode)
        
        print("   3D modelo adicionado!")
    }
    
    private func createTextNode(text: String, color: UIColor) -> SCNNode {
        let textGeometry = SCNText(string: text, extrusionDepth: 1)
        textGeometry.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        textGeometry.firstMaterial?.diffuse.contents = color
        
        let textNode = SCNNode(geometry: textGeometry)
        
        let (min, max) = textNode.boundingBox
        let width = max.x - min.x
        textNode.pivot = SCNMatrix4MakeTranslation((min.x + width/2), 0, 0)
        
        textNode.scale = SCNVector3(0.002, 0.002, 0.002)
        
        return textNode
    }
}

fileprivate func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
}
