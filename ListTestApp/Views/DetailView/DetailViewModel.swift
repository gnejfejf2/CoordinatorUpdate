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
   
    }
    
    struct Output {
    
    }
    
    struct Builder {
        let coordinator : DetailViewCoordinator
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
        
        
        return .init(
            
        )
    }
    
    
    
}

