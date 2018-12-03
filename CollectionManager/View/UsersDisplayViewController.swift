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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddItems))
        view.backgroundColor = .white
        self.view.addSubview(collectionView)
    }
    
    @objc private func handleAddItems() {
        output.handleAddModelsTap()
    }
}

extension UsersDisplayViewController: UsersDisplayViewInput {
    func displayEditingSheet(withOptions options: [EditingOptionTestingType]) {
        let actionSheet = UIAlertController(title: "Editing Options", message: nil, preferredStyle: .actionSheet)
        
        options.map { editingOption in
            UIAlertAction(title: editingOption.actionName, style: .default, handler: { _ in
                editingOption.action?(1)
        }) }.forEach { (action) in
            actionSheet.addAction(action)
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func registerUserLinker(_ linker: CollectionViewModelLinker<User, UserCollectionViewCell>) {
        linker.onEvent.itemSize = { (context) in
            return CGSize.init(width: context.collectionView!.frame.width, height: 20)
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
            return CGSize(width: context.collectionView!.frame.width, height: 40)
        }
        header.onEvent.dequeue = { context in
            context.view!.titleLabel.text = "Users"
            context.view!.backgroundColor = .red
        }
        
        return header
    }
    
    func reloadData(after: (() -> Void)?) {
        collectionManager.reloadData(after: after, onEnd: nil)
    }
}
