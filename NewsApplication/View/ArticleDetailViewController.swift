//
//  ArticleDetailViewController.swift
//  NewsApplication
//
//  Created by Aisha Karzhauova on 23.11.2024.
//

import UIKit
import WebKit

class ArticleDetailViewController: UIViewController {
    private let webView = WKWebView()
    private let article: Article

    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadArticle()
    }

    private func setupUI() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func loadArticle() {
        if let url = URL(string: article.url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
