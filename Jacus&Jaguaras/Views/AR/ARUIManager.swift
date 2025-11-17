import UIKit

class ARUIManager {
    private var counterLabel: UILabel!
    private var debugLabel: UILabel!
    private var triangleLabel: UILabel!
    
    var onCloseTapped: (() -> Void)?
    
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
        onCloseTapped?()
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
    
    func updateDebugInfo(count: Int, total: Int, cardNames: [String]) {
        var debugText = "DEBUG\n"
        debugText += "Detectadas: \(count)"
        if total > 0 {
            debugText += "/\(total)\n\n"
        } else {
            debugText += "\n\n"
        }
        
        if count > 0 {
            let sortedCards = cardNames.sorted()
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
    
    func showTriangleMessage() {
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
    
    func hideTriangleMessage() {
        UIView.animate(withDuration: 0.3) {
            self.triangleLabel.alpha = 0
        }
    }
}
