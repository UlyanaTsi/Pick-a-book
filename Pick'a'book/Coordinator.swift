//
//  Coordinator.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 06.04.2022.
//

import Foundation
import UIKit

class Coordinator {
    static func rootVC(vc: UIViewController) {
        let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
        
        sceneDelegate.window!.rootViewController = vc
        sceneDelegate.window!.makeKeyAndVisible()
    }
}
