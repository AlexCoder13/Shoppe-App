//
//  ProductCell.swift
//  OnlineStore-2nd-Challenge
//
//  Created by Александр Семёнов on 12.03.2025.
//

import UIKit

// В ProductCell обновим констрейнты и настройки UI элементов:
final class ProductCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium) // Уменьшаем размер шрифта
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to cart", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
        private var product: MyProduct?
        
        // MARK: - Init
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    // Обновляем констрейнты в setupUI:
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.1
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(addToCartButton)
        
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // Изображение занимает 45% высоты ячейки
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.45),
            
            // Название товара
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            // Описание
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            // Цена
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.bottomAnchor.constraint(equalTo: addToCartButton.topAnchor, constant: -8),
            
            // Кнопка Add to cart
            addToCartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            addToCartButton.heightAnchor.constraint(equalToConstant: 36) // Уменьшаем высоту кнопки
        ])
    }
    
    // В методе configure добавим обрезку длинного описания
    func configure(with product: MyProduct) {
        self.product = product
        titleLabel.text = product.title
        
        // Обрезаем описание до двух строк
        let maxLength = 100 // Примерная длина для двух строк
        if product.description.count > maxLength {
            let truncatedDescription = product.description.prefix(maxLength) + "..."
            descriptionLabel.text = String(truncatedDescription)
        } else {
            descriptionLabel.text = product.description
        }
        
        priceLabel.text = String(format: "$%.2f", product.price)
        
        if let url = URL(string: product.image) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }.resume()
        }
    }
    
    @objc private func addToCartTapped() {
        guard let product = product else { return }
        print("Товар добавлен в корзину: \(product.title)")
    }
}
    
   
