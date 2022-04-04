//
//  DetailViewController.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxMoya
import Kingfisher

class DetailViewController : SuperViewControllerSetting<DetailViewModel>{

    lazy var favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: nil, action: nil)

    lazy var mainScrollView = UIScrollView().then{
        $0.addSubview(contentView)
    }
    
    lazy var contentView = UIView().then{
        $0.addSubview(mainImageView)
        $0.addSubview(topInformationView)
        $0.addSubview(descriptionLabel)
        $0.addSubview(priceLabel)
        $0.addSubview(dommyView)
    }
    
    
    var mainImageView = StretchyHeaderView().then{
        $0.imageView.image = UIImage(named: "은하")
    }
    
    var topInformationView = TopInformationView()
    
    
    var descriptionLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = .primaryColor.withAlphaComponent(0.75)
    }
    
    var priceLabel = RentalTypeStackView()
    
    let topPadding = UIApplication.shared.windows.first!.safeAreaInsets.top
    
    
    var dommyView = UIView()
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.primaryColor]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func uiDrawing() {
        
        navigationItem.rightBarButtonItem = favoriteButton
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view) // 스크롤뷰가 표현될 영역
        }
        
        mainScrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(200)
        }
        
        topInformationView.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(topInformationView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16 )
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        dommyView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(3000)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    override func uiSetting() {
        mainScrollView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
 
    override func viewModelBinding() {
    
        let favoriteAction = favoriteButton.rx.tap
        
        let output = viewModel.transform(input: .init(
            favortieAction: favoriteAction.asDriverOnErrorNever()
        ))
        
        
        
        output.accommodation
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.mainImageView.imageView.kf.setImage(with: URL(string: item.description.imagePath), placeholder: UIImage(named: "은하"))
                self.descriptionLabel.text = item.description.subject
                self.priceLabel.itemSetting(price: item.description.price)
                self.topInformationView.itemSetting(item: item)
                self.navigationItem.title = item.name
            })
            .disposed(by: disposeBag)
        
        output.favorite
            .map{ ($0 == .Check ? UIColor.systemPink :  UIColor.gray)  }
            .drive(favoriteButton.rx.tintColor)
            .disposed(by: disposeBag)
    }
    
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainImageView.scrollViewDidScroll(scrollView: scrollView)
  
       
        if(scrollView.contentOffset.y <= -44 - topPadding){
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear]
        }else{
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.primaryColor]
        }
        
    }
}
