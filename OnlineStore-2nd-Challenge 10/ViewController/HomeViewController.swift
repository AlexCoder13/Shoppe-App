//
//  HomeViewController.swift
//  OnlineStore-2nd-Challenge
//
//  Created by Евгений on 04.03.2025.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    private let productURLString = "https://fakestoreapi.com/products"
    let mainView: HomeView = .init()
    private var items: [Product] = []
    private var categories: [String] = []
    private var sortedPopularItems: [Product] = []
    private var favoriteItems: [Product] = []
    private var makeImageForCategory: [String: [String]] = [:]
    private let finderBar = SearchView()
    private let labelShop = UILabel.makeLabel(text: "Shop", font: .systemFont(ofSize: 20, weight: .black), textColor: .black)
    private let labelDelivery = UILabel.makeLabel(text: "Delivery address", font: .systemFont(ofSize: 14, weight: .light), textColor: .systemGray)
    private let labelAdress = UILabel.makeLabel(text: "Salatiga City, Central Java", font: .systemFont(ofSize: 16, weight: .regular), textColor: .black)
    
    lazy var basketButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cart"), for: .normal)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let favoriteManager = FavoriteManager.shared
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        mainView.backgroundColor = .white
        setupCollectionViews()
        makeProduct()
        setupNavigation()
        setupView()
        setupLayout()
        chekCart()
    }
    
    private func setupView() {
        view.addSubview(labelShop)
        view.addSubview(finderBar.view)
        view.addSubview(labelDelivery)
        view.addSubview(labelAdress)
        view.addSubview(basketButton)
        basketButton.addTarget(self, action: #selector(basketButtonTapped), for: .touchUpInside)
    }
    
    private func setupCollectionViews() {
        mainView.categoryCollectionView.delegate = self
        mainView.categoryCollectionView.dataSource = self
        mainView.popularCollectionView.delegate = self
        mainView.popularCollectionView.dataSource = self
    }
    private func setupNavigation() {
        mainView.categoryButton.addTarget(self, action: #selector(categoriesButtonTapped), for: .touchUpInside)
        mainView.popularButton.addTarget(self, action: #selector(searchAndPopularButton), for: .touchUpInside)
        mainView.searchButton.addTarget(self, action: #selector(searchAndPopularButton), for: .touchUpInside)
    }
    
    private func chekCart() {
        guard let cart = UserDefaultsManager.shared.getProducts(UserDefaultsStorageKeys.cart) else {
            mainView.notificationLabel.isHidden = true
            return
        }
        if cart.isEmpty {
            mainView.notificationLabel.isHidden = true
        } else {
            mainView.notificationLabel.isHidden = false
            mainView.notificationLabel.backgroundColor = .systemRed
            mainView.notificationLabel.text = "\(cart.count)"
            mainView.notificationLabel.textColor = .white
        }
    }
    
    private func setupLayout() {
        labelShop.translatesAutoresizingMaskIntoConstraints = false
        finderBar.view.translatesAutoresizingMaskIntoConstraints = false
        labelDelivery.translatesAutoresizingMaskIntoConstraints = false
        labelAdress.translatesAutoresizingMaskIntoConstraints = false
        basketButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            labelDelivery.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            labelDelivery.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            labelAdress.topAnchor.constraint(equalTo: labelDelivery.bottomAnchor, constant: 4),
            labelAdress.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            basketButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            basketButton.centerYAnchor.constraint(equalTo: labelAdress.centerYAnchor),
            basketButton.heightAnchor.constraint(equalToConstant: 32),
            basketButton.widthAnchor.constraint(equalToConstant: 32),
            
            labelShop.centerYAnchor.constraint(equalTo: finderBar.view.centerYAnchor),
            labelShop.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            finderBar.view.topAnchor.constraint(equalTo: basketButton.bottomAnchor, constant: 12),
            finderBar.view.leadingAnchor.constraint(equalTo: labelShop.trailingAnchor, constant: 8),
            finderBar.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            finderBar.view.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    //MARK: FETCH_PRODUCTS
    private func makeProduct() {
        NetworkService.shared.fetchProducts(from: productURLString) { result in
            switch result {
            case .success(let products):
                self.items = products
                let newCategories = products.map { $0.category }
                UserDefaultsManager.shared.saveProducts(products)
                self.categories = Array(Set(newCategories)).sorted()
                UserDefaults.standard.set(self.categories, forKey: UserDefaultsStorageKeys.category.label)
                
                var imageLinksByCategory: [String: [String]] = [:]
                for product in self.items {
                    if var links = imageLinksByCategory[product.category] {
                        links.append(product.image)
                        imageLinksByCategory[product.category] = links
                    } else {
                        imageLinksByCategory[product.category] = [product.image]
                    }
                }
                self.makeImageForCategory = imageLinksByCategory
                
                self.sortedPopularItems = self.items.sorted { $0.rating.rate > $1.rating.rate }
                print("отсортированный массив\(self.sortedPopularItems)")
                
            case .failure(let error):
                print("Ошибка: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.mainView.categoryCollectionView.reloadData()
                self.mainView.popularCollectionView.reloadData()
            }
        }
    }
    
    //MARK: FetchImage
    private func loadImages(from urls: [String], into imageViews: [UIImageView]) {
        for (index, url) in urls.enumerated() {
            guard index < imageViews.count else { break }
            NetworkService.shared.fetchImage(from: url) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        imageViews[index].image = image
                    case .failure(let error):
                        print("Ошибка загрузки изображения: \(error.localizedDescription)")
                        imageViews[index].image = UIImage(systemName: "xmark.circle")
                    }
                }
            }
        }
    }
    //MARK: Navigation
    @objc func basketButtonTapped() {
        guard let tapBar = self.tabBarController else {
            print("Ошбка в получении тап бара")
            return
        }
        tapBar.selectedIndex = 3
    }
    @objc func categoriesButtonTapped() {
        guard let tapBar = self.tabBarController else { return }
        tapBar.selectedIndex = 2
    }
    @objc func searchAndPopularButton() {
        let vc = FinderViewController() //заменить на экран поиска
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case mainView.categoryCollectionView:
            print("выбран товар ")
        case mainView.popularCollectionView:
            print("выбран товар ")
            let product = sortedPopularItems[indexPath.row]
            
            let VC = ProductViewController(product: product)
            navigationController?.pushViewController(VC, animated: true)
        default:
            print("")
        }
        
    }
    
}

//MARK: UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case mainView.categoryCollectionView:
            return categories.count
        case mainView.popularCollectionView:
            return sortedPopularItems.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case mainView.categoryCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCategoryCell.reuseIdentifier, for: indexPath) as? HomeCategoryCell else {
                return UICollectionViewCell()
            }
            let category = categories[indexPath.row]
            cell.labelOfCategory.text = category
            cell.quantityOfProducts.text = "\(items.filter { $0.category == category }.count)"
            if let imageLinks = makeImageForCategory[category], imageLinks.count >= 4 {
                       loadImages(from: Array(imageLinks.prefix(4)), into: [cell.firstImageView, cell.secondImageView, cell.thirdImageView, cell.fourthImageView])
            } else {
                [cell.firstImageView, cell.secondImageView, cell.thirdImageView, cell.fourthImageView].forEach {
                    $0.image = UIImage(systemName: "plus")
                }
            }
            return cell
            
        case mainView.popularCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePopularCell.reuseIdentifier, for: indexPath) as? HomePopularCell else {
                return UICollectionViewCell()
            }
            cell.discriptionOfProduct.text = sortedPopularItems[indexPath.row].description
            cell.priceOfProducts.text = "\(sortedPopularItems[indexPath.row].price) ₽"
            let urlOfImage = self.sortedPopularItems[indexPath.row].image
            cell.photoOfProduct.image = nil
            NetworkService.shared.fetchImage(from: urlOfImage) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let makeImage) :
                        cell.photoOfProduct.image = makeImage
                        print("Фотка для ячейки готова")
                    case .failure(let error):
                        print(error)
                        print("Очибка")
                    }
                }
            }
                
            return cell
            
        default:
            fatalError("Unknown collection view")
        }
    }
    
}
//MARK: UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 8
        let itemsPerRow: CGFloat = 2
        let totalSpacing = (itemsPerRow - 1) * spacing
        let itemWidth = (collectionView.bounds.width - totalSpacing) / itemsPerRow
        return CGSize(width: itemWidth, height: 190)
    }
}
