//
//  MainViewModelTest.swift
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


class MainViewModelTest: XCTestCase {

    let disposeBag = DisposeBag()
    let mockBaseCoordinator : MockBaseCoordinator = MockBaseCoordinator()
    var viewModel: MainViewModel!
    var scheduler: TestScheduler!
    var accommodationSearch : PublishSubject<Void> = PublishSubject<Void>()
    var bottomScrollTriger : PublishSubject<Void> = PublishSubject<Void>()
    var accomodationClick : PublishSubject<Accommodation> = PublishSubject<Accommodation>()
    var output : MainViewModel.Output!
    
    // MARK: - GIVEN
    override func setUp() {
        let mockNetworkingAPI =  NetworkingAPI(provider: MoyaProvider<NetworkAPI>(stubClosure: { _ in .immediate }))
       
        viewModel = MainViewModel(networkAPI: mockNetworkingAPI, builder: .init(userDefalutManager : UserDefaultsMockManager.shared , coordinator : mockBaseCoordinator))
        
        scheduler = TestScheduler(initialClock: 0, resolution: 0.01)
        output = viewModel.transform(input: .init(
            accommodationSearch: accommodationSearch.asDriverOnErrorNever(),
            bottomScrollTriger: bottomScrollTriger.asDriverOnErrorNever(),
            accomodationClick: accomodationClick.asDriverOnErrorNever())
        )

    }
    
    //MainView 1페이지 검색
    func test_Search_1_페이지검색(){

        let observer = scheduler.createObserver(Int.self)

        scheduler.createHotObservable([.next(100 , ())])
                    .bind(to: accommodationSearch)
                    .disposed(by: disposeBag)

        output.accommodations
            .asObservable()
            .map{ $0.first!.items.count }
            .bind(to: observer)
            .disposed(by: disposeBag)
//
        scheduler.start()

        let exceptEvents: [Recorded<Event<Int>>] = [
            .next(0 , 0),
            .next(100 , 20)
        ]
        XCTAssertEqual(observer.events , exceptEvents)
    }

    func test_Search_1_2_3_페이지검색(){

        let observer = scheduler.createObserver(Int.self)
        scheduler.createHotObservable([.next(100 , ())])
                    .bind(to: accommodationSearch)
                    .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(200 , ()),.next(300 , ()),.next(400 , ())])
                    .bind(to: bottomScrollTriger)
                    .disposed(by: disposeBag)
        output.accommodations
            .asObservable()
            .map{ $0.first!.items.count }
            .bind(to: observer)
            .disposed(by: disposeBag)
        scheduler.start()

        let exceptEvents: [Recorded<Event<Int>>] = [
            .next(0 , 0),
            .next(100 , 20),
            .next(200 , 40),
            .next(300 , 43)
        ]
        XCTAssertEqual(observer.events , exceptEvents)
    }

    
    func test_디테일뷰열기(){
        accomodationClick.onNext(.init(id: 0, name: "", thumbnail: "", description: .init(imagePath: "", subject: "", price: 0), rate: 0))
        XCTAssertEqual(mockBaseCoordinator.detailViewOpen , true)
    }
}

