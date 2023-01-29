//
//  IconButton.swift
//  MarinasSearch
//
//  Created by Isabel Sharp on 1/28/23.
//

import Foundation
import UIKit

public class IconLabelButton: UICollectionViewCell {
    var icon: ButtonType {
        get {
            selectedIcon
        }
        set {
            selectedIcon = newValue
            iconView.image = UIImage(named: newValue.iconLocation)
            labelView.text = newValue.rawValue
        }
    }

    private var selectedIcon: IconLabelButton.ButtonType = .marina

    private lazy var iconView =  {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()

    private lazy var labelView: UILabel = {
        var buttonLabel = UILabel()
        buttonLabel.textColor = .black
        buttonLabel.textAlignment = .center

        return buttonLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red

        [iconView, labelView].forEach(addSubview)

        iconView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        labelView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

public extension IconLabelButton {
    enum ButtonType: String, CaseIterable {
        case anchorage
        case bridge
        case ferry
        case harbor
        case inlet
        case landmark
        case lighthouse
        case lock
        case marina
        case ramp

        var iconLocation: String {
            "\(rawValue)_icon"
        }
    }
}
