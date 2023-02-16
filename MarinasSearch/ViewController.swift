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
    let locationManager = LocationManager()

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
                self?.showHideLoadingScreen(show: false)
                self?.showSearchResults(results: newValue)
            }
        }
    }

    private var currentSearchResults: [InterestPoint] = []

    private lazy var buttonGridCollectionView: UICollectionView = {
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

    private lazy var loadingOverlay: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        return overlay
    }()

    private lazy var loadingImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "sailboat")
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var loadingWave: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "wavy")
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var textInput: UITextField = {
        let textInput = UITextField()
        textInput.placeholder = "Search..."
        textInput.font = UIFont.systemFont(ofSize: 15)
        textInput.layer.borderWidth = 1
        textInput.layer.cornerRadius = 10
        textInput.layer.borderColor = UIColor.gray.cgColor
        textInput.keyboardType = UIKeyboardType.default
        textInput.returnKeyType = UIReturnKeyType.done
        textInput.clearButtonMode = UITextField.ViewMode.whileEditing
        textInput.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textInput.frame.height))
        textInput.leftViewMode = .always
        textInput.delegate = self
        return textInput
    }()

    private lazy var instructions: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = "Enter a search term above, or select a button below to search for points of interest near you!"
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        textInput.text = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestLocation()
        // Do any additional setup after loading the view.
        [textInput, instructions, buttonGridCollectionView, loadingOverlay].forEach(view.addSubview)
        [loadingWave, loadingImage].forEach(view.addSubview)
        showHideLoadingScreen(show: false)

        let gridInset = UIDevice.current.userInterfaceIdiom == .pad ? 100 : 30
        textInput.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide).inset(gridInset)
            make.height.equalTo(50)
        }
        instructions.snp.makeConstraints { make in
            make.top.equalTo(textInput.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(gridInset)
            make.height.equalTo(70)
        }

        buttonGridCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(gridInset)
            make.top.equalTo(instructions.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }

        loadingOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadingImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(200)
        }
        loadingWave.snp.makeConstraints { make in
            make.width.height.equalTo(350)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(90)
        }
    }

    private func showSearchResults(results: [InterestPoint]) {
        let vc = SearchResultViewController(searchResult: results)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }

    private func showHideLoadingScreen(show: Bool) {
        loadingOverlay.isHidden = !show
        loadingImage.isHidden = !show
        loadingWave.isHidden = !show
    }

    private func animateLoading() {
        showHideLoadingScreen(show: true)

        UIView.animateKeyframes(withDuration: 4, delay: 0, options: .repeat, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/4) {
                self.loadingImage.transform = CGAffineTransform(rotationAngle: .pi/12)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 2/4) {
                self.loadingImage.transform = CGAffineTransform(rotationAngle: -.pi/12)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 1/4) {
                self.loadingImage.transform = CGAffineTransform(rotationAngle: 0)
            }
        })
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
        animateLoading()

        searchAPI.fetchPointsByKind(interestType: interestType) {[weak self] results in
            self?.searchResults = results
        }
    }
}

// MARK:- ---> UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return true
        }
        animateLoading()
        searchAPI.fetchPointsBySearchTerm(searchTerm: text) { [weak self] results in
            self?.searchResults = results
        }
        return true
    }

}

