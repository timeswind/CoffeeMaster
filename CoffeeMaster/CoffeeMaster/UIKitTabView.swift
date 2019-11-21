//
//  UIKitTabView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/20/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import UIKit

struct UIKitTabView: View {
    var viewControllers: [UIHostingController<AnyView>]
    @Binding var selectedIndex: Int
    
    init(_ views: [Tab], selectedIndex: Binding<Int>) {
        self.viewControllers = views.map {
            let host = UIHostingController(rootView: $0.view)
            host.tabBarItem = $0.barItem
            return host
        }
        self._selectedIndex = selectedIndex
    }
    
    var body: some View {
        return TabBarController(controllers: viewControllers, selectedIndex: $selectedIndex)
        .edgesIgnoringSafeArea(.all)

    }
    
    struct Tab {
        var view: AnyView
        var barItem: UITabBarItem
        
        init<V: View>(view: V, barItem: UITabBarItem) {
            self.view = AnyView(view)
            self.barItem = barItem
        }
        
        init<V: View>(view: V, title: String?, image: String, selectedImage: String? = nil) {
            let selectedImage = selectedImage != nil ? UIImage(named: selectedImage!) : nil
            let barItem = UITabBarItem(title: title?.localized(), image: UIImage(named: image), selectedImage: selectedImage)
            self.init(view: view, barItem: barItem)
        }
    }
}

struct TabBarController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
    @Binding var selectedIndex: Int

    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = controllers
        tabBarController.delegate = context.coordinator
        tabBarController.selectedIndex = 0
        return tabBarController
    }

    func updateUIViewController(_ tabBarController: UITabBarController, context: Context) {
        tabBarController.selectedIndex = selectedIndex
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITabBarControllerDelegate {
        var parent: TabBarController

        init(_ tabBarController: TabBarController) {
            self.parent = tabBarController
        }
        
        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            parent.selectedIndex = tabBarController.selectedIndex
        }
    }
}
