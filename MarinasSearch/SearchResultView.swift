//
//  SearchResult.swift
//  MarinasSearch
//
//  Created by Isabel Sharp on 1/29/23.
//

import UIKit
import Foundation

public class SearchResultView: UICollectionViewCell {
    var searchResult: SearchResult {
        get {
            selectedSearchResult
        }
        set {
            selectedSearchResult = newValue
            iconView.image = UIImage(named: newValue.interestType.iconLocation)
            labelView.text = newValue.name
        }
    }

    private var selectedSearchResult = SearchResult(name: "test", interestType: .marina)

    private lazy var iconView =  {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()

    private lazy var labelView: UILabel = {
        var buttonLabel = UILabel()
        buttonLabel.textColor = .black

        return buttonLabel
    }()

    private lazy var content =  {
        let view = UIView(frame: self.bounds)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(content)
        [iconView, labelView].forEach(content.addSubview)

        iconView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview().inset(10)
            make.width.equalTo(40)
        }

        labelView.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.top.right.bottom.equalToSuperview().inset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct SearchResult: Codable {
    var name: String

    var interestType: InterestPoint
}
