//
//  FavoriteViewController.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxMoya
import RxGesture
import RxDataSources

class FavoriteViewController : SuperViewControllerSetting<FavortieViewModel>{
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
        collectionView.register(FavoriteCellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FavoriteCellHeaderView.id)
        return collectionView
    }()
    
    
    //DataSource
    lazy var accommodationDataSource = RxCollectionViewSectionedReloadDataSource<AccommodationSectionModel> { dataSource, collectionView , indexPath, item in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccommodationCollectionViewCell.id, for: indexPath) as! AccommodationCollectionViewCell
        cell.userDefaultManager = UserDefaultsManager.shared
        cell.itemSetting(item: item)
        
        return cell
    }
    
    lazy var emptyView = UIView().then{
        $0.backgroundColor = .primaryColorReverse
        $0.addSubview(emptyButton)
    }
    
    var emptyButton = UIButton().then{
        $0.setTitle("추가된 즐겨찾기가 없습니다\n바로 추가 하러 가기", for: .normal)
        $0.setTitleColor(.primaryColor, for: .normal)
        
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.titleLabel?.numberOfLines = 0
        $0.titleLabel?.textAlignment = .center
        
        $0.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.primaryColor.cgColor
        $0.layer.cornerRadius = 8
    }
    
    
    
    
    
    var sortTypeSettingView = SortTypeSettingView()
    
    //Other
    private let sortTypeAction = PublishSubject<SortType>()
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func uiDrawing() {
        view.addSubview(accommodationCollectionView)
        view.addSubview(sortTypeSettingView)
        view.addSubview(emptyView)
        navigationItem.title = "즐겨찾기"
        
        accommodationCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        sortTypeSettingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        emptyButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    override func uiSetting() {
        accommodationDataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FavoriteCellHeaderView.id, for: indexPath) as! FavoriteCellHeaderView
                headerView.delegate = self
                return headerView
            } else {
                return UICollectionReusableView()
            }
        }
    }
    
    override func viewModelBinding() {
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in }
            
        
        let addFavoriteAction = emptyButton.rx.tap
        
        let accomodationClick = accommodationCollectionView.rx.modelSelected(Accommodation.self)
        
        sortTypeSettingView.sortTypeViewArray.forEach{ item in
            item.rx.tapGesture()
                .when(.recognized)
                .map{ _ in item.item }
                .subscribe(onNext: { [weak self] item in
                    guard let self = self else { return  }
                    self.sortTypeSettingView.hideBottomSheet()
                    self.accommodationCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                    self.sortTypeAction.onNext(item)
                })
                .disposed(by: disposeBag)
        }
        
        
        
        let output = viewModel.transform(input: .init(
            viewWillAppear: viewWillAppear.asDriverOnErrorNever() ,
            addFavoriteAction : addFavoriteAction.asDriverOnErrorNever(),
            sortTypeAction: sortTypeAction.asDriverOnErrorNever(),
            accomodationClick : accomodationClick.asDriverOnErrorNever()
        ))
        
        
        
        output.accommodations
            .filter{ $0.count != 0 }
            .drive(accommodationCollectionView.rx.items(dataSource: accommodationDataSource))
            .disposed(by: disposeBag)
        
        output.accommodations
            .map{ $0.first?.items.count != 0 }
            .drive(emptyView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.sortType
            .drive{ [weak self] item in
                guard let self = self else { return }
                self.sortTypeSettingView.sortTypeSetting(type: item)
           }
            .disposed(by: disposeBag)
        
        
        //초기값 부여
        sortTypeAction.onNext(.RecentFavorite)
    }
    
}

extension FavoriteViewController : HeaderActionProtocol{

    func headerAction(){
        sortTypeSettingView.showBottomSheet()
    }

}
