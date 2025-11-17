import UIKit
import ARKit
import SceneKit

class ARTestViewController: UIViewController, ARSCNViewDelegate {
    
    private let sceneView = ARSCNView()
    private var counterLabel: UILabel!
    private var debugLabel: UILabel!
    private var triangleLabel: UILabel!
    
    private var detectedCards: [String: ARAnchor] = [:]
    private var totalCardsAvailable: Int = 0
    private var triangleDetected: Bool = false
    
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
        
        guard let arAssets = ARReferenceImage.referenceImages(inGroupNamed: "Cartas", bundle: nil) else {
            print("ERRO: Pasta 'Cartas' não encontrada no Assets!")
            print("   Crie um AR Resource Group chamado 'Cartas' no Assets.xcassets")
            print("   e adicione as imagens de cartas lá")
            showAlert(message: "Pasta 'Cartas' não encontrada! Adicione imagens no Assets.")
            return
        }
        
        if true {
            referenceImages = arAssets
            totalCardsAvailable = referenceImages.count
            
            print("===========================================")
            print("CARTAS CARREGADAS DA PASTA 'Cartas':")
            print("   Total: \(totalCardsAvailable) cartas")
            print("-------------------------------------------")
            for (index, image) in referenceImages.enumerated() {
                print("   [\(index + 1)] \(image.name ?? "sem_nome")")
                print("       Tamanho: \(String(format: "%.3f", image.physicalSize.width))m")
            }
            print("===========================================")
            
        } else {
            print("ERRO: Não foi possível carregar imagens AR")
            print("   As imagens precisam estar em AR Resources")
            showAlert(message: "Configure as imagens como AR Resources no Assets!")
            return
        }
        
        guard !referenceImages.isEmpty else {
            showAlert(message: "Nenhuma carta encontrada! Adicione imagens na pasta Cartas.")
            return
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.maximumNumberOfTrackedImages = min(totalCardsAvailable, 6)
        configuration.isAutoFocusEnabled = true
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        print("\nSessão AR iniciada!")
        print("Detectando até \(configuration.maximumNumberOfTrackedImages) cartas simultâneas")
    }
    
