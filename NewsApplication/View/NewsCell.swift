//
//  NewsCell.swift
//  NewsApplication
//
//  Created by Aisha Karzhauova on 23.11.2024.
//

import UIKit
import SnapKit

class NewsCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.textColor = .gray
        return label
    }()

    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()

    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal) // Unliked state
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected) // Liked state
        button.tintColor = .systemRed
        return button
    }()

    var likeAction: (() -> Void)? // closure to handle like action

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(articleImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likeButton)

        articleImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.width.height.equalTo(80)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(articleImageView.snp.right).offset(10)
            make.right.equalTo(likeButton.snp.left).offset(-10)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(articleImageView.snp.right).offset(10)
            make.right.equalTo(likeButton.snp.left).offset(-10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }

        likeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(40)
        }
    }

    private func setupActions() {
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
    }

    @objc private func didTapLikeButton() {
        likeButton.isSelected.toggle() // toggle the like state
        animateLikeButton()
        likeAction?() // trigger the like action closure
    }

    private func animateLikeButton() {
        UIView.animate(withDuration: 0.1,
                       animations: {
                           self.likeButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                       }, completion: { _ in
                           UIView.animate(withDuration: 0.1) {
                               self.likeButton.transform = CGAffineTransform.identity
                           }
                       })
    }

    func configure(with article: Article, isLiked: Bool) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        likeButton.isSelected = isLiked // set the like state

        if let urlToImage = article.urlToImage, let url = URL(string: urlToImage) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.articleImageView.image = image
                    }
                }
            }
        } else {
            articleImageView.image = UIImage(systemName: "photo") 
        }
    }
}
