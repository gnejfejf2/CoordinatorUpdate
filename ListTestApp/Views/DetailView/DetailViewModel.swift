//
//  DetailViewModel.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//
import RxSwift
import RxCocoa
import RxRelay

class DetailViewModel : ViewModelBuilderProtocol {
    
    struct Input {
        let favortieAction : Driver<Void>
    }
    
    struct Output {
        let accommodation : Driver<Accommodation>
        let favorite : Driver<FavoriteChecking>
    }
    
    struct Builder {
        let accommodation : Accommodation
        var userDefalutManager : UserDefaultsManagerProtocol
        let coordinator : DetailViewCoordinator
    }
    
  
    let networkAPI : NetworkServiceProtocol
    let errorTracker = ErrorTracker()
    let activityIndicator = ActivityIndicator()
    var builder : Builder
    let disposeBag = DisposeBag()
    
    
    
    required init(networkAPI: NetworkServiceProtocol = NetworkingAPI.shared, builder: Builder) {
        self.networkAPI = networkAPI
        self.builder = builder
    }
    
    
    func transform(input: Input) -> Output {
        let accommodation = BehaviorSubject<Accommodation>(value: builder.accommodation)
        let favortie = BehaviorSubject<FavoriteChecking>(value: builder.userDefalutManager.favoriteCheck(accommodation: builder.accommodation))
        
        input.favortieAction
            .withLatestFrom(accommodation.asDriverOnErrorNever()) { $1 }
            .drive { [weak self] item in
                guard let self = self else { return }
                self.builder.userDefalutManager.favoriteAddDelete(accommodation: item)
                favortie.onNext(self.builder.userDefalutManager.favoriteCheck(accommodation: self.builder.accommodation))
            }
            .disposed(by: disposeBag)

        
        
        return .init(
            accommodation : accommodation.asDriverOnErrorNever(),
            favorite: favortie.asDriverOnErrorNever()
        )
    }
    
    
    
}