    private func addUI() {
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("X", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        closeButton.tintColor = .white
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        closeButton.layer.cornerRadius = 25
        closeButton.frame = CGRect(x: view.bounds.width - 70, y: 50, width: 50, height: 50)
        closeButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        
        counterLabel = UILabel()
        counterLabel.text = "Cartas: 0"
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
        debugLabel.text = "Aguardando cartas..."
        debugLabel.textColor = .white
        debugLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        debugLabel.textAlignment = .left
        debugLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        debugLabel.numberOfLines = 0
        debugLabel.layer.cornerRadius = 10
        debugLabel.clipsToBounds = true
        debugLabel.frame = CGRect(x: 20, y: 120, width: view.bounds.width - 40, height: 150)
        debugLabel.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin, .flexibleWidth]
        view.addSubview(debugLabel)
        
        triangleLabel = UILabel()
        triangleLabel.text = ""
        triangleLabel.textColor = .white
        triangleLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.9)
        triangleLabel.textAlignment = .center
        triangleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        triangleLabel.layer.cornerRadius = 20
        triangleLabel.clipsToBounds = true
        triangleLabel.alpha = 0
        triangleLabel.frame = CGRect(x: (view.bounds.width - 300) / 2, 
                                     y: (view.bounds.height - 100) / 2, 
                                     width: 300, 
                                     height: 100)
        triangleLabel.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        view.addSubview(triangleLabel)
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
                    print("[\(cardName)] BLOQUEADA - Duplicata espacial!")
                    print("   -> Já existe [\(existingCardName)] a \(String(format: "%.2f", distance))m")
                    sceneView.session.remove(anchor: anchor)
                    return
                }
            }
        }
        
        if detectedCards[cardName] != nil {
            print("[\(cardName)] JÁ DETECTADA - removendo duplicata")
            sceneView.session.remove(anchor: anchor)
            return
        }
        
        detectedCards[cardName] = anchor
        
        print("[\(cardName)] DETECTADA!")
        print("   Posição: (\(String(format: "%.2f", position.x)), \(String(format: "%.2f", position.y)), \(String(format: "%.2f", position.z)))")
        print("   Total: \(detectedCards.count)/\(totalCardsAvailable)")
        
        DispatchQueue.main.async {
            self.updateCounter()
            self.updateDebugInfo()
            self.add3DModel(to: node, cardName: cardName)
            self.checkForTriangle()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor,
              let cardName = imageAnchor.referenceImage.name else { return }
        
        detectedCards.removeValue(forKey: cardName)
        
        print("[\(cardName)] REMOVIDA")
        print("   Total: \(detectedCards.count)/\(totalCardsAvailable)")
        
        DispatchQueue.main.async {
            self.updateCounter()
            self.updateDebugInfo()
            self.checkForTriangle()
        }
    }
    
    private func add3DModel(to node: SCNNode, cardName: String) {
        node.childNodes.forEach { $0.removeFromParentNode() }
        
        guard let modelURL = Bundle.main.url(forResource: "estrela", withExtension: "usdz"),
              let modelScene = try? SCNScene(url: modelURL),
              let modelNode = modelScene.rootNode.childNodes.first else {
            print("Erro ao carregar estrela.usdz")
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
    
    private func updateCounter() {
        let count = detectedCards.count
        
        if totalCardsAvailable > 0 {
            counterLabel.text = "Cartas: \(count)/\(totalCardsAvailable)"
        } else {
            counterLabel.text = "Cartas: \(count)"
        }
        
        let percentage = totalCardsAvailable > 0 ? Float(count) / Float(totalCardsAvailable) : 0
        
        let backgroundColor: UIColor
        if percentage < 0.25 {
            backgroundColor = UIColor.black.withAlphaComponent(0.7)
        } else if percentage < 0.5 {
            backgroundColor = UIColor.systemCyan.withAlphaComponent(0.8)
        } else if percentage < 0.75 {
            backgroundColor = UIColor.systemGreen.withAlphaComponent(0.8)
        } else if percentage < 1.0 {
            backgroundColor = UIColor.systemOrange.withAlphaComponent(0.8)
        } else {
            backgroundColor = UIColor.systemGreen.withAlphaComponent(0.9)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.counterLabel.backgroundColor = backgroundColor
        }
        
        if count == totalCardsAvailable && totalCardsAvailable > 0 {
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
        debugText += "Detectadas: \(count)"
        if totalCardsAvailable > 0 {
            debugText += "/\(totalCardsAvailable)\n\n"
        } else {
            debugText += "\n\n"
        }
        
        if count > 0 {
            let sortedCards = detectedCards.keys.sorted()
            for cardName in sortedCards {
                debugText += "- \(cardName)\n"
            }
        } else {
            debugText += "Coloque cartas na mesa\n"
            debugText += "Mantenha espacamento\n"
            debugText += "Boa iluminacao\n"
        }
        
        debugLabel.text = debugText
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func checkForTriangle() {
        print("\n🔍 Verificando triângulo...")
        print("   Cartas detectadas: \(detectedCards.count)")
        
        guard detectedCards.count >= 3 else {
            print("   ❌ Menos de 3 cartas")
            hideTriangleMessage()
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
            hideTriangleMessage()
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
            showTriangleMessage()
            triangleDetected = true
        } else if !foundTriangle && triangleDetected {
            hideTriangleMessage()
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
    
    private func showTriangleMessage() {
        triangleLabel.text = "🔺 TRIÂNGULO FEITO!"
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.triangleLabel.alpha = 1.0
            self.triangleLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.triangleLabel.transform = .identity
            }
        }
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    private func hideTriangleMessage() {
        UIView.animate(withDuration: 0.3) {
            self.triangleLabel.alpha = 0
        }
    }
}

fileprivate func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
}
