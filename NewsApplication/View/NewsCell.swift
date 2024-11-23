//
//  NewsCell.swift
//  NewsApplication
//
//  Created by Aisha Karzhauova on 23.11.2024.
//

import UIKit
import SnapKit

class NewsCell: UITableViewCell {
    // Title Label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()
    
    // Description Label
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.textColor = .gray
        return label
    }()
    
    // Article Image View
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(articleImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)

        // Layout Constraints
        articleImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.width.height.equalTo(80)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(articleImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(articleImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }

    func configure(with article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        if let urlToImage = article.urlToImage, let url = URL(string: urlToImage) {
            // Load image asynchronously
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.articleImageView.image = image
                    }
                }
            }
        } else {
            articleImageView.image = UIImage(systemName: "photo") // Placeholder image
        }
    }
}

