//
//  Dashboard+Actions.swift
//  smartdesk
//
//  Created by Jing Wei Li on 11/24/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import UIKit

extension DashboardViewController {
    
    /**
     * Generates the closure action blocks for the collection views located in the table view cell.
     */
    func actions(from procedures: [Int: Any], header: String) ->  [Int: () -> Void] {
        var actions: [Int: () -> Void] = [:]
        for (key, value) in procedures {
            if let longProcesses = value as? (String, String) {
                actions[key] = { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.prepareForLottieAnimation(dimAndDisable: true)
                    let screenWidth = strongSelf.tableView.bounds.width * 0.6
                    let animSize = screenWidth < 200 ? 200 : screenWidth
                    let animationView =
                        LottieActivityIndicator(frame: CGRect(x: 0, y: 0,
                                                              width: animSize, height: animSize))
                    animationView.startCommand = longProcesses.0
                    animationView.endCommand = longProcesses.1
                    animationView.animationName = "GearAnimation"
                    animationView.aspectRatio = 1
                    animationView.completion = {
                        strongSelf.prepareForLottieAnimation(dimAndDisable: false)
                    }
                    strongSelf.view.addSubview(animationView)
                }
            } else if let lightControl = value as? [LightControlOptions: String] {
                actions[key] = { [weak self] in
                    guard let strongSelf = self else { return }
                    let lightVC = LightControlTableViewController(data: lightControl)
                    lightVC.title = header
                    strongSelf.navigationController?.pushViewController(lightVC, animated: true)
                }
            }
        }
        return actions
    }
    
    private func prepareForLottieAnimation(dimAndDisable: Bool) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.tableView.alpha = dimAndDisable ? 0.3 : 1.0
            self?.tableView.isUserInteractionEnabled = !dimAndDisable
        })
    }
}
