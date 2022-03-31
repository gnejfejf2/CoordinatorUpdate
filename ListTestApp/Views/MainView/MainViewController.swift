//
//  MainViewController.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import UIKit
import RxSwift
import RxMoya
import RxDataSources

class MainViewController : SuperViewControllerSetting<MainViewModel>{
    
    let accommodationCollectionView : UICollectionView = {
        
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(400)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
        let groupSize = itemSize
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        headerElement.pinToVisibleBounds = true
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerElement]
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: compositionalLayout)
        collectionView.backgroundColor = .primaryColorReverse
        collectionView.indicatorStyle = .white
        collectionView.register(AccommodationCollectionViewCell.self, forCellWithReuseIdentifier: AccommodationCollectionViewCell.id)
        collectionView.register(AccomodationHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AccomodationHeaderView.id)
        return collectionView
    }()
    
    
    //DataSource
    lazy var accommodationDataSource = RxCollectionViewSectionedReloadDataSource<AccommodationSectionModel> { dataSource, collectionView , indexPath, item in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccommodationCollectionViewCell.id, for: indexPath) as! AccommodationCollectionViewCell
        cell.userDefaultManager = UserDefaultsManager.shared
        cell.itemSetting(item: item)
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        
    }
    
    override func uiDrawing() {
        view.addSubview(accommodationCollectionView)
        navigationItem.title = "검색"
        
        accommodationCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func uiSetting() {
        
        accommodationDataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AccomodationHeaderView.id, for: indexPath) as! AccomodationHeaderView
                headerView.itemSetting(item: dataSource.sectionModels[indexPath.item].name)
                return headerView
            } else {
                return UICollectionReusableView()
            }
        }
    }
    
    override func viewModelBinding() {
        let accommodationSearch = PublishSubject<Void>()
        let bottomScrollTriger = accommodationCollectionView.rx.reachedBottom(offset: 10)
        let accomodationClick = accommodationCollectionView.rx.modelSelected(Accommodation.self)
        
        let output = viewModel.transform(input: .init(
            accommodationSearch: accommodationSearch.asDriverOnErrorNever() ,
            bottomScrollTriger : bottomScrollTriger.asDriverOnErrorNever(),
            accomodationClick : accomodationClick.asDriverOnErrorNever()
        ))
        
        
        
        output.accommodations
            .drive(accommodationCollectionView.rx.items(dataSource: accommodationDataSource))
            .disposed(by: disposeBag)
        
        output.outputError
            .drive(onNext: { [ weak self] value in
                guard let self = self else { return }
                let alert = UIAlertController(title: "오류", message: value.localizedDescription , preferredStyle: .alert)
                let success = UIAlertAction(title: "확인", style: .default)
                alert.addAction(success)
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        
        accommodationSearch.onNext(())
    }
    
}
