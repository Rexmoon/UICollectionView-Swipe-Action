//
//  App.swift
//  Swipe Action
//
//  Created by Bryan Luna on 10/11/23.
//

import Foundation
import UIKit

final class App {
    
    var navController: UINavigationController = .init()
}

extension App: AppRouter {
    
    func process(route: AppTransition) {
        let coordinator = route.coordinatorFor(router: self)
        
        print(route.ideitifier)
        
        coordinator.start()
    }
    
    func exti() {
        navController.popToRootViewController(animated: true)
    }
}

extension App: Coordinator {
    
    func start() {
        process(route: .showHome)
    }
}
