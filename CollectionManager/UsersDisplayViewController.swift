//
//  ViewController.swift
//  CollectionManager
//
//  Created by David on 07/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class UsersDisplayViewController: UIViewController {
    
    var output: UsersDisplayViewOutput!

    private lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        let safeInsets = self.view.safeAreaInsets
        var cvFrame = self.view.frame
        cvFrame.inset(by: safeInsets)
        let cv = UICollectionView(frame: cvFrame, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    private lazy var collectionManager: CollectionViewManager = { [unowned self] in
        let cm = CollectionViewManager(self.collectionView)
        return cm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        output.viewIsReady()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .white
        self.view.addSubview(collectionView)
    }
}

extension UsersDisplayViewController: UsersDisplayViewInput {
    func registerUserLinker(_ linker: CollectionViewModelLinker<User, UserCollectionViewCell>) {
        linker.onEvent.itemSize = { (context) in
            return CGSize.init(width: context.collectionView!.frame.width, height: 150)
        }
        collectionManager.register(linker: linker)
    }
    
    func appendSection(_ section: CollectionSection) {
        section.header = userSectionHeader()
        collectionManager.append(section: section)
    }
    
    private func userSectionHeader() -> CollectionSectionProtocol {
        let header = CollectionSectionView<UserCollectionSectionHeader>()
        header.onEvent.referenceSize = { context in
            return CGSize(width: context.collectionView!.frame.width, height: 80)
        }
        header.onEvent.dequeue = { context in
            context.view!.titleLabel.text = "Users"
            context.view!.backgroundColor = .red
        }
        return header
    }
    
    func reloadData() {
        collectionManager.reloadData()
    }
}
