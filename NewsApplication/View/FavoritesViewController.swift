//
//  FavouritesViewController.swift
//  NewsApplication
//
//  Created by Aisha Karzhauova on 24.11.2024.
//

import UIKit
import SafariServices

class FavoritesViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel = NewsViewModel() // Shared ViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // articles are fetched before loading likes
        if viewModel.filteredArticles.isEmpty {
            viewModel.fetchNews() // fetch articles if not already loaded
        } else {
            viewModel.loadLikes() // load likes only if articles are already available
        }

        tableView.reloadData()
    }


    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Favorites"

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func loadFavorites() {
        viewModel.loadLikes()
        print("Favorite Articles in ViewController: \(viewModel.favoriteArticles.map { $0.title })") // Debugging
        tableView.reloadData()
    }
}


extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteArticles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let article = viewModel.favoriteArticles[indexPath.row]
        cell.configure(with: article, isLiked: true)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = viewModel.favoriteArticles[indexPath.row]
        guard let url = URL(string: article.url) else { return }

        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true)
    }
}
