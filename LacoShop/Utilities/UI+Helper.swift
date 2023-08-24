//
//  UI+Helper.swift
//  LacoShop
//
//  Created by Данил Терлецкий on 24.08.2023.
//

import UIKit

public func addSubviews(for view: UIView, subviews: UIView...) {
    subviews.forEach { view.addSubview($0) }
}

public func addSubviews(for view: UIStackView, subviews: UIView...) {
    subviews.forEach { view.addArrangedSubview($0) }
}
