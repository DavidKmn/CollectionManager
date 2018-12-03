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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    fileprivate func setupUI() {
        contentView.addSubview(nameLabel)
        nameLabel.frame = self.contentView.frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
