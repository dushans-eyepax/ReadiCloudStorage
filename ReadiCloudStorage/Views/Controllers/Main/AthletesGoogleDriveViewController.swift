//
//  AthletesGoogleDriveViewController.swift
//  ReadiCloudStorage
//
//  Created by Dushan Saputhanthri on 5/20/22.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn

class AthletesGoogleDriveViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate var itemsPerRow: CGFloat = 2
    
    let googleDriveService = GTLRDriveService()
    var googleUser: GIDGoogleUser?
    var uploadFolderId: String?
    
    let cellReuseIdentifier = "PersonCVCell"

    var files: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupGoogleSignIn()
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
    
    private func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDrive, kGTLRAuthScopeDriveFile]
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            GIDSignIn.sharedInstance().signInSilently()
        }
        else{
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    @objc func loadData() {        
        
    }

    @IBAction func onAddButtonPressed(_ sender: UIBarButtonItem) {
        let alertAction = AlertAction(title: "Create")
        AlertProvider(vc: self).showAlertWithTextFieldAndAction(title: "New", message: "Please enter name.", action: alertAction, completion: { action, input in
            
            guard !input.isEmpty else {
                return
            }
            
            self.populateFolderId(name: input)
        })
    }
    
    func moveToAttachments(with record: String) {
        if let attachmentsVc = storyboard?.instantiateViewController(withIdentifier: "\(AthletesGoogleDriveViewController.self)") as? AthletesGoogleDriveViewController {
//            attachmentsVc.record = record
            self.navigationController?.pushViewController(attachmentsVc, animated: true)
        }
    }
    
}

extension AthletesGoogleDriveViewController {
    
    func populateFolderId(name: String) {
        getFolderId(name: name, service: googleDriveService, user: googleUser) { folderId in
            if folderId == nil {
                self.createFolder(name: name, service: self.googleDriveService) {
                    self.uploadFolderId = $0
                }
            } else {
                // Folder already exists
                self.uploadFolderId = folderId
            }
        }
    }
    
    func uploadMyFile(name: String) {
        if let fileURL = Bundle.main.url(forResource: name, withExtension: ".png"),
           let folderId = uploadFolderId {
            uploadFile(name: "\(name).png", folderId: folderId, fileURL: fileURL, mimeType: "image/png", service: googleDriveService)
        }
    }
}

extension AthletesGoogleDriveViewController {
    
    func getFolderId(name: String, service: GTLRDriveService, user: GIDGoogleUser?, completion: @escaping (String?) -> Void) {
        
        guard let user = user else {
            return
        }
        
        let query = GTLRDriveQuery_FilesList.query()

        // Comma-separated list of areas the search applies to. E.g., appDataFolder, photos, drive.
        query.spaces = "drive"
        
        // Comma-separated list of access levels to search in. Some possible values are "user,allTeamDrives" or "user"
        query.corpora = "user"
            
        let withName = "name = '\(name)'" // Case insensitive!
        let foldersOnly = "mimeType = 'application/vnd.google-apps.folder'"
        let ownedByUser = "'\(user.profile?.email ?? "")' in owners"
        query.q = "\(withName) and \(foldersOnly) and \(ownedByUser)"
        
        service.executeQuery(query) { (_, result, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
                                     
            let folderList = result as! GTLRDrive_FileList

            // For brevity, assumes only one folder is returned.
            completion(folderList.files?.first?.identifier)
        }
    }
    
    func createFolder(name: String, service: GTLRDriveService, completion: @escaping (String) -> Void) {
        let folder = GTLRDrive_File()
        folder.mimeType = "application/vnd.google-apps.folder"
        folder.name = name
        
        // Google Drive folders are files with a special MIME-type.
        let query = GTLRDriveQuery_FilesCreate.query(withObject: folder, uploadParameters: nil)
        
        self.googleDriveService.executeQuery(query) { (_, file, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            let folder = file as! GTLRDrive_File
            completion(folder.identifier!)
        }
    }
    
    func uploadFile(name: String, folderId: String, fileURL: URL, mimeType: String, service: GTLRDriveService) {
        let file = GTLRDrive_File()
        file.name = name
        file.parents = [folderId]
        
        // Optionally, GTLRUploadParameters can also be created with a Data object.
        let uploadParameters = GTLRUploadParameters(fileURL: fileURL, mimeType: mimeType)
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
        
        service.uploadProgressBlock = { _, totalBytesUploaded, totalBytesExpectedToUpload in
            // This block is called multiple times during upload and can
            // be used to update a progress indicator visible to the user.
        }
        
        service.executeQuery(query) { (_, result, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            // Successful upload if no error is returned.
        }
    }

}

extension AthletesGoogleDriveViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            self.googleDriveService.authorizer = nil
            self.googleUser = nil
            AlertProvider(vc: self).showAlert(title: "Authentication Error", message: error.localizedDescription, action: AlertAction(title: "OK"))
        } else {
            self.googleDriveService.authorizer = user.authentication.fetcherAuthorizer()
            self.googleUser = user
            print("Authenticated successfully")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Did disconnect to user")
    }
    
}

extension AthletesGoogleDriveViewController: GIDSignInUIDelegate {}

extension AthletesGoogleDriveViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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

extension AthletesGoogleDriveViewController: UICollectionViewDelegateFlowLayout {
    
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

