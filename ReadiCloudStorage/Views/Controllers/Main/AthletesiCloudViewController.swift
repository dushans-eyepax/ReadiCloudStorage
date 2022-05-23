//
//  AthletesiCloudViewController.swift
//  ReadiCloudStorage
//
//  Created by Dushan Saputhanthri on 5/20/22.
//

import UIKit
import CloudKit
import MobileCoreServices
import AVFoundation

class AthletesiCloudViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate var itemsPerRow: CGFloat = 2
    
    let cellReuseIdentifier = "PersonCVCell"
    
    let cloudDatabase = CKContainer.default().publicCloudDatabase

    var files: [CKRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        loadData()
    }
    
    func setupView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView?.register(UINib(nibName: "PersonCVCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func loadData() {
        let query = CKQuery(recordType: "Note", predicate: NSPredicate(value: true))
        cloudDatabase.perform(query, inZoneWith: nil) { (records, error) in

            guard let records = records else { return }
            print(records)
            let sortedRecords = records.sorted(by: {$0.creationDate! > $1.creationDate!})

            self.files = sortedRecords

            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
    }

    func moveToAttachments(with record: CKRecord) {
        if let attachmentsVc = storyboard?.instantiateViewController(withIdentifier: "\(AttachmentsiCloudViewController.self)") as? AttachmentsiCloudViewController {
            attachmentsVc.record = record
            self.navigationController?.pushViewController(attachmentsVc, animated: true)
        }
    }
    
}

extension AthletesiCloudViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: PersonCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? PersonCVCell {
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = files[indexPath.item]
        moveToAttachments(with: item)
    }
}

extension AthletesiCloudViewController: UICollectionViewDelegateFlowLayout {
    
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

