//
//  SearchResultViewController.swift
//  MarinasSearch
//
//  Created by Isabel Sharp on 1/29/23.
//

import Foundation
import UIKit
import SnapKit

class SearchResultViewController: UIViewController, UICollectionViewDelegate {

    private var searchResult: [InterestPoint]

    private lazy var searchResultCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.register(SearchResultView.self, forCellWithReuseIdentifier: "search_cell")
        view.delegate = self
        view.dataSource = self
        view.autoresizesSubviews = true
        view.showsVerticalScrollIndicator = true
        return view
    }()

    private lazy var headerView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var backButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back_icon"), for: .normal)
        button.addTarget(self, action: #selector(headerViewClickedBackButton), for: .touchUpInside)
        return button
    }()

    private lazy var titleView: UILabel = {
        var title = UILabel()
        title.textColor = .black
        title.text = "Results"
        title.textAlignment = .center
        return title
    }()

    private lazy var noResults: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = "No results found. Try a different search term!"
        label.textAlignment = .center
        return label
    }()

    private lazy var containerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        [backButton, titleView].forEach(headerView.addSubview)
        containerView.addSubview(searchResultCollectionView)

        [containerView, headerView, noResults].forEach(view.addSubview)

        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }

        containerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
        searchResultCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        backButton.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(20)
            make.height.width.equalTo(20)
        }
        titleView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(50)
            make.left.equalTo(backButton.snp.right)
        }

        noResults.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(50)
        }

        if !searchResult.isEmpty {
            noResults.isHidden = true
        }
    }

    // MARK: init
    init(searchResult: [InterestPoint]) {
        self.searchResult = searchResult
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func headerViewClickedBackButton() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Methods for the collectionview
extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "search_cell", for: indexPath) as! SearchResultView
        cell.searchResult = searchResult[indexPath.row]
        return cell
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let interestPoint = searchResult[indexPath.row]

        let vc = InterestPointViewController(interestPoint: interestPoint)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}


