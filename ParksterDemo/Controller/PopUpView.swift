//
//  PopUpTextFieldView.swift
//  ParksterDemo
//
//  Created by Cem on 2023-05-23.
//

import UIKit

class PopUpView: UIView {
    
    private var titleLabel: UILabel!
    private var textField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black.withAlphaComponent(0.5)
        setupViews()
        setupConstraints()
        animatePopUp()
        textField.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        animatePopUp()
    }
    
    private func setupViews() {
        titleLabel = UILabel()
        titleLabel.text = "Ange ditt namn"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.widthAnchor.constraint(equalToConstant: 200),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -20),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
    }
    
    
    private func animatePopUp() {
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        alpha = 0.0
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
            self.transform = .identity
            self.alpha = 1.0
        }, completion: nil)
    }
    
    private func dismissPopUp() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.alpha = 0.0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    private func shakeTextField() {
        let shakeAnimation = CAKeyframeAnimation(keyPath: "position")
        shakeAnimation.duration = 0.1
        shakeAnimation.repeatCount = 3
        shakeAnimation.autoreverses = true
        
        let offsetX: CGFloat = 10.0
        
        let fromPoint = CGPoint(x: textField.center.x - offsetX, y: textField.center.y)
        let toPoint = CGPoint(x: textField.center.x + offsetX, y: textField.center.y)
        
        shakeAnimation.values = [NSValue(cgPoint: fromPoint),
                                 NSValue(cgPoint: toPoint),
                                 NSValue(cgPoint: fromPoint)]
        
        textField.layer.add(shakeAnimation, forKey: "shakeAnimation")
    }
}

extension PopUpView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.count > 1 else {
            shakeTextField()
            return false
        }
        
        textField.resignFirstResponder()
        dismissPopUp()
        UserDefaults.standard.setValue(text, forKey: "playerName")
        
        return true
    }
}
