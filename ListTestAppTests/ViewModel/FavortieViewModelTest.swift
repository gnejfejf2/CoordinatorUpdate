//
//  FavortieViewModelTest.swift
//  ListTestAppTests
//
//  Created by 강지윤 on 2022/03/31.
//

import XCTest
import Moya
import RxMoya
import RxTest
import RxSwift
import RxCocoa


@testable import ListTestApp


class FavoriteViewModelTest: XCTestCase {
    
    let disposeBag = DisposeBag()
    var viewModel: FavortieViewModel!
    var scheduler: TestScheduler!
    var viewWillAppear : PublishSubject<Void> = PublishSubject<Void>()
    var addFavoriteAction :  PublishSubject<Void> = PublishSubject<Void>()
    var sortTypeAction :  PublishSubject<SortType> = PublishSubject<SortType>()
    var accomodationClick : PublishSubject<Accommodation> = PublishSubject<Accommodation>()
    var output : FavortieViewModel.Output!
    
    var testItems : Accommodations = [
        Accommodation(id: 1, name: "테스트", thumbnail: "", description: .init(imagePath: "", subject: "", price: 30000), rate: 4) ,
        Accommodation(id: 2, name: "테스트2", thumbnail: "", description: .init(imagePath: "", subject: "", price: 40000), rate: 3) ,
        Accommodation(id: 3, name: "테스트", thumbnail: "", description: .init(imagePath: "", subject: "", price: 10000), rate: 2) ,
        Accommodation(id: 4, name: "테스트2", thumbnail: "", description: .init(imagePath: "", subject: "", price: 20000), rate: 1)
    ]
    
    // MARK: - GIVEN
    override func setUp() {
        let mockNetworkingAPI =  NetworkingAPI(provider: MoyaProvider<NetworkAPI>(stubClosure: { _ in .immediate }))
        
        let coordinator = FavoriteViewCoordinator(navigationController: UINavigationController(), parentCoordinator: .init(navigationController: UINavigationController()))
        viewModel = FavortieViewModel(networkAPI: mockNetworkingAPI, builder: .init(userDefalutManager: UserDefaultsMockManager.shared, coordinator: coordinator))
        
        viewModel.builder.userDefalutManager.clearRemoveList()
        testItems.forEach{
            viewModel.builder.userDefalutManager.favoriteAddDelete(accommodation: $0)
        }
        
        scheduler = TestScheduler(initialClock: 0, resolution: 0.01)
        output = viewModel.transform(input:
                .init(
                    viewWillAppear: viewWillAppear.asDriverOnErrorNever() ,
                    addFavoriteAction: addFavoriteAction.asDriverOnErrorNever(),
                    sortTypeAction: sortTypeAction.asDriverOnErrorNever(),
                    accomodationClick: accomodationClick.asDriverOnErrorNever()
                )
        )
        
    }
    
    func test_로컬즐겨찾기_리스트_체크(){
       
        
        
        let observer = scheduler.createObserver(Int.self)
        
        scheduler.createHotObservable([.next(0 , ())])
            .bind(to: viewWillAppear)
            .disposed(by: disposeBag)

        output.accommodations
            .asObservable()
            .map{ $0.first!.items.count }
            .bind(to: observer)
            .disposed(by: disposeBag)

        scheduler.start()

        
        
        let exceptEvents: [Recorded<Event<Int>>] = [
            .next(0 , 4)
        ]
        
        XCTAssertEqual(observer.events , exceptEvents)
    }
    
    func test_로컬즐겨찾기_정렬_체크(){
       
        viewModel.builder.userDefalutManager.clearRemoveList()
        testItems.forEach{
            viewModel.builder.userDefalutManager.favoriteAddDelete(accommodation: $0)
        }
        
        let observer = scheduler.createObserver(Int.self)
        
        scheduler.createHotObservable([
                .next(0 , .RecentFavorite),
                .next(100 , .LateFavorite),
                .next(200 , .HighestPrice),
                .next(300 , .LowPrice),
                .next(400 , .HighestRating),
                .next(500 , .LowRating)
        ])
            .bind(to: sortTypeAction)
            .disposed(by: disposeBag)

        output.accommodations
            .asObservable()
            .map{ $0.first!.items.first!.id }
            .bind(to: observer)
            .disposed(by: disposeBag)

        scheduler.start()

        
        //ViewModel이 BehaviorSubject로 생겨 
        let exceptEvents: [Recorded<Event<Int>>] = [
            .next(0 , 1),
            .next(0 , 1),
            .next(100 , 4),
            .next(200 , 2),
            .next(300 , 3),
            .next(400 , 1),
            .next(500 , 4)
        ]
        XCTAssertEqual(observer.events , exceptEvents)
    }
    
}
