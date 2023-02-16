//
//  ImageCollectionViewCell.swift
//  MarinasSearch
//
//  Created by Isabel Sharp on 1/30/23.
//

import UIKit
import Foundation

public class ImageCollectionViewCell: UICollectionViewCell {
    var imageUrl: URL? {
        get {
            currentUrl
        }
        set {
            currentUrl = newValue
            updateImage(url: newValue)
        }
    }

    private var currentUrl = URL(string: "")

    private func updateImage(url: URL?) {
        DispatchQueue.global().async {
            guard let url = url else {
                return
            }

            guard let data = try? Data(contentsOf: url) else {
                return
            }

            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
                self.imageView.contentMode = UIView.ContentMode.scaleAspectFit
            }
        }
    }

    public lazy var imageView: UIImageView =  {
        let image = UIImageView()
        image.clipsToBounds = true
        return image
    }()

    public lazy var content: UIView = {
        var view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        content.addSubview(imageView)
        addSubview(content)
        content.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(250)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
