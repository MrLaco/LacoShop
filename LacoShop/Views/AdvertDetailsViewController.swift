//
//  AdvertDetailsViewController.swift
//  LacoShop
//
//  Created by Данил Терлецкий on 24.08.2023.
//

import UIKit
import SnapKit

class AdvertDetailsViewController: UIViewController {

    var advertDetails: AdvertDetails?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var advertImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
        return textView
    }()

    private lazy var contactButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Контакты продавца", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(
            self,
            action: #selector(showContactInfo),
            for: .touchUpInside)
        return button
    }()

    // MARK: - Actions

    @objc private func showContactInfo() {
        if let advertDetails {
            let contactInfo = """
                                Email: \(advertDetails.email)
                                Телефон: \(advertDetails.phoneNumber)
                                Адрес: \(advertDetails.address)
                              """
            let alertVC = UIAlertController(
                title: "Контакты продавца",
                message: contactInfo,
                preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
        setupData()
    }

    // MARK: - UI

    private func setupUI() {
        title = "Карточка товара"

        view.backgroundColor = .white
    }

    private func setupConstraints() {
        addSubviews(for: view, subviews: advertImageView, titleLabel, priceLabel, descriptionTextView, contactButton)

        advertImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(350)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(advertImageView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(priceLabel)
            make.height.equalTo(20)
        }

        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalTo(titleLabel).offset(-4)
            make.trailing.equalTo(titleLabel)
        }

        contactButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(44)
        }
    }

    // MARK: - Data

    private func setupData() {
        if let advertDetails {
            titleLabel.text = advertDetails.title
            priceLabel.text = advertDetails.price
            descriptionTextView.text = advertDetails.description

            let imageUrl = advertDetails.imageUrl

            if let cachedImage = ImageCacheManager.shared.image(forKey: imageUrl) {
                self.advertImageView.image = cachedImage
            } else {
                NetworkingService.shared.loadImage(from: imageUrl) { image in
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        if let image {
                            self.advertImageView.image = image
                        } else {
                            print("Не удалось загрузить изображение")
                        }
                    }
                }
            }
        }
    }
}
