//
//  LottieActivityIndicator.swift
//  smartdesk
//
//  Created by Jing Wei Li on 11/21/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import Lottie

class LottieActivityIndicator: UIView {
    private var animationView: LOTAnimationView?
    private var startCommand: String?
    private var endCommand: String?
    private var completion: (() -> Void)?
    
    func configure(startCommand: String, endCommand: String, completion: (() -> Void)? = nil) {
        self.startCommand = startCommand
        self.endCommand = endCommand
        self.completion = completion
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        guard let superView = newSuperview else { return }
        
        self.center = superView.center
        self.layer.cornerRadius = 20.0
        self.backgroundColor = UIColor.groupTableViewBackground
        self.clipsToBounds = true
        
    }
    
    override func didMoveToSuperview() {
        guard let superView = superview else { return }
        self.alpha = 0
        addShadow()
        let width = Int(self.frame.width * 0.888)
        let height = Int(self.frame.height * 0.888)
        animationView = LOTAnimationView(name: "TransitionAnimation2")
        animationView?.frame = CGRect(x: 0, y: 0, width: width, height: height)
        animationView?.center = superView.center
        animationView?.loopAnimation = true
        animationView?.layer.cornerRadius = 20.0
        animationView?.clipsToBounds = true
        if let animationView = animationView {
            superView.addSubview(animationView)
        }
        animationView?.play()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        animationView?.addGestureRecognizer(gestureRecognizer)
        animationView?.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.3) { [weak self] in self?.alpha = 1 }
        
        if let startCmd = startCommand {
            BLEManager.current.send(string: startCmd)
        }
    }
    
    @objc private func handleTap() {
        removeSubviews()
        if let endCmd = endCommand {
            completion?()
            BLEManager.current.send(string: endCmd)
        }
    }
    
    private func removeSubviews() {
        animationView?.stop()
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.alpha = 0
        }, completion: { [weak self] _ in
            self?.animationView?.removeFromSuperview()
            self?.removeFromSuperview()
        })
    }
    
    private func addShadow() {
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20.0)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 3.0, height: 10.0)
        layer.shadowOpacity = 0.3
        layer.shadowPath = shadowPath.cgPath
    }
    
}
