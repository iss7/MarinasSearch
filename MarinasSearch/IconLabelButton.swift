//
//  IconButton.swift
//  MarinasSearch
//
//  Created by Isabel Sharp on 1/28/23.
//

import Foundation
import UIKit

public class IconLabelButton: UICollectionViewCell {
    var icon: InterestPointType {
        get {
            selectedIcon
        }
        set {
            selectedIcon = newValue
            iconView.image = UIImage(named: newValue.iconLocation)
            labelView.text = newValue.rawValue
        }
    }

    private var selectedIcon: InterestPointType = .marina

    private lazy var iconView: UIImageView =  {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()

    private lazy var labelView: UILabel = {
        var buttonLabel = UILabel()
        buttonLabel.textColor = .black
        buttonLabel.textAlignment = .center

        return buttonLabel
    }()

    private lazy var iconLabelButtonView: UIView = {
        let view = UIView(frame: bounds)
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 2
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(iconLabelButtonView)
        [iconView, labelView].forEach(iconLabelButtonView.addSubview)

        // slightly different layout for ipad
        let topInset = UIDevice.current.userInterfaceIdiom == .pad ? 20 : 0
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(topInset)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalTo(labelView.snp.top)
        }

        labelView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
