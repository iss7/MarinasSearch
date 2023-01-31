//
//  ViewController.swift
//  MarinasSearch
//
//  Created by Isabel Sharp on 1/28/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UICollectionViewDelegate {

    private var buttonOptions: [InterestPointType] = InterestPointType.allCases.map { icon in
        icon
    }

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
        // TODO: load the data here
        let interestType = buttonOptions[indexPath.row]
        let searchResultTEMPORARY = (0..<100).map { _ in InterestPoint(
            id: "123",
            resource: interestType,
            name: interestType.rawValue,
            web_url: URL(string: "https://marinas.com/view/ramp/5ncw_Bunkers_Harbor_Pier_Ramp_Gouldsboro_ME_United_States")!,
            location: InterestPoint.Location(lat: 65.0123, lon: 54.234, what3words: "what-three-words"),
            review_count: 4,
            images: InterestPoint.ImageCollection(
                data: [
                    InterestPoint.ImageData(full_url: URL(string: "https://img.marinas.com/v2/48c247e7d14b4c52b5b5fc5d7d0ae03b6cdad041370622cf589a72896116cccc.jpg")),
                    InterestPoint.ImageData(full_url: URL(string: "https://img.marinas.com/v2/e295c05343d697732d39c338356f182e094c8f879d79c86675a5bea73ea38fe3.jpg")),
                    InterestPoint.ImageData(full_url: URL(string: "https://img.marinas.com/v2/a8f4229bd00f8df8c8a464a07d2b2d7371f985175fa30b03721d2c1ada9ac230.jpg")),
                    InterestPoint.ImageData(full_url: URL(string: "https://img.marinas.com/v2/5b5cc2f86319bbdd848eba2237fb6a50874385ae64e2c963e5dd4e54414d72c6.jpg")),
                    InterestPoint.ImageData(full_url: URL(string: "https://img.marinas.com/v2/e32c589894f72104784c4034e6a4ca1a2e309f0733c262f1f352c53841d4f5c8.jpg")),
                    InterestPoint.ImageData(full_url: URL(string: "https://img.marinas.com/v2/c2d2286b24e67772f1a2d08f4acc7444a3aad9ed9a941be0fc74abcf3e5b2920.jpg")),
                ],
                total_count: 6)
        )

        }
        let vc = SearchResultViewController(searchResult: searchResultTEMPORARY, searchTerm: interestType.rawValue)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

