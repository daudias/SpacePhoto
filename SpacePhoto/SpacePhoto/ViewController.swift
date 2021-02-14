//
//  ViewController.swift
//  SpacePhoto
//
//  Created by Dias on 2/14/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = ""
        copyrightLabel.text = ""
        photoInfoController.fetchPhotoInfo { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photoInfo):
                    self.updateUI(with: photoInfo)
                case .failure(let error):
                    self.updateUI(with: error)
                }
            }
        }
    }

    func updateUI(with photoInfo: PhotoInfo) {
        photoInfoController.fetchPhoto(from: photoInfo.url, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.title = photoInfo.title
                    self.descriptionLabel.text = photoInfo.description
                    self.imageView.image = image
                case .failure(let error):
                    self.updateUI(with: error)
                }
            }
        })
    }
    
    func updateUI(with error: Error) {
        self.title = "Error fetching Photo"
        self.imageView.image = UIImage(systemName: "exclamationmark.octagon")
        self.descriptionLabel.text = error.localizedDescription
        self.copyrightLabel.text = ""
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var copyrightLabel: UILabel!
    
    let photoInfoController = PhotoInfoController()
}

