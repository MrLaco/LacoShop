//
//  MainPageViewController.swift
//  LacoShop
//
//  Created by Данил Терлецкий on 24.08.2023.
//

import UIKit
import SnapKit

class MainPageViewController: UIViewController {

    private var adverts: [Advert] = []

    // MARK: - LyfeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

        loadAdverts()

        setupUI()
        setupConstraints()
    }

    // MARK: - UI

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(AdvertCell.self, forCellWithReuseIdentifier: "AdvertCell")

        return collectionView
    }()

    private func setupUI() {
        title = "Товары"

        view.backgroundColor = .white
    }

    private func setupConstraints() {
        addSubviews(for: view, subviews: collectionView)

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    // MARK: - Data

    private func loadAdverts() {
        NetworkingService.shared.fetchAdverts { result in
            switch result {
            case .success(let adverts):
                self.adverts = adverts
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Ошибка: \(error)")

                let alertVC = UIAlertController(
                    title: "Ошибка!",
                    message: "Не удалось загрузить данные с сервера =(",
                    preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true)
            }
        }
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate

extension MainPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let width = view.frame.width
        let numberOfColumns: CGFloat = 2
        let itemSpacing: CGFloat = 16

        let itemWidth = (width - 3 * itemSpacing) / numberOfColumns
        return CGSize(width: itemWidth, height: itemWidth * 1.5)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let advertId = adverts[indexPath.item].id

        NetworkingService.shared.fetchAdvertDetails(for: advertId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let advertDetails):
                    let advertDetailsVC = AdvertDetailsViewController()
                    advertDetailsVC.advertDetails = advertDetails
                    self.present(advertDetailsVC, animated: true)
                case .failure(let error):
                    print("Ошибка: \(error)")

                    let alertVC = UIAlertController(
                        title: "Ошибка!",
                        message: "Не удалось загрузить данные с сервера =(",
                        preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true)
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MainPageViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        adverts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "AdvertCell", for: indexPath
            ) as? AdvertCell
        else { return UICollectionViewCell() }

        let advert = adverts[indexPath.item]

        if let cachedImage = ImageCacheManager.shared.image(forKey: advert.imageUrl) {
            cell.advertImageView.image = cachedImage
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.removeFromSuperview()
        } else {
            cell.advertImageView.image = nil
            cell.activityIndicator.startAnimating()

            NetworkingService.shared.loadImage(from: advert.imageUrl) { image in
                DispatchQueue.main.async {
                    if let currentIndexPath = collectionView.indexPath(for: cell), currentIndexPath == indexPath {
                        if let image {
                            cell.advertImageView.image = image

                            ImageCacheManager.shared.setImage(image, forKey: advert.imageUrl)
                        }

                        cell.activityIndicator.stopAnimating()
                        cell.activityIndicator.removeFromSuperview()
                    }
                }
            }
        }

        cell.titleLabel.text = advert.title
        cell.priceLabel.text = advert.price
        cell.locationLabel.text = advert.location
        cell.createdDateLabel.text = advert.createdDate

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 20, right: 16)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        16
    }
}
