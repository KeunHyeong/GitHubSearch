//
//  ToastManager.swift
//  RememberTest
//
//  Created by 장근형 on 2/12/25.
//
import UIKit

class ToastManager {
    static let shared = ToastManager()
    private let toastTag = 9999
    
    private init() {}
    
    func showToast(message: String, in view: UIView? = nil, duration: TimeInterval = 5.0) {
        let containerView: UIView
        guard let keyWindow = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) else {
            return
        }
        containerView = keyWindow
        
        if let existingToast = containerView.viewWithTag(toastTag) {
            existingToast.removeFromSuperview()
        }
        
        let toastLabel = UILabel()
        toastLabel.tag = toastTag
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        let padding: CGFloat = 16
        let maxWidth = containerView.frame.width - (padding * 2)
        let textSize = toastLabel.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        let labelWidth = min(textSize.width + 20, maxWidth)
        let labelHeight = textSize.height + 10
        let xPos = (containerView.frame.width - labelWidth) / 2
        let yPos = containerView.frame.height - labelHeight - 80
        toastLabel.frame = CGRect(x: xPos, y: yPos, width: labelWidth, height: labelHeight)
        
        containerView.addSubview(toastLabel)
        
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}

