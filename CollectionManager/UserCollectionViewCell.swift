//
//  UserCollectionViewCell.swift
//  CollectionManager
//
//  Created by David on 16/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .green
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .green
        return label
    }()
    
    let indexLabel: UILabel = {
        let label = UILabel()
        label.textColor = .green
        return label
    }()
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        
        contentStackView.addArrangedSubview(nameLabel)
        contentStackView.addArrangedSubview(emailLabel)
        contentStackView.addArrangedSubview(indexLabel)
        
        contentStackView.frame = self.contentView.frame
        self.contentView.addSubview(contentStackView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
