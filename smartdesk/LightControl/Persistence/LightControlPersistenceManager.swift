//
//  LightControlPersistenceManager.swift
//  smartdesk
//
//  Created by Jing Wei Li on 11/19/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import CoreData

/**
 * Persists the light control data between initiation / dismissals of light control view controller.
 * - upon app launch: set everything to 50 in `UserDefaults`
 * - upon app dismissal: reset everything to 50 again in `UserDefaults`
 * - when light vc appears -> load light settings from `UserDefaults`
 */
class LightControlPersistenceManager {
    private var identifier: String = ""
    
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LightSettings")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    
    init(identifier: String) {
        self.identifier = identifier
    }
    
    var brightness: Float {
        return LightSettings.data(with: .brightness, matching: identifier,
                                  in: LightControlPersistenceManager.persistentContainer.viewContext) ?? 50.0
    }
    
    var colorTemperature: Float {
        return LightSettings.data(with: .warmth, matching: identifier,
                                  in: LightControlPersistenceManager.persistentContainer.viewContext) ?? 50.0
    }
    
    class func reset() {
        LightSettings.reset(in: persistentContainer.viewContext)
        try? LightControlPersistenceManager.persistentContainer.viewContext.save()
    }
    
    func set(brightness: Float, colorTemeprature: Float) {
        LightSettings.set(brightness: brightness,
                          warmth: colorTemeprature,
                          matching: identifier,
                          in: LightControlPersistenceManager.persistentContainer.viewContext)
        try? LightControlPersistenceManager.persistentContainer.viewContext.save()
    }
    
}
