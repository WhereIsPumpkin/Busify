//
//  PostTableViewCell.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    let postStackView = PostStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.layoutMargins = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        setupPostStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPostStackView() {
        postStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(postStackView)
        let margins = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            postStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            postStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            postStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            postStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
    }

}
