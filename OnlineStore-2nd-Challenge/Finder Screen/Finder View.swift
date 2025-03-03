//
//  Finder View.swift
//  OnlineStore-2nd-Challenge
//
//  Created by Александр Семёнов on 02.03.2025.
//

import UIKit

final class FinderView: UIView {
    
    lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = .white
        backView.contentMode = .scaleAspectFill
        backView.translatesAutoresizingMaskIntoConstraints = false
        return backView
    }()
    
    private lazy var shopLabel: UILabel = {
        let shopLabel = UILabel()
        shopLabel.text = "Shop"
        shopLabel.textColor = .black
//        shopLabel.font = UIFont(name: "Raleway", size: 28)
        shopLabel.font = .boldSystemFont(ofSize: 28)
        shopLabel.translatesAutoresizingMaskIntoConstraints = false
        return shopLabel
    }()
    
    private lazy var searchField: UITextField = {
        let searchField = UITextField()
        searchField.borderStyle = .roundedRect
        searchField.layer.cornerRadius = 18
        searchField.layer.masksToBounds = true
        searchField.layer.borderWidth = 1.0
        searchField.layer.borderColor = UIColor.systemGray5.cgColor
        searchField.translatesAutoresizingMaskIntoConstraints = false
        return searchField
    }()
    
    private lazy var searchHistoryLabel: UILabel = {
        let searchHistoryLabel = UILabel()
        searchHistoryLabel.text = "Search history"
        searchHistoryLabel.textColor = .black
//        shopLabel.font = UIFont(name: "Raleway", size: 28)
        searchHistoryLabel.font = .systemFont(ofSize: 18)
        searchHistoryLabel.translatesAutoresizingMaskIntoConstraints = false
        return searchHistoryLabel
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .systemRed
        deleteButton.backgroundColor = .systemGray6
        deleteButton.layer.cornerRadius = 17.5
//        deleteButton.addTarget(self, action: #selector(), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        return deleteButton
    }()
    
    
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(backView)
        backView.addSubview(shopLabel)
        backView.addSubview(searchField)
        backView.addSubview(searchHistoryLabel)
        backView.addSubview(deleteButton)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: topAnchor),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            shopLabel.heightAnchor.constraint(equalToConstant: 36),
            shopLabel.widthAnchor.constraint(equalToConstant: 68),
            shopLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            shopLabel.topAnchor.constraint(equalTo: backView.safeAreaLayoutGuide.topAnchor, constant: 12),
            
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.widthAnchor.constraint(equalToConstant: 234),
            searchField.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            searchField.topAnchor.constraint(equalTo: backView.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            searchHistoryLabel.heightAnchor.constraint(equalToConstant: 23),
            searchHistoryLabel.widthAnchor.constraint(equalToConstant: 118),
            searchHistoryLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            searchHistoryLabel.topAnchor.constraint(equalTo: shopLabel.bottomAnchor, constant: 18),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 35),
            deleteButton.widthAnchor.constraint(equalToConstant: 35),
            deleteButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            deleteButton.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 11),
        ])
    }
}
