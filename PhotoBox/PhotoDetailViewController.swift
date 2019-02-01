//
//  PhotoDetailViewController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/23/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet var optionsButton: [UIButton]!
    
    var photos: [UIImage] = [] {
        didSet {
            
        }
    }
    
override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func handleSelection(_ sender: UIButton) {
        optionsButton.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
            
        }
    
    
    @IBAction func savePhotoButtonTapped(_ sender: Any) {
    }
    
    @IBAction func deletePhotoButtonTapped(_ sender: Any) {
    }
    
    @IBAction func reportButtonButtonTapped(_ sender: Any) {
    }
    
    @IBAction func blockUserButtonTapped(_ sender: Any) {
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
