//
//  HomeCollectionViewController.swift
//  Swipe Action
//
//  Created by Bryan Luna on 10/11/23.
//

import UIKit
import Combine

enum Sections: CaseIterable {
    case primary
}

final class HomeCollectionViewController<ViewModel: HomeCollectionViewModelRepresentable>: UICollectionViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Sections, HomeModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Sections, HomeModel>
    
    private let viewModel: ViewModel
    private var subscribers: AnyCancellable?
    
    private lazy var dataSource: DataSource = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, HomeModel> { cell, indexPath, home in
            
            var config = cell.defaultContentConfiguration()
            
            config.text = home.name
            config.image = UIImage(systemName: "house")
            
            cell.contentConfiguration = config
            cell.accessories = home.isSelected ? [.checkmark()] : []
        }
        
        return DataSource(collectionView: collectionView) { collectionView, indexPath, home in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: home)
        }
    }()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindUI()
        configureCustomLayout()
    }
    
    func configureCustomLayout() {
        
        var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
        
        config.trailingSwipeActionsConfigurationProvider = { [unowned self] indexPath in
            
            let deleteAction = UIContextualAction(style: .destructive,
                                                  title: nil) { [unowned self] action, view, completion in
                viewModel.deleteItem(for: indexPath)
            }
            
            deleteAction.image = UIImage(systemName: "trash.fill")
            
            let selectAction = UIContextualAction(style: .normal,
                                                  title: nil) { [unowned self] action, view, completion in
                viewModel.selectItem(for: indexPath)
            }
            
            selectAction.image = UIImage(systemName: "checkmark")
            
            return UISwipeActionsConfiguration(actions: [deleteAction, selectAction])
        }
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func setupUI() {
        title = "Swipe Action Sample"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func bindUI() {
        viewModel.loadData()
        
        subscribers = viewModel.homesCurrentValueSubject.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        print("UI Bind Finished!")
                    case .failure(let failure):
                        fatalError(failure.localizedDescription)
                }
            }, receiveValue: { [unowned self] homes in
                applySnapshot(with: homes)
            })
    }
    
    private func applySnapshot(with: [HomeModel]) {
        var snapshot = Snapshot()
        
        snapshot.appendSections(Sections.allCases)
        snapshot.appendItems(with)
        
        dataSource.apply(snapshot, animatingDifferences: true) { [unowned self] in
            collectionView.reloadData()
        }
    }
}
