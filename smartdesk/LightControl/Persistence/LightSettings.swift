//
//  LightSettings.swift
//  smartdesk
//
//  Created by Jing Wei Li on 11/19/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import CoreData

class LightSettings: NSManagedObject {
    
    class func reset(in context: NSManagedObjectContext) {
        let request: NSFetchRequest<LightSettings> = LightSettings.fetchRequest()
        request.predicate = NSPredicate(value: true)
        if let settingsToModify = try? context.fetch(request) {
            settingsToModify.forEach { lightSetting in
                lightSetting.brightness = 50
                lightSetting.warmth = 50
            }
        }
    }
    
    class func set(brightness: Float, warmth: Float,
                   matching lightName: String, in context: NSManagedObjectContext) {
        let request: NSFetchRequest<LightSettings> = LightSettings.fetchRequest()
        request.predicate = NSPredicate(format: "lightName = %@", lightName)
        if let settingsToModify = try? context.fetch(request) {
            // lol no setting in database yet
            if settingsToModify.isEmpty {
                let newSetting = createLightSetting(matching: lightName, in: context)
                newSetting.brightness = brightness
                newSetting.warmth = warmth
                return
            }
            
            // modify existing database value
            guard settingsToModify.count == 1, let setting = settingsToModify.first else {
                print("Database inconsistency: more than 1 lightSettings have the same lightName")
                return
            }
            setting.brightness = brightness
            setting.warmth = warmth
        }
    }
    
    class func data(with function: LightSliderFunction,
                    matching name: String,
                    in context: NSManagedObjectContext) -> Float? {
        let request: NSFetchRequest<LightSettings> = LightSettings.fetchRequest()
        request.predicate = NSPredicate(format: "lightName = %@", name)
        if let fetchedSetting = (try? context.fetch(request))?.first {
            switch function {
            case .warmth:
                return fetchedSetting.warmth
            case .brightness:
                return fetchedSetting.brightness
            }
        }
        return nil
    }
    
    private class func createLightSetting(matching name: String,
                                          in context: NSManagedObjectContext) -> LightSettings {
        let newSetting = LightSettings(context: context)
        newSetting.lightName = name
        return newSetting
    }

}
