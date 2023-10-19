//
//  HomeCoordinator.swift
//  Swipe Action
//
//  Created by Bryan Luna on 10/11/23.
//

import UIKit

final class HomeCoordinator<R: AppRouter> {
    
    private let router: R
    
    init(router: R) {
        self.router = router
    }
    
    private lazy var homeViewController: UIViewController = {
        let viewModel = HomeCollectionViewModel(router: router)
        let viewController = HomeCollectionViewController(viewModel: viewModel)
        return viewController
    }()
}

extension HomeCoordinator: Coordinator {
    
    func start() {
        router.navController.pushViewController(homeViewController, animated: true)
    }
}
