//
//  AppTransition.swift
//  Swipe Action
//
//  Created by Bryan Luna on 10/11/23.
//

enum AppTransition {
    
    case showHome
    
    var ideitifier: String { String(describing: self) }
    
    func coordinatorFor<R: AppRouter>(router: R) -> Coordinator {
        switch self {
            case .showHome: return HomeCoordinator(router: router)
        }
    }
}
