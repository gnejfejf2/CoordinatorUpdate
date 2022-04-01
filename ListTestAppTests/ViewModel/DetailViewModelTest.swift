//
//  DetailViewModelTest.swift
//  ListTestAppTests
//
//  Created by 강지윤 on 2022/04/01.
//

import XCTest
import Moya
import RxMoya
import RxTest
import RxSwift
import RxCocoa


@testable import ListTestApp


class DetailViewModelTest: XCTestCase {
    
    let disposeBag = DisposeBag()
    var viewModel: DetailViewModel!
    var scheduler: TestScheduler!
//    var viewWillAppear : PublishSubject<Void> = PublishSubject<Void>()
    var favortieAction :  PublishSubject<Void> = PublishSubject<Void>()
//    var sortTypeAction :  PublishSubject<SortType> = PublishSubject<SortType>()
//    var accomodationClick : PublishSubject<Accommodation> = PublishSubject<Accommodation>()
    var output : DetailViewModel.Output!
    
    var item = Accommodation(id: 2, name: "테스트2", thumbnail: "", description: .init(imagePath: "", subject: "", price: 40000), rate: 3)
    // MARK: - GIVEN
    override func setUp() {
        let mockNetworkingAPI =  NetworkingAPI(provider: MoyaProvider<NetworkAPI>(stubClosure: { _ in .immediate }))
        let coordinator = DetailViewCoordinator(builder: .init(
            navigationController: UINavigationController(),
            parentCoordinator: MockBaseCoordinator(),
            item: item)
        )
        viewModel = DetailViewModel(networkAPI: mockNetworkingAPI, builder: .init(accommodation: item, userDefalutManager: UserDefaultsMockManager.shared, coordinator: coordinator))
        
        //즐겨찾기 리스트 초기화 후
        viewModel.builder.userDefalutManager.clearRemoveList()
        //아이템등록
        viewModel.builder.userDefalutManager.favoriteAddDelete(accommodation: item)
        
        
        scheduler = TestScheduler(initialClock: 0, resolution: 0.01)
        output = viewModel.transform(input:
                .init(favortieAction: favortieAction.asDriverOnErrorNever())
        )
        
    }
    
    func test_로컬즐겨찾기_리스트_체크(){
        
        
       

        let observer = scheduler.createObserver(FavoriteChecking.self)

        scheduler.createHotObservable([
                                        .next(100 , ())
                                      ])
            .bind(to: favortieAction)
            .disposed(by: disposeBag)

        output.favorite
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)

        scheduler.start()



        let exceptEvents: [Recorded<Event<FavoriteChecking>>] = [
            .next(0 , .Check) ,
            .next(100 , .UnCheck)
        ]

        XCTAssertEqual(observer.events , exceptEvents)
    }

}
