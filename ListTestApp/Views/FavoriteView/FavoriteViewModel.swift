//
//  FavoriteViewModel.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//


import RxSwift
import RxCocoa
import RxRelay

class FavortieViewModel : ViewModelBuilderProtocol {
    
    struct Input {
        let viewWillAppear : Driver<Void>
        let bottomScrollTriger : Driver<Void>
        let addFavoriteAction : Driver<Void>
        let sortTypeAction : Driver<SortType>
    }
    
    struct Output {
        let accommodations : Driver<[AccommodationSectionModel]>
        let sortType : Driver<SortType>
    }
    
    struct Builder {
        let userDefalutManager : UserDefaultsManagerProtocl
        let coordinator : FavoriteViewCoordinator
    }
    
  
    let networkAPI : NetworkServiceProtocol
    let errorTracker = ErrorTracker()
    let activityIndicator = ActivityIndicator()
    let builder : Builder
    let disposeBag = DisposeBag()
    
    
    
    required init(networkAPI: NetworkServiceProtocol = NetworkingAPI.shared, builder: Builder) {
        self.networkAPI = networkAPI
        self.builder = builder
    }
    
    
    func transform(input: Input) -> Output {
        let accommodationModels = BehaviorSubject<[AccommodationSectionModel]>(value: [AccommodationSectionModel(name: "좋아요에 등록한 숙소", items: UserDefaultsManager.shared.favoriteList)])
        let sortType = PublishSubject<SortType>()
        
        
        
        input.viewWillAppear
            .asObservable()
            .withLatestFrom(accommodationModels){ $1 }
            .withLatestFrom(sortType){ ($0 , $1) }
            .map({ [weak self] (original , sortType) -> [AccommodationSectionModel] in
                guard let self = self else { return [] }
                var sectionModels = original
                sectionModels[0].items = self.builder.userDefalutManager.favoriteList.sortAction(sortType: sortType , userManager: self.builder.userDefalutManager)
                return sectionModels
            })
            .asDriverOnErrorNever()
            .drive(accommodationModels)
            .disposed(by: disposeBag)
        
        let sortAction = input.sortTypeAction
            .distinctUntilChanged()
            .asSharedSequence()
        
        sortAction
            .drive(sortType)
            .disposed(by: disposeBag)
        
        
        sortAction
            .asObservable()
            .withLatestFrom(accommodationModels) { ($0 , $1) }
            .map{ [weak self] (sort , item) -> [AccommodationSectionModel] in
                guard let self = self else { return [] }
                return [item[0].itemSort(sortType: sort , userManager: self.builder.userDefalutManager)]
            }
            .asDriverOnErrorNever()
            .drive(accommodationModels)
            .disposed(by: disposeBag)
        
        input.addFavoriteAction
            .drive { [weak self] _ in
                guard let self = self else { return  }
                self.builder.coordinator.parentCoordinator.moveTo(flow: .Main)
            }
            .disposed(by: disposeBag)

            
        return .init(
            accommodations: accommodationModels.asDriverOnErrorNever() ,
            sortType : sortType.asDriverOnErrorNever()
        )
    }

}



