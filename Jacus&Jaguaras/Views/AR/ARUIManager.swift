import UIKit

class ARUIManager {
    private var counterLabel: UILabel!
    private var triangleLabel: UILabel!
    private var photoButton: UIButton!
    
    var onCloseTapped: (() -> Void)?
    var onPhotoTapped: (() -> Void)?
    
    func setupUI(in view: UIView, closeAction: @escaping () -> Void) {
        self.onCloseTapped = closeAction
        
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
        
        photoButton = UIButton(type: .system)
        photoButton.setTitle("📸", for: .normal)
        photoButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        photoButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.9)
        photoButton.layer.cornerRadius = 35
        photoButton.alpha = 0
        photoButton.frame = CGRect(x: (view.bounds.width - 70) / 2,
                                   y: view.bounds.height - 120,
                                   width: 70,
                                   height: 70)
        photoButton.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin]
        photoButton.addTarget(self, action: #selector(photoTapped), for: .touchUpInside)
        view.addSubview(photoButton)
    }
    
    @objc private func closeTapped() {
        onCloseTapped?()
    }
    
    @objc private func photoTapped() {
        onPhotoTapped?()
    }
    
    func updateCounter(count: Int, total: Int) {
        if total > 0 {
            counterLabel.text = "Cartas: \(count)/\(total)"
        } else {
            counterLabel.text = "Cartas: \(count)"
        }
        
        let percentage = total > 0 ? Float(count) / Float(total) : 0
        
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
        
        if count == total && total > 0 {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat], animations: {
                self.counterLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { _ in
                self.counterLabel.transform = .identity
            }
        }
    }
    
    func showConstellationMessage(name: String) {
        triangleLabel.text = "\(name.uppercased())!"

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.triangleLabel.alpha = 1.0
            self.triangleLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.triangleLabel.transform = .identity
            }
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.photoButton.alpha = 1.0
            self.photoButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.photoButton.transform = .identity
            }
        }

        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    func hideConstellationMessage() {
        UIView.animate(withDuration: 0.3) {
            self.triangleLabel.alpha = 0
            self.photoButton.alpha = 0
        }
    }
}
