//
//  NewsViewModel.swift
//  NewsApplication
//
//  Created by Aisha Karzhauova on 23.11.2024.
//
import Foundation

class NewsViewModel {
    private var articles: [Article] = []
    private(set) var filteredArticles: [Article] = []
    private(set) var favoriteArticles: [Article] = []
    var reloadData: (() -> Void)?

    func fetchNews() {
        NetworkManager.shared.fetchArticles { [weak self] result in
            switch result {
            case .success(let articles):
                // filter out removed articles
                let validArticles = articles.filter { article in
                    let title = article.title
                    return !title.lowercased().contains("removed") &&
                           article.urlToImage != nil &&
                           !(article.urlToImage?.isEmpty ?? true)
                }

                self?.articles = validArticles
                self?.filteredArticles = validArticles
                self?.loadLikes() // load likes after articles are fetched
                self?.reloadData?() // reload data
            case .failure(let error):
                print("Error fetching news: \(error)")
            }
        }
    }



    func likeArticle(at index: Int) {
        filteredArticles[index].isLiked.toggle()

        let article = filteredArticles[index]
        if article.isLiked {
            if !favoriteArticles.contains(where: { $0.title == article.title }) {
                favoriteArticles.append(article)
            }
        } else {
            favoriteArticles.removeAll { $0.title == article.title }
        }

        saveLikes() // Persist the updated liked articles
        print("Updated Favorites: \(favoriteArticles.map { $0.title })") // Debugging
    }

    private func saveLikes() {
        let likedTitles = filteredArticles.filter { $0.isLiked }.map { $0.title }
        UserDefaults.standard.set(likedTitles, forKey: "LikedArticles")
        print("Saved Liked Articles to UserDefaults: \(likedTitles)") // Debugging
    }

    func loadLikes() {
        let likedTitles = UserDefaults.standard.array(forKey: "LikedArticles") as? [String] ?? []
        filteredArticles = articles.map { article in
            var mutableArticle = article
            mutableArticle.isLiked = likedTitles.contains(article.title)
            return mutableArticle
        }
        favoriteArticles = filteredArticles.filter { $0.isLiked }
        print("Loaded Liked Articles from UserDefaults: \(favoriteArticles.map { $0.title })") // Debugging
    }

}
