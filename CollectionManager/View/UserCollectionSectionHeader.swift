//
//  UserCollectionSectionHeader.swift
//  CollectionManager
//
//  Created by David on 16/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class UserCollectionSectionHeader: UICollectionReusableView {
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.frame = self.frame
    }
}
