//
//  NewsViewController.swift
//  NewsApplication
//
//  Created by Aisha Karzhauova on 23.11.2024.
//

import UIKit
import SnapKit
import SafariServices

class NewsViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel = NewsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchNews()
    }

    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Top News"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func bindViewModel() {
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredArticles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let article = viewModel.filteredArticles[indexPath.row]
        cell.configure(with: article, isLiked: article.isLiked)
        
        cell.likeAction = { [weak self] in
            self?.viewModel.likeArticle(at: indexPath.row)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = viewModel.filteredArticles[indexPath.row]
        guard let url = URL(string: article.url) else { return }

        // Open the article in Safari Services
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true)
    }
}
