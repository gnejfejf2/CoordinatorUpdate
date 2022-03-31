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
import RxDataSources

class DetailViewController : SuperViewControllerSetting<DetailViewModel>{

    lazy var favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: nil, action: nil)

    lazy var mainScrollView = UIScrollView().then{
        $0.addSubview(contentView)
    }
    
    lazy var contentView = UIView().then{
        $0.addSubview(mainImageView)
        $0.addSubview(dommyView)
    }
    
    
    var mainImageView = StretchyHeaderView().then{
        $0.imageView.image = UIImage(named: "은하")
    }
    var dommyView = UIView()
    
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
        
        mainImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(200)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
        
        
        dommyView.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom)
            
            make.width.equalToSuperview()
            make.height.equalTo(3000)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    override func uiSetting() {
        mainScrollView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainImageView.scrollViewDidScroll(scrollView: scrollView)
    }
}
