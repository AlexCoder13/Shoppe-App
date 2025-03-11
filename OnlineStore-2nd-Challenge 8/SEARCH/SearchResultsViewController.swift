//
//  SearchResultsViewController.swift
//  OnlineStore-2nd-Challenge
//
//  Created by Александр Семёнов on 12.03.2025.
//

import UIKit

final class SearchResultsViewController: UIViewController {
    
    // MARK: - Properties
    private var products: [MyProduct] = []
    private let searchQuery: String
    private var cartProducts: [MyProduct] = []
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.text = "Shop"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchQueryView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchQueryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "Товары не найдены :-("
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    init(searchQuery: String) {
        self.searchQuery = searchQuery
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupCollectionView()
        fetchProducts()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .white
        searchQueryLabel.text = searchQuery
        
        view.addSubview(titleLabel)
        view.addSubview(searchQueryView)
        searchQueryView.addSubview(searchQueryLabel)
        searchQueryView.addSubview(closeButton)
        view.addSubview(collectionView)
        view.addSubview(noResultsLabel)
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            searchQueryView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            searchQueryView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12),
            searchQueryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchQueryView.heightAnchor.constraint(equalToConstant: 36),
            
            searchQueryLabel.leadingAnchor.constraint(equalTo: searchQueryView.leadingAnchor, constant: 16),
            searchQueryLabel.centerYAnchor.constraint(equalTo: searchQueryView.centerYAnchor),
            
            closeButton.trailingAnchor.constraint(equalTo: searchQueryView.trailingAnchor, constant: -8),
            closeButton.centerYAnchor.constraint(equalTo: searchQueryView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            
            collectionView.topAnchor.constraint(equalTo: searchQueryView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data Fetching
    private func fetchProducts() {
        guard let url = URL(string: "https://fakestoreapi.com/products") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let products = try? JSONDecoder().decode([MyProduct].self, from: data) else { return }
            
            DispatchQueue.main.async {
                // Фильтруем продукты по поисковому запросу
                self.products = products.filter { product in
                    let searchText = self.searchQuery.lowercased()
                    return product.title.lowercased().contains(searchText) ||
                           product.description.lowercased().contains(searchText)
                }
                
                self.noResultsLabel.isHidden = !self.products.isEmpty
                self.collectionView.isHidden = self.products.isEmpty
                self.collectionView.reloadData()
            }
        }.resume()
    }
}

extension SearchResultsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: products[indexPath.item])
        return cell
    }
}

extension SearchResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 16) / 2 // Ширина с учетом отступа между ячейками
        return CGSize(width: width, height: width * 2) // Увеличиваем высоту (множитель 2 вместо 1.8)
    }
}
