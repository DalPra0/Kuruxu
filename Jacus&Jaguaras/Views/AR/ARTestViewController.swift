import UIKit
import ARKit
import SceneKit
import TipKit

class ARTestViewController: UIViewController, ARSCNViewDelegate {
    
    private let sceneView = ARSCNView()
    private var detectedCards: [String: ARAnchor] = [:]
    
    private let sessionManager = ARSessionManager()
    private let modelManager = ARModelManager()
    private let constellationDetector = ARConstellationDetector()
    private let lineRenderer = ARConstellationLineRenderer()
    private let feedbackManager = ARFeedbackManager()
    private let uiManager = ARUIManager()
    
    var onDismiss: (() -> Void)?
    var onPhotoTaken: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupARScene()
        setupUI()
        setupConstellationDetector()
        lineRenderer.feedbackManager = feedbackManager
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startARSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sessionManager.pauseSession()
    }
    
    private func setupARScene() {
        sceneView.frame = view.bounds
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(sceneView, at: 0)
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        view.backgroundColor = .black
        sceneView.backgroundColor = .black
        
        sessionManager.sceneView = sceneView
        
        print("🎥 ARSCNView configurada: frame=\(sceneView.frame), bounds=\(view.bounds)")
    }
    
    private func setupUI() {
        uiManager.setupUI(in: view) { [weak self] in
            self?.onDismiss?()
        }
        
        uiManager.onPhotoTapped = { [weak self] in
            self?.takePhoto()
        }
    }
    
    private func setupConstellationDetector() {
        constellationDetector.onConstellationDetected = { [weak self] constellationName, pattern, cardPositions in
            guard let self = self else { return }
            self.feedbackManager.constellationDetected()
            self.uiManager.showConstellationMessage(name: constellationName)
            self.lineRenderer.drawConstellation(pattern: pattern, cardPositions: cardPositions, in: self.sceneView)
        }

        constellationDetector.onConstellationLost = { [weak self] in
            guard let self = self else { return }
            self.feedbackManager.constellationLost()
            self.lineRenderer.clearAll(from: self.sceneView)
            self.uiManager.hideConstellationMessage()
        }
    }
    
    private func startARSession() {
        sessionManager.startSession { [weak self] success, errorMessage in
            if !success, let message = errorMessage {
                self?.showAlert(message: message)
            }
        }
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
        print("   Total: \(detectedCards.count)/\(sessionManager.totalCardsAvailable)")
        
//        Task{await tip1.readCardEvent.donate()}
        
        DispatchQueue.main.async {
            self.feedbackManager.cardDetected()
            self.lineRenderer.addMarker(for: cardName, at: position, in: self.sceneView)
//            self.updateUI()
            self.modelManager.add3DModel(to: node, cardName: cardName)
            self.constellationDetector.checkForConstellation(detectedCards: self.detectedCards)
            
            Task{tip1().invalidate(reason: .tipClosed)}
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor,
              let cardName = imageAnchor.referenceImage.name else { return }
        
        detectedCards.removeValue(forKey: cardName)
        
        print("[\(cardName)] REMOVIDA")
        print("   Total: \(detectedCards.count)/\(sessionManager.totalCardsAvailable)")
        
        DispatchQueue.main.async {
            self.feedbackManager.cardRemoved()
//            self.updateUI()
            self.constellationDetector.checkForConstellation(detectedCards: self.detectedCards)
        }
    }
    
//    private func updateUI() {
//        let count = detectedCards.count
//        let total = sessionManager.totalCardsAvailable
//        
////        uiManager.updateCounter(count: count, total: total)
//    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func takePhoto() {
        let snapshot = sceneView.snapshot()
        SavedPhotosManager.shared.savePhoto(snapshot)
        
        feedbackManager.markerCreated()
        
        let alert = UIAlertController(title: "📸 Foto Salva!", message: "A constelação foi capturada!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.onPhotoTaken?()
        })
        present(alert, animated: true)
    }
}

final class SavedPhotosManager {
    private init() { }
    
    static let shared = SavedPhotosManager()
    
    func getPhotos() -> [Data] {
        guard let documentsPath = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else { return [] }
        
        do {
            let files = try FileManager.default.contentsOfDirectory(
                at: documentsPath,
                includingPropertiesForKeys: nil
            )
            
            let images = files.filter { url in
                url.absoluteString.contains("constellation_")
            }
            
            return images.map { imageUrl in
                FileManager.default.contents(atPath: imageUrl.path)!
            }
            
        } catch {
            return []
        }
    }
    
    func savePhoto(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }
        
        let fileManager = FileManager.default
        guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let timestamp = Date().timeIntervalSince1970
        let fileName = "constellation_\(Int(timestamp)).jpg"
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            print("Foto salva: \(fileName)")
            print("   Local: \(fileURL.path)")
        } catch {
            print("Erro ao salvar foto: \(error)")
        }
    }
}
