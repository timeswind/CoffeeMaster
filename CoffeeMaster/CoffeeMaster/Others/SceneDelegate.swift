//
//  SceneDelegate.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/7/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    lazy var environmemtServices = EnvironmemtServices()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Get the managed object context from the shared persistent container.
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObxjectContext)` in the views that will need the context.

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {

            let window = UIWindow(windowScene: windowScene)
            
            let environmentWindowObject = EnvironmentWindowObject(window: window)
            EnvironmentManager.addEnvironmentWindowObject(environmentWindowObject)
            
            let contentView = ContentView().environmentObject(environmentWindowObject).modifier(environmemtServices)

            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for urlContext in URLContexts {
            let url = urlContext.url
            print(url)
            if let scheme = url.scheme {
                if scheme == "coffeemaster"
                 {
                     switch url.host
                     {
                     case "brew":
                        print("open brew view")
                        environmemtServices.store.send(.settings(action: .setMainTabViewSelectedTab(index: 1)))
                        break

                     case "record":
                         //Open Record View
                        print("open record view")
                        environmemtServices.store.send(.settings(action: .setMainTabViewSelectedTab(index: 3)))
                        break
                     case "record.caffeine":
                        print("open record caffeine view")
                        environmemtServices.store.send(.recordview(action: .setCaffeineTrackerIsPresent(status: true)))
                        environmemtServices.store.send(.settings(action: .setMainTabViewSelectedTab(index: 3)))
                        break
                     default:
                         break
                     }
                 }
            }

        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    


}

