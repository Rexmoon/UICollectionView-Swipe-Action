//
//  HomeModel.swift
//  Swipe Action
//
//  Created by Bryan Luna on 10/11/23.
//

import Foundation

struct HomeModel {
    let id: UUID = .init()
    let name: String
    let address: String
    let street: Int
    var isSelected: Bool
}

extension HomeModel: Hashable, Equatable {
    
    static func == (lhs: HomeModel, rhs: HomeModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
