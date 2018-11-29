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
    private var button: UIButton?
    var startCommand: String?
    var endCommand: String?
    var completion: (() -> Void)?
    var animationName: String? = "LogoAnimation"
    /** The ratio of width / height. Defaults to 1.0. */
    var aspectRatio: CGFloat = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
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
        let width: Int, height: Int, centerOffsetRatio: CGFloat
        if aspectRatio <= 1 {
            height = Int(self.frame.height * 0.666)
            width = Int(self.frame.height * 0.666 * aspectRatio)
            centerOffsetRatio = 0.111 // should be 0.111
        } else { // > 1
            width = Int(self.frame.width * 0.888)
            height = Int(self.frame.width * 0.888 / aspectRatio) // smaller than 0.888
            centerOffsetRatio = (0.888 - 0.888 / aspectRatio) / 2
        }
        guard let animationName = animationName else { fatalError("No Animation Name Provided") }
        animationView = LOTAnimationView(name: animationName)
        animationView?.frame = CGRect(x: 0, y: 0, width: width, height: height)
        animationView?.center = CGPoint(x: superView.center.x,
                                        y: superView.center.y - frame.height * centerOffsetRatio)
        animationView?.loopAnimation = true
        animationView?.layer.cornerRadius = 20.0
        animationView?.clipsToBounds = true
        if let animationView = animationView {
            superView.addSubview(animationView)
        }
        animationView?.play()
        
        button = UIButton(type: .custom)
        button?.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button?.setTitle("Stop Whiteboard", for: .normal)
        button?.frame = CGRect(x: 0, y: 0, width: 160, height: 30)
        button?.center = CGPoint(x: superView.center.x,
                                 y: superView.center.y + frame.height * 0.35)
        button?.layer.cornerRadius = 12.0
        button?.backgroundColor = UIColor.themeColor
        button?.alpha = 0
        superView.addSubview(button!)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.alpha = 1
            self?.button?.alpha = 1
        }
        
        if let startCmd = startCommand {
            BLEManager.current.send(string: startCmd)
        }
    }
    
    @objc private func handleTap() {
        removeSubviews()
        if let endCmd = endCommand {
            completion?()
            Haptic.current.beep()
            BLEManager.current.send(string: endCmd)
        }
    }
    
    private func removeSubviews() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.animationView?.alpha = 0
            self?.alpha = 0
            self?.button?.alpha = 0
        }, completion: { [weak self] _ in
            self?.animationView?.stop()
            self?.animationView?.removeFromSuperview()
            self?.button?.removeFromSuperview()
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
