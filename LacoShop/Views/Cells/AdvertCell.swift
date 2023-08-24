//
//  ProductCell.swift
//  LacoShop
//
//  Created by Данил Терлецкий on 24.08.2023.
//

import UIKit
import SnapKit

class AdvertCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupUI()
    }

    var advertImage: UIImage? {
        didSet {
            advertImageView.image = advertImage
        }
    }

    lazy var advertImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var createdDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        return activityIndicator
    }()

    private func setupUI() {
        addSubviews(for: contentView,
            subviews: advertImageView, titleLabel, priceLabel, locationLabel, createdDateLabel, activityIndicator)

        addSubviews(for: advertImageView, subviews: activityIndicator)

        advertImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(advertImageView.snp.width).offset(-8)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(advertImageView)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(advertImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
        }

        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
        }

        createdDateLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(4)
            make.leading.bottom.equalToSuperview()
        }
    }
}
