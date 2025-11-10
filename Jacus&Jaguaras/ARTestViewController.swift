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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupARScene()
        addCloseButton()
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
        guard let markerImage = UIImage(named: "marker"),
              let cgImage = markerImage.cgImage else {
            print("❌ Erro: Marker não encontrado nos Assets!")
            showAlert(message: "Marker não encontrado. Adicione 'marker' nos Assets.")
            return
        }
        
        let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.15)
        referenceImage.name = "star_marker"
        
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = [referenceImage]
        configuration.maximumNumberOfTrackedImages = 1
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        print("✅ Sessão AR iniciada!")
        print("📸 Aponte a câmera para o marker impresso")
    }
    
    private func addCloseButton() {
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
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        print("🎯 Marker detectado: \(imageAnchor.referenceImage.name ?? "desconhecido")")
        
        DispatchQueue.main.async {
            self.add3DModel(to: node)
        }
    }
    
    private func add3DModel(to node: SCNNode) {
        guard let modelURL = Bundle.main.url(forResource: "D20", withExtension: "usdz"),
              let modelScene = try? SCNScene(url: modelURL),
              let modelNode = modelScene.rootNode.childNodes.first else {
            print("❌ Erro ao carregar D20.usdz")
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
        let targetSize: Float = 0.05
        let scaleFactor = targetSize / largestDimension
        modelNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        
        modelNode.position.y = 0.02
        
        let rotation = SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 4)
        let repeatRotation = SCNAction.repeatForever(rotation)
        modelNode.runAction(repeatRotation)
        
        node.addChildNode(modelNode)
        
        print("D20 adicionado ao marker!")
        
        showSuccessMessage()
    }
    
    private func showSuccessMessage() {
        let label = UILabel()
        label.text = "Marker detectado!"
        label.textColor = .white
        label.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.frame = CGRect(x: view.bounds.width/2 - 100, y: 100, width: 200, height: 50)
        view.addSubview(label)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            label.removeFromSuperview()
        }
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
