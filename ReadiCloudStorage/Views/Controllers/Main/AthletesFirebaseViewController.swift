//
//  AthletesFirebaseViewController.swift
//  ReadiCloudStorage
//
//  Created by Dushan Saputhanthri on 5/20/22.
//

import UIKit
import AVFoundation
import MobileCoreServices
import FirebaseStorage

class AthletesFirebaseViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate var itemsPerRow: CGFloat = 2
    
    var mediaSource: UIImagePickerController.SourceType = .photoLibrary
    
    let cellReuseIdentifier = "PersonCVCell"

    var files: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: AthletesFirebaseViewController -> viewDidLoad")
        
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
        let actionCamera = AlertAction(title: "Camera")
        let actionLibarary = AlertAction(title: "Media Library")
        AlertProvider(vc: self).showActionSheetWithActions(title: "Select Type", message: "Please pick media", withCancel: true, actions: [actionCamera, actionLibarary], sourceView: self.view, completion: { action in
            
            if action.title == "Camera" {
                self.mediaSource = .camera
                self.showMediaPicker(sourceType: .camera, mediaTypes: .imageAndVideo)
            }
            else if action.title == "Media Library" {
                self.mediaSource = .photoLibrary
                self.showMediaPicker(sourceType: .photoLibrary, mediaTypes: .imageAndVideo)
            }
        })
    }
    
    func showMediaPicker(sourceType: UIImagePickerController.SourceType, mediaTypes: MediaType) {
        let imageMediaType = kUTTypeImage as String
        let movieMediaType = kUTTypeMovie as String
        
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.mediaTypes = [imageMediaType, movieMediaType]
        pickerController.delegate = self
        
        present(pickerController, animated: true, completion: nil)
    }
    
    func moveToAttachments(with record: String) {
        if let attachmentsVc = storyboard?.instantiateViewController(withIdentifier: "\(AttachmentsFirebaseViewController.self)") as? AttachmentsFirebaseViewController {
//            attachmentsVc.record = record
            self.navigationController?.pushViewController(attachmentsVc, animated: true)
        }
    }
    
}

extension AthletesFirebaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
        // Check for the media type
        if mediaType.isEqual(to: kUTTypeImage as NSString as String),
           let image = info[.originalImage] as? UIImage {
            let orientationFixedImage = fixedOrientation(image: image) ?? UIImage()
            if let imageURL = mediaSource == .photoLibrary ? info[.imageURL] as? URL : self.getURLForPickedTemporaryImage(image: orientationFixedImage) {
                uploadFile(fileUrl: imageURL)
            }
        }
        else if mediaType.isEqual(to: kUTTypeMovie as NSString as String),
                let mediaURL = info[.mediaURL] as? URL {
            uploadFile(fileUrl: mediaURL)
        }
        else {
            print("It's not a targetted media type")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AthletesFirebaseViewController {
    
    func uploadFile(fileUrl: URL) {
        do {
            // Create file name
            let fileExtension = fileUrl.pathExtension
            let fileName = "demoImageFileName1.\(fileExtension)"
            let metaData = StorageMetadata()
            
            let storageReference = Storage.storage().reference().child(fileName)
            let currentUploadTask = storageReference.putFile(from: fileUrl, metadata: metaData) { (storageMetaData, error) in
                if let error = error {
                    print("Upload error: \(error.localizedDescription)")
                    return
                }
                
                // Show UIAlertController here
                AlertProvider(vc: self).showAlert(title: "Success", message: "Image file: \(fileName) is uploaded! View it at Firebase console!", action: AlertAction(title: "OK"))
                
                storageReference.downloadURL { (url, error) in
                    if let error = error  {
                        print("Error on getting download url: \(error.localizedDescription)")
                        return
                    }
                    print("Download url of \(fileName) is \(url!.absoluteString)")
                }
            }
        } catch {
            print("Error on extracting data from url: \(error.localizedDescription)")
        }
    }
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

extension AthletesFirebaseViewController {
    
    /// Fix image orientaton to protrait up
    func fixedOrientation(image: UIImage) -> UIImage? {
        guard image.imageOrientation != UIImage.Orientation.up else {
            // This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }

        guard let cgImage = image.cgImage else {
            // CGImage is not available
            return nil
        }

        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil // Not able to create CGContext
        }

        var transform: CGAffineTransform = CGAffineTransform.identity

        switch image.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: image.size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
        case .up, .upMirrored:
            break
        @unknown default:
            fatalError("Missing...")
            break
        }

        // Flip image one more time if needed to, this is to prevent flipped image
        switch image.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: image.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            fatalError("Missing...")
            break
        }

        ctx.concatenate(transform)

        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            break
        }

        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
    
    func getURLForPickedTemporaryImage(image: UIImage) -> URL? {
        let (status, url) = saveTemporaryImageToDocumentDirectory(image: image)
        
        switch status {
        case true:
            return url
        default:
            return nil
        }
    }
    
    // Save image to document directory
    func saveTemporaryImageToDocumentDirectory(image: UIImage) -> (Bool, URL?) {
        let pngData = image.pngData()
        //let jpgData = self.jpegData(compressionQuality: quality.rawValue)
        
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return (false, nil)
        }
        
        if !FileManager.default.fileExists(atPath: directory.path!) {
            try? FileManager.default.createDirectory(atPath: directory.path!, withIntermediateDirectories: true, attributes: nil)
        }
        
        do {
            let randomString = NSUUID().uuidString
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent(randomString + ".png")
            
            if let _data = pngData {
                do {
                    try _data.write(to: fileURL)
                    return (true, fileURL)
                    
                } catch {
                    print("Error saving image")
                    return (false, nil)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return (false, nil)
    }
}

enum MediaType {
    case image
    case video
    case imageAndVideo
}

enum MediaPickingType {
    case camera
    case photoLibrary
}

