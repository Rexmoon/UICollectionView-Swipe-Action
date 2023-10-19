//
//  HomeCollectionViewModel.swift
//  Swipe Action
//
//  Created by Bryan Luna on 10/11/23.
//

import Foundation
import Combine

protocol HomeCollectionViewModelRepresentable {
    
    var homesCurrentValueSubject: CurrentValueSubject<[HomeModel], Error> { get }
    
    func loadData()
    func selectItem(for indexPath: IndexPath)
    func deleteItem(for indexPath: IndexPath)
}

final class HomeCollectionViewModel<R: AppRouter> {
    
    private let router: R
    
    private var homes: [HomeModel] = [] {
        didSet {
            homesCurrentValueSubject.send(homes)
        }
    }
    
    internal var homesCurrentValueSubject: CurrentValueSubject<[HomeModel], Error> = .init([])
    
    init(router: R) {
        self.router = router
    }
}

extension HomeCollectionViewModel: HomeCollectionViewModelRepresentable {
    
    func loadData() {
        homes = (0..<50).map {
            HomeModel(name: "House \($0)",
                      address: "Street \($0)",
                      street: $0,
                      isSelected: false)
        }
        
        homesCurrentValueSubject.send(homes)
    }
    
    func selectItem(for indexPath: IndexPath) {
        homes[indexPath.row].isSelected.toggle()
    }
    
    func deleteItem(for indexPath: IndexPath) {
        homes.remove(at: indexPath.row)
    }
}
