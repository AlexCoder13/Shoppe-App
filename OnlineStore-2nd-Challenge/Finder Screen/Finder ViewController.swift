//
//  Finder VC.swift
//  OnlineStore-2nd-Challenge
//
//  Created by Александр Семёнов on 02.03.2025.
//

import UIKit

final class FinderViewController: UIViewController {
    
    private let finderView = FinderView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = finderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
