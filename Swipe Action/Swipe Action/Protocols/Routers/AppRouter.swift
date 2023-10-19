//
//  AppRouter.swift
//  Swipe Action
//
//  Created by Bryan Luna on 10/11/23.
//

import UIKit

protocol Router {
    
    associatedtype Route
    
    var navController: UINavigationController { get set }
    
    func process(route: Route)
    func exti()
}

protocol AppRouter: Router where Route == AppTransition { }
