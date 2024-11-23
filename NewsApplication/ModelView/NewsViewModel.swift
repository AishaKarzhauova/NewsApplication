//
//  NewsViewModel.swift
//  NewsApplication
//
//  Created by Aisha Karzhauova on 23.11.2024.
//
import Foundation

class NewsViewModel {
    private var articles: [Article] = []
    var filteredArticles: [Article] = []

    var reloadData: (() -> Void)?

    func fetchNews() {
        NetworkManager.shared.fetchArticles { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.filteredArticles = articles
                self?.reloadData?()
            case .failure(let error):
                print("Error fetching news: \(error)")
            }
        }
    }

    func likeArticle(at index: Int) {
        filteredArticles[index].isLiked.toggle()
        saveLikes()
    }

    func saveLikes() {
        // Save liked articles using UserDefaults
        let likedTitles = filteredArticles.filter { $0.isLiked }.map { $0.title }
        UserDefaults.standard.set(likedTitles, forKey: "LikedArticles")
    }

    func loadLikes() {
        // Load liked articles from UserDefaults
        let likedTitles = UserDefaults.standard.array(forKey: "LikedArticles") as? [String] ?? []
        filteredArticles = articles.map { article in
            var mutableArticle = article
            mutableArticle.isLiked = likedTitles.contains(article.title)
            return mutableArticle
        }
    }
}

