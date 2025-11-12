//
//  ARTestViewController.swift
//  Jacus&Jaguaras
//
//  Created by Lucas Dal Pra Brascher on 10/11/25.
//

import UIKit
import ARKit
import SceneKit

class ARTestViewController: UIViewController, ARSCNViewDelegate {
    
    private let sceneView = ARSCNView()
    private var counterLabel: UILabel!
    private var debugLabel: UILabel!
    
    private var detectedCards: [String: ARAnchor] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupARScene()
        addUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startARSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    private func setupARScene() {
        view.addSubview(sceneView)
        sceneView.frame = view.bounds
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        sceneView.showsStatistics = true
    }
    
    private func startARSession() {
        var referenceImages: Set<ARReferenceImage> = []
        
        for cardNumber in 1...4 {
            guard let cardImage = UIImage(named: "carta_\(cardNumber)"),
                  let cgImage = cardImage.cgImage else {
                print("Erro: carta_\(cardNumber) não encontrada!")
                continue
            }
            
            let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.088)
            referenceImage.name = "carta_\(cardNumber)"
            referenceImages.insert(referenceImage)
            
            print("Carta \(cardNumber) adicionada ao tracking")
        }
        
        guard !referenceImages.isEmpty else {
            showAlert(message: "Nenhuma carta encontrada nos Assets!")
            return
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 4
        configuration.isAutoFocusEnabled = true
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        print("Sessão AR iniciada!")
        print("Detectando 4 cartas diferentes")
        print("   - Carta 1 (Azul)")
        print("   - Carta 2 (Magenta)")
        print("   - Carta 3 (Verde)")
        print("   - Carta 4 (Laranja)")
    }
    
    private func addUI() {
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        closeButton.tintColor = .white
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        closeButton.layer.cornerRadius = 25
        closeButton.frame = CGRect(x: view.bounds.width - 70, y: 50, width: 50, height: 50)
        closeButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        
        counterLabel = UILabel()
        counterLabel.text = "Cartas: 0/4"
        counterLabel.textColor = .white
        counterLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        counterLabel.textAlignment = .center
        counterLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        counterLabel.layer.cornerRadius = 15
        counterLabel.clipsToBounds = true
        counterLabel.frame = CGRect(x: 20, y: 50, width: 200, height: 50)
        counterLabel.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin]
        view.addSubview(counterLabel)
        
        debugLabel = UILabel()
        debugLabel.text = "🔧 Aguardando cartas..."
        debugLabel.textColor = .white
        debugLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        debugLabel.textAlignment = .left
        debugLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        debugLabel.numberOfLines = 0
        debugLabel.layer.cornerRadius = 10
        debugLabel.clipsToBounds = true
        debugLabel.frame = CGRect(x: 20, y: 120, width: view.bounds.width - 40, height: 120)
        debugLabel.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin, .flexibleWidth]
        view.addSubview(debugLabel)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor,
              let cardName = imageAnchor.referenceImage.name else { return }
        
        let position = simd_float3(imageAnchor.transform.columns.3.x,
                                   imageAnchor.transform.columns.3.y,
                                   imageAnchor.transform.columns.3.z)
        
        for (existingCardName, existingAnchor) in detectedCards {
            if let existingImageAnchor = existingAnchor as? ARImageAnchor {
                let existingPos = simd_float3(existingImageAnchor.transform.columns.3.x,
                                              existingImageAnchor.transform.columns.3.y,
                                              existingImageAnchor.transform.columns.3.z)
                let distance = simd_distance(position, existingPos)
                
                if distance < 0.10 {
                    print("\(cardName) BLOQUEADA!")
                    print("   → Já existe \(existingCardName) a \(String(format: "%.2f", distance))m")
                    print("   → Mesma carta física detectada como múltiplas!")
                    
                    sceneView.session.remove(anchor: anchor)
                    return
                }
            }
        }
        
        if detectedCards[cardName] != nil {
            print("\(cardName) JÁ DETECTADA - removendo duplicata")
            sceneView.session.remove(anchor: anchor)
            return
        }
        
        detectedCards[cardName] = anchor
        
        let cardNumber = Int(cardName.replacingOccurrences(of: "carta_", with: "")) ?? 0
        
        print("\(cardName.uppercased()) ACEITA!")
        print("   Posição: (\(String(format: "%.2f", position.x)), \(String(format: "%.2f", position.y)), \(String(format: "%.2f", position.z)))")
        print("   Total detectadas: \(detectedCards.count)/4")
        
        DispatchQueue.main.async {
            self.updateCounter()
            self.updateDebugInfo()
            self.add3DModel(to: node, cardNumber: cardNumber, cardName: cardName)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor,
              let cardName = imageAnchor.referenceImage.name else { return }
        
        detectedCards.removeValue(forKey: cardName)
        
        print("\(cardName.uppercased()) removida")
        print("   Total: \(detectedCards.count)/4")
        
        DispatchQueue.main.async {
            self.updateCounter()
            self.updateDebugInfo()
        }
    }
    
    private func add3DModel(to node: SCNNode, cardNumber: Int, cardName: String) {
        node.childNodes.forEach { $0.removeFromParentNode() }
        
        guard let modelURL = Bundle.main.url(forResource: "D20", withExtension: "usdz"),
              let modelScene = try? SCNScene(url: modelURL),
              let modelNode = modelScene.rootNode.childNodes.first else {
            print("Erro ao carregar D20.usdz")
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
        
        let cardColors: [UIColor] = [
            .systemCyan,
            .systemPink,
            .systemGreen,
            .systemOrange
        ]
        
        if let geometry = modelNode.geometry {
            let material = SCNMaterial()
            material.diffuse.contents = cardColors[cardNumber - 1]
            geometry.materials = [material]
        }
        
        node.addChildNode(modelNode)
        
        let textNode = createTextNode(text: "\(cardNumber)", color: cardColors[cardNumber - 1])
        textNode.position.y = 0.09
        node.addChildNode(textNode)
        
        print("D20 da \(cardName) adicionado!")
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
    
    private func updateCounter() {
        let count = detectedCards.count
        counterLabel.text = "Cartas: \(count)/4"
        
        let backgroundColor: UIColor
        switch count {
        case 0:
            backgroundColor = UIColor.black.withAlphaComponent(0.7)
        case 1:
            backgroundColor = UIColor.systemCyan.withAlphaComponent(0.8)
        case 2:
            backgroundColor = UIColor.systemPink.withAlphaComponent(0.8)
        case 3:
            backgroundColor = UIColor.systemGreen.withAlphaComponent(0.8)
        case 4:
            backgroundColor = UIColor.systemOrange.withAlphaComponent(0.8)
        default:
            backgroundColor = UIColor.systemRed.withAlphaComponent(0.8)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.counterLabel.backgroundColor = backgroundColor
        }
        
        if count == 4 {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat], animations: {
                self.counterLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { _ in
                self.counterLabel.transform = .identity
            }
        }
    }
    
    private func updateDebugInfo() {
        let count = detectedCards.count
        var debugText = "DEBUG\n"
        debugText += "Detectadas: \(count)/4\n\n"
        
        if count > 0 {
            let sortedCards = detectedCards.keys.sorted()
            for cardName in sortedCards {
                let number = cardName.replacingOccurrences(of: "carta_", with: "")
            }
        } else {
            debugText += "Coloque as cartas na mesa\n"
            debugText += "Mantenha espaçamento\n"
            debugText += "Boa iluminação\n"
        }
        
        debugLabel.text = debugText
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

fileprivate func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
}
