//
//  InterestPointView.swift
//  MarinasSearch
//
//  Created by Isabel Sharp on 1/29/23.
//

import Foundation
import UIKit
import SafariServices

class InterestPointViewController: UIViewController, UICollectionViewDelegate {
    private var interestPoint: InterestPoint

    private lazy var headerView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var borderView: UIView = {
        let border = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 1))
        border.backgroundColor = .black
        return border
    }()

    private lazy var backButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back_icon"), for: .normal)
        button.addTarget(self, action: #selector(headerViewClickedBackButton), for: .touchUpInside)
        return button
    }()

    private lazy var headerTitleView: UILabel = {
        var title = UILabel()
        title.textColor = .black
        title.text = "All Results"
        title.textAlignment = .center
        return title
    }()

    private lazy var titleView: UILabel = {
        var title = UILabel()
        title.textColor = .black
        title.text = interestPoint.name
        title.textAlignment = .center
        title.font = title.font.withSize(30)
        return title
    }()

    private lazy var resourceRow = IconTitleRowView(iconImageLocation: interestPoint.resource.iconLocation, text: interestPoint.resource.rawValue)

    private lazy var coordsRow: IconTitleRowView = {
        let text = "\(interestPoint.location.lat), \(interestPoint.location.lon)"
        return IconTitleRowView(iconImageLocation: "location_icon", text: text, color: .purple)
    }()

    private lazy var ratingRow: IconTitleRowView = {
        var text: String
        if let rating = interestPoint.rating {
            text = "\(rating) / 5, \(interestPoint.review_count) reviews"
        } else {
            text = "No rating yet, \(interestPoint.review_count) reviews"
        }
        return IconTitleRowView(iconImageLocation: "star_icon", text: text, color: .darkGray)
    }()

    private lazy var webViewButton = {
        let button = UIButton()
        button.setTitle("View on Marinas.com", for: .normal)
        button.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        button.setTitleColor(.blue, for: .normal)

        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 2
        return button
    }()

    private lazy var imageCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "image_cell")
        view.delegate = self
        view.dataSource = self
        view.autoresizesSubviews = true
        view.showsHorizontalScrollIndicator = true
        return view
    }()



    private lazy var scrollView = UIScrollView(frame: .zero)
    private lazy var containerView: UIView = {
        var view = UIView()
        return view
    }()

    init(interestPoint: InterestPoint) {
        self.interestPoint = interestPoint
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .white
        [headerView, borderView, scrollView].forEach(view.addSubview)
        [backButton, headerTitleView].forEach(headerView.addSubview)
        [titleView, resourceRow, coordsRow, ratingRow, webViewButton, imageCollectionView].forEach(containerView.addSubview)

        scrollView.addSubview(containerView)
        
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        borderView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(borderView.snp.bottom)
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.height.equalTo(650)
        }

        backButton.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(20)
            make.height.width.equalTo(20)
        }
        headerTitleView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(50)
            make.left.equalTo(backButton.snp.right)
        }

        titleView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        resourceRow.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
            make.top.equalTo(titleView.snp.bottom).offset(10)
        }
        coordsRow.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
            make.top.equalTo(resourceRow.snp.bottom).offset(10)
        }
        ratingRow.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
            make.top.equalTo(coordsRow.snp.bottom).offset(10)
        }
        webViewButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(ratingRow.snp.bottom).offset(20)
            make.height.equalTo(60)
        }
        imageCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(webViewButton.snp.bottom).offset(30)
            make.height.equalTo(200)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func headerViewClickedBackButton() {
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func openWebView() {
        let webView = SFSafariViewController(url: interestPoint.web_url)
        webView.modalPresentationStyle = .overFullScreen
        self.present(webView, animated: true, completion: nil)
    }
}


public class IconTitleRowView: UIView {
    private var iconImageLocation: String
    private var textColor: UIColor
    private var text: String

    private lazy var iconView =  {
        let imageView = UIImageView()
        let image = UIImage(named: iconImageLocation)
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var labelView: UILabel = {
        var buttonLabel = UILabel()
        buttonLabel.textColor = textColor
        buttonLabel.text = text
        return buttonLabel
    }()

    init(iconImageLocation: String, text: String, color: UIColor = .black) {
        self.iconImageLocation = iconImageLocation
        self.text = text
        self.textColor = color
        super.init(frame: .zero)

        [iconView, labelView].forEach(addSubview)

        iconView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview().inset(10)
            make.width.height.equalTo(40)
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

// MARK: Methods for the ImageCollectionView
extension InterestPointViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interestPoint.images.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image_cell", for: indexPath) as! ImageCollectionViewCell
        cell.imageUrl = interestPoint.images.data[indexPath.row].full_url
        return cell
    }
}

extension InterestPointViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 250)
    }
}
