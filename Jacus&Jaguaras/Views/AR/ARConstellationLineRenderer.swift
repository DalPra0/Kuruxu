import UIKit
import SceneKit
import ARKit

class ARConstellationLineRenderer {
    private var lineNodes: [SCNNode] = []
    private var markerNodes: [String: SCNNode] = [:]
    private var isConstellationActive = false
    private var currentPattern: ConstellationPattern?
    private weak var currentSceneView: ARSCNView?
    
    func addMarker(for cardName: String, at position: simd_float3, in sceneView: ARSCNView) {
        currentSceneView = sceneView
        
        if let existingMarker = markerNodes[cardName] {
            let oldPos = existingMarker.position
            let newPos = SCNVector3(position.x, position.y, position.z)
            let distance = sqrt(
                pow(newPos.x - oldPos.x, 2) +
                pow(newPos.y - oldPos.y, 2) +
                pow(newPos.z - oldPos.z, 2)
            )
            
            if distance > 0.05 {
                print("      Marcador atualizado para: \(cardName) (moveu \(String(format: "%.2f", distance))m)")
                let moveAction = SCNAction.move(to: newPos, duration: 0.3)
                existingMarker.runAction(moveAction)
                
                if isConstellationActive {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        self.redrawLines()
                    }
                }
            }
            return
        }
        
        let sphere = SCNSphere(radius: 0.01)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemYellow
        material.emission.contents = UIColor.systemYellow.withAlphaComponent(0.8)
        material.lightingModel = .constant
        sphere.materials = [material]
        
        let markerNode = SCNNode(geometry: sphere)
        markerNode.position = SCNVector3(position.x, position.y, position.z)
        
        let pulseAction = SCNAction.sequence([
            SCNAction.scale(to: 1.3, duration: 0.5),
            SCNAction.scale(to: 1.0, duration: 0.5)
        ])
        markerNode.runAction(SCNAction.repeatForever(pulseAction))
        
        sceneView.scene.rootNode.addChildNode(markerNode)
        markerNodes[cardName] = markerNode
        
        print("      Marcador criado para: \(cardName)")
    }
    
    func drawConstellation(pattern: ConstellationPattern, cardPositions: [String: simd_float3], in sceneView: ARSCNView) {
        currentPattern = pattern
        currentSceneView = sceneView
        isConstellationActive = true
        
        clearLines(from: sceneView)
        
        var points: [simd_float3] = Array(repeating: simd_float3(), count: pattern.cardMapping.count)
        
        for (cardName, pointIndex) in pattern.cardMapping {
            if let markerNode = markerNodes[cardName] {
                let pos = markerNode.position
                points[pointIndex] = simd_float3(pos.x, pos.y, pos.z)
            } else if let position = cardPositions[cardName] {
                points[pointIndex] = position
            }
        }
        
        for (i, j) in pattern.connections {
            let lineNode = createLine(from: points[i], to: points[j])
            sceneView.scene.rootNode.addChildNode(lineNode)
            lineNodes.append(lineNode)
        }
        
        print("      Linhas da constelação desenhadas: \(pattern.connections.count) conexões")
    }
    
    private func redrawLines() {
        guard let pattern = currentPattern,
              let sceneView = currentSceneView else { return }
        
        clearLines(from: sceneView)
        
        var points: [simd_float3] = Array(repeating: simd_float3(), count: pattern.cardMapping.count)
        
        for (cardName, pointIndex) in pattern.cardMapping {
            if let markerNode = markerNodes[cardName] {
                let pos = markerNode.position
                points[pointIndex] = simd_float3(pos.x, pos.y, pos.z)
            }
        }
        
        for (i, j) in pattern.connections {
            let lineNode = createLine(from: points[i], to: points[j])
            sceneView.scene.rootNode.addChildNode(lineNode)
            lineNodes.append(lineNode)
        }
    }
    
    func clearLines(from sceneView: ARSCNView) {
        for node in lineNodes {
            node.removeFromParentNode()
        }
        lineNodes.removeAll()
    }
    
    func clearMarkers(from sceneView: ARSCNView) {
        for (_, node) in markerNodes {
            node.removeFromParentNode()
        }
        markerNodes.removeAll()
        print("      Marcadores removidos")
    }
    
    func clearAll(from sceneView: ARSCNView) {
        clearLines(from: sceneView)
        clearMarkers(from: sceneView)
        isConstellationActive = false
        currentPattern = nil
        currentSceneView = nil
    }
    
    private func createLine(from start: simd_float3, to end: simd_float3) -> SCNNode {
        let vector = SCNVector3(end.x - start.x, end.y - start.y, end.z - start.z)
        let distance = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
        
        let cylinder = SCNCylinder(radius: 0.002, height: CGFloat(distance))
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemCyan
        material.emission.contents = UIColor.systemCyan.withAlphaComponent(0.5)
        material.lightingModel = .constant
        cylinder.materials = [material]
        
        let lineNode = SCNNode(geometry: cylinder)
        
        lineNode.position = SCNVector3(
            (start.x + end.x) / 2,
            (start.y + end.y) / 2,
            (start.z + end.z) / 2
        )
        
        let targetVector = SCNVector3(end.x - start.x, end.y - start.y, end.z - start.z)
        let upVector = SCNVector3(0, 1, 0)
        
        let angle = acos(dotProduct(upVector, normalize(targetVector)))
        let rotationAxis = crossProduct(upVector, targetVector)
        
        if rotationAxis.length() > 0.001 {
            lineNode.rotation = SCNVector4(
                rotationAxis.x,
                rotationAxis.y,
                rotationAxis.z,
                angle
            )
        }
        
        let pulseAction = SCNAction.sequence([
            SCNAction.fadeOpacity(to: 0.6, duration: 0.8),
            SCNAction.fadeOpacity(to: 1.0, duration: 0.8)
        ])
        lineNode.runAction(SCNAction.repeatForever(pulseAction))
        
        return lineNode
    }
    
    private func dotProduct(_ a: SCNVector3, _ b: SCNVector3) -> Float {
        return a.x * b.x + a.y * b.y + a.z * b.z
    }
    
    private func crossProduct(_ a: SCNVector3, _ b: SCNVector3) -> SCNVector3 {
        return SCNVector3(
            a.y * b.z - a.z * b.y,
            a.z * b.x - a.x * b.z,
            a.x * b.y - a.y * b.x
        )
    }
    
    private func normalize(_ vector: SCNVector3) -> SCNVector3 {
        let length = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
        if length == 0 { return SCNVector3(0, 1, 0) }
        return SCNVector3(vector.x / length, vector.y / length, vector.z / length)
    }
}

extension SCNVector3 {
    func length() -> Float {
        return sqrt(x * x + y * y + z * z)
    }
}
