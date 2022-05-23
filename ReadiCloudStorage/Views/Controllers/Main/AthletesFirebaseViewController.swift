//
//  AthletesFirebaseViewController.swift
//  ReadiCloudStorage
//
//  Created by Dushan Saputhanthri on 5/20/22.
//

import UIKit
import Firebase

class AthletesFirebaseViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate var itemsPerRow: CGFloat = 2
    
    let cellReuseIdentifier = "PersonCVCell"

    var files: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
    }

    @IBAction func onAddButtonPressed(_ sender: UIBarButtonItem) {
        let alertAction = AlertAction(title: "Create")
        AlertProvider(vc: self).showAlertWithTextFieldAndAction(title: "New", message: "Please enter name.", action: alertAction, completion: { action, input in
            
            guard !input.isEmpty else {
                return
            }
            
            //
            //
        })
    }
    
    func moveToAttachments(with record: String) {
        if let attachmentsVc = storyboard?.instantiateViewController(withIdentifier: "\(AttachmentsFirebaseViewController.self)") as? AttachmentsFirebaseViewController {
//            attachmentsVc.record = record
            self.navigationController?.pushViewController(attachmentsVc, animated: true)
        }
    }
    
}

extension AthletesFirebaseViewController {
    
}

extension AthletesFirebaseViewController {

}

extension AthletesFirebaseViewController {
    
}

extension AthletesFirebaseViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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

extension AthletesFirebaseViewController: UICollectionViewDelegateFlowLayout {
    
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

