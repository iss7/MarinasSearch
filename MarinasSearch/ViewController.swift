//
//  ViewController.swift
//  MarinasSearch
//
//  Created by Isabel Sharp on 1/28/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UICollectionViewDelegate {
    let searchAPI = SearchAPI()

    private var buttonOptions: [InterestPointType] = InterestPointType.allCases.map { icon in
        icon
    }

    var searchResults: [InterestPoint] {
        get {
            currentSearchResults
        }
        set {
            currentSearchResults = newValue
            DispatchQueue.main.async { [weak self] in
                self?.showSearchResults(results: newValue)
            }
        }
    }

    private var currentSearchResults: [InterestPoint] = []

    private lazy var buttonGridCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.register(IconLabelButton.self, forCellWithReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        view.autoresizesSubviews = true
        view.showsVerticalScrollIndicator = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(buttonGridCollectionView)

        let gridInset = UIDevice.current.userInterfaceIdiom == .pad ? 100 : 30
        buttonGridCollectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(gridInset)
            make.bottom.equalToSuperview()
        }
    }

    private func showSearchResults(results: [InterestPoint]) {
        let vc = SearchResultViewController(searchResult: results, searchTerm: "")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

// MARK: Methods for the collectionview
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonOptions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! IconLabelButton

        cell.icon = buttonOptions[indexPath.row]
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 8.0, bottom: 1.0, right: 8.0)
    }

    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let numItems = UIDevice.current.userInterfaceIdiom == .pad ? 3.0 : 2.0
        let widthPerItem = collectionView.frame.width / numItems - lay.minimumInteritemSpacing
        return CGSize(width: widthPerItem - 8, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let interestType = buttonOptions[indexPath.row]
        fetchPointOfInterest(interestType: interestType)
    }

    private func fetchPointOfInterest(interestType: InterestPointType) {
        searchAPI.fetchPointsByKind(interestType: interestType) {[weak self] results in
            self?.searchResults = results
        }
    }
}

