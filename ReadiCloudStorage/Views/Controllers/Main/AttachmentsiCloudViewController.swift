//
//  AttachmentsViewController.swift
//  ReadiCloudStorage
//
//  Created by Dushan Saputhanthri on 5/20/22.
//

import UIKit
import CloudKit

class AttachmentsiCloudViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate var itemsPerRow: CGFloat = 2
    
    let cellReuseIdentifier = "AttachmentCVCell"
    
    var record: CKRecord?
    var fileUrls: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        loadData()
    }

    func setupView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView?.register(UINib(nibName: "AttachmentCVCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    func loadData() {
        if let record = record {
//            fileUrls.append(selectedDirectory)
        }
        
        collectionView.reloadData()
    }
    
    func openFile(from url: URL) {
        
    }
}

extension AttachmentsiCloudViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: AttachmentCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? AttachmentCVCell {
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = fileUrls[indexPath.item]
        openFile(from: item)
    }
    
}

extension AttachmentsiCloudViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem

        return CGSize(width: widthPerItem, height: heightPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}

