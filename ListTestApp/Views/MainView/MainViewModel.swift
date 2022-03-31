//
//  MainViewModel.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import RxSwift
import RxCocoa
import RxRelay

class MainViewModel : ViewModelBuilderProtocol ,SearchAccomodationModelProtocol , ScrollPagingProtocol {
    
    struct Input {
        let accommodationSearch : Driver<Void>
        let bottomScrollTriger : Driver<Void>
        let accomodationClick : Driver<Accommodation>
    }
    
    struct Output {
        let accommodations : Driver<[AccommodationSectionModel]>
        let totalCount : Driver<Int>
        let outputError : Driver<Error>
    }
    
    struct Builder {
        let userDefalutManager : UserDefaultsManagerProtocl
        let coordinator : MainViewCoordinator
    }
    
    var totalCount: Int = 0
    
    var itemCount: Int = 20
    
    var scrollPagingCall: Bool = true
    
    var pagingCount: Int = 1
    
    
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
        let accommodationModels = BehaviorSubject<[AccommodationSectionModel]>(value: [AccommodationSectionModel(name: "최고의 숙박시설", items: [])])
        let totalCount = PublishSubject<Int>()
        
        let accommodationSearchResult = input.accommodationSearch
            .asObservable()
            .flatMap { [weak self] _ -> Observable<AccommodationResModel>  in
                guard let self = self else { return .never() }
                self.pagingCountClear()
                return self.searchAccomodation(page : self.pagingCount , networkAPI: self.networkAPI)
                    .trackError(self.errorTracker)
                    .catch{ error in
                        return .never()
                    }
            }
            .share()
           
        accommodationSearchResult
            .map{ $0.data.product }
            .asDriverOnErrorNever()
            .map{ [weak self]  getItem in
                guard let self = self else { return [] }
                self.pagingCountChecking(requestItemCount: getItem.count)
                return [AccommodationSectionModel(name: "최고의 숙박시설", items: getItem)]
            }
            .drive(accommodationModels)
            .disposed(by: disposeBag)
        
        accommodationSearchResult
            .map{ $0.data.totalCount }
            .asDriverOnErrorNever()
            .drive(totalCount)
            .disposed(by: disposeBag)
        
        
        input.bottomScrollTriger
            .filter{ [weak self] _ in
                guard let self = self else { return false }
                return self.scrollPagingCall
            }
            .asObservable()
            .flatMap { [weak self] _ -> Observable<AccommodationResModel>  in
                guard let self = self else { return .never() }
                return self.searchAccomodation(page : self.pagingCount , networkAPI: self.networkAPI)
                    .trackError(self.errorTracker)
                    .catch{ error in
                        return .never()
                    }
            }
            .withLatestFrom(accommodationModels.asObservable()) {($0.data.product , $1) }
            .map({ [weak self] (getItem , original) -> [AccommodationSectionModel] in
                guard let self = self else { return [] }
                self.pagingCountChecking(requestItemCount: getItem.count)
                var sectionModels = original
                sectionModels[0].items = sectionModels[0].items + getItem
                return sectionModels
            })
            .asDriverOnErrorNever()
            .drive(accommodationModels)
            .disposed(by: disposeBag)
        
        
        input.accomodationClick
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.builder.coordinator.detailViewOpen(accomodation: item)
            })
            .disposed(by: disposeBag)
        
        return .init(
            accommodations: accommodationModels.asDriverOnErrorNever(),
            totalCount : totalCount.asDriverOnErrorNever() ,
            outputError: errorTracker.asDriver()
        )
    }
    
    
    
}


