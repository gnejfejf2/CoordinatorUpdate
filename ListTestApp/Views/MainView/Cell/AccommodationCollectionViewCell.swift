//
//  AccommodationCollectionViewCell.swift
//  ListTestApp
//
//  Created by 강지윤 on 2022/03/30.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class AccommodationCollectionViewCell: UICollectionViewCell , CellSettingProtocl {
    
    static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
    
    
    
    lazy var mainStackView = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
       
        $0.addArrangedSubview(mainImageView)
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(descriptionLabel)
        $0.addArrangedSubview(subInformationStackView)
        $0.addArrangedSubview(priceLabel)
        
    }
    
    
    var mainImageView = UIImageView()
    var titleLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = .primaryColor
    }
    
    var descriptionLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = .primaryColor.withAlphaComponent(0.75)
    }
    
    
    lazy var subInformationStackView = UIStackView().then{
        $0.backgroundColor = .primaryColorReverse
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
        $0.addArrangedSubview(starImage)
        $0.addArrangedSubview(rateLabel)
    }
    
    var starImage = UIImageView().then{
        $0.image = UIImage(systemName: "star.fill")
        $0.tintColor = .yellow
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
    }
    
    var rateLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = .primaryColor
    }
    
    
    
    var priceLabel = RentalTypeStackView()
    
    var favoriteButton = UIButton().then{
        $0.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        $0.imageView?.tintColor = .gray
    }
    
    //Other
    var item: Accommodation?
    var userDefaultManager : UserDefaultsManagerProtocl?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        uiSetting()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }

    
    func uiSetting() {
        addSubview(mainStackView)
        addSubview(favoriteButton)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
        
        mainImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
      
        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
        
        favoriteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favoriteAction)))

    }
    
    
    func itemSetting(item : Accommodation) {
        self.item = item
        guard let accommodation = self.item else { return }
        mainImageView.kf.setImage(with: URL(string: accommodation.thumbnail))
        titleLabel.text = accommodation.name
        descriptionLabel.text = accommodation.description.subject
        priceLabel.itemSetting(price: accommodation.description.price)
        rateLabel.text = "\(accommodation.rate)"
        
        favoriteColorSetting(accommodation: accommodation)
    }
    
    
    @objc func favoriteAction(){
        guard let accommodation = self.item else { return }
        userDefaultManager?.favoriteAddDelete(accommodation: accommodation)
        favoriteColorSetting(accommodation: accommodation)
    }
    
    func favoriteColorSetting(accommodation: Accommodation){
        if(userDefaultManager?.favoriteCheck(accommodation: accommodation) == .Check){
            favoriteButton.imageView?.tintColor = .systemPink
        }else{
            favoriteButton.imageView?.tintColor = .gray
        }

    }
}
