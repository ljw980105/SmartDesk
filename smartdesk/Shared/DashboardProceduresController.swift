//
//  DashboardProceduresController.swift
//  smartdesk
//
//  Created by Jing Wei Li on 11/23/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

/**
 * Manages the closure action blocks for the collection views located in the table view cell.
 * - Not in use currently.
 */
class DashboardProceduresController: NSObject {
    weak var parentNavigationController: UINavigationController?
    weak var parentView: UIView?
    weak var parentTableView: UITableView?
    var actions: [Int: () -> Void] = [:]
    var sectionHeader: String?
    var procedures: [Int: Any] = [:] {
        didSet {
            for (key, value) in procedures {
                if let longProcesses = value as? (String, String) {
                    actions[key] = { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.prepareForLottieAnimation(dimAndDisable: true)
                        let screenWidth = (strongSelf.parentTableView?.bounds.width ?? 375) * 0.6
                        let animSize = screenWidth < 200 ? 200 : screenWidth
                        let animationView =
                            LottieActivityIndicator(frame: CGRect(x: 0, y: 0,
                                                                  width: animSize, height: animSize))
                        animationView.configure(startCommand: longProcesses.0, endCommand: longProcesses.1) {
                            strongSelf.prepareForLottieAnimation(dimAndDisable: false)
                        }
                        strongSelf.parentView?.addSubview(animationView)
                       
                    }
                } else if let lightControl = value as? [LightControlOptions: String] {
                    actions[key] = { [weak self] in
                        guard let strongSelf = self else { return }
                        let lightVC = LightControlTableViewController(data: lightControl)
                        lightVC.title = strongSelf.sectionHeader
                        strongSelf.parentNavigationController?.pushViewController(lightVC, animated: true)
                    }
                }
            }
        }
    }
    
    override init() {
        super.init()
    }
    
    private func prepareForLottieAnimation(dimAndDisable: Bool) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.parentTableView?.alpha = dimAndDisable ? 0.3 : 1.0
            self?.parentTableView?.isUserInteractionEnabled = !dimAndDisable
        })
    }

}
