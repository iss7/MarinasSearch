//
//  SearchResult.swift
//  MarinasSearch
//
//  Created by Isabel Sharp on 1/29/23.
//

import UIKit
import Foundation

public class SearchResultView: UICollectionViewCell {
    var searchResult: InterestPoint {
        get {
            selectedSearchResult
        }
        set {
            selectedSearchResult = newValue
            iconView.image = UIImage(named: newValue.kind.iconLocation)
            labelView.text = newValue.name
        }
    }

    private var selectedSearchResult = InterestPoint(id: "123", resource: "point", kind: .marina, name: "test", web_url: URL(string: "www.google.com")!, location: InterestPoint.Location(lat: 65.0123, lon: 54.234, what3words: "what-three-words"), review_count: 4, images: InterestPoint.ImageCollection(data: [], total_count: 0))

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
