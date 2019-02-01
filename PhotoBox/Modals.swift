//
//  Modals.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/31/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentPhotoBoxModalVC(message: String) {
        let vc = UIStoryboard(name: "ModalPresentations", bundle: nil).instantiateInitialViewController()
        guard let popUpVC = vc as? ModalPopUpViewController else { return }
        
        popUpVC.message = message
        
        self.definesPresentationContext = true
        popUpVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        popUpVC.modalTransitionStyle = .crossDissolve
        self.present(popUpVC, animated: true)
    }
    
    func presentModalEmailSent() {
        let vc = UIStoryboard(name: "ModalPresentations", bundle: nil).instantiateViewController(withIdentifier: "ModalEmailSentViewController")
        guard let popUpVC = vc as? ModalEmailSentViewController else { return }
        
        self.definesPresentationContext = true
        popUpVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        popUpVC.modalTransitionStyle = .crossDissolve
        self.present(popUpVC, animated: true)
    }
    
    func presentModalCompletedSignUp() {
        let vc = UIStoryboard(name: "ModalPresentations", bundle: nil).instantiateViewController(withIdentifier: "ModalSignUpCompleteViewController")
        guard let popUpVC = vc as? ModalSignUpCompleteViewController else { return }
        
        self.definesPresentationContext = true
        popUpVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        popUpVC.modalTransitionStyle = .crossDissolve
        self.present(popUpVC, animated: true)
    }
    
    func presentModalNotificationAuth() {
        let vc = UIStoryboard(name: "ModalPresentations", bundle: nil).instantiateViewController(withIdentifier: "ModalNotificationAuthViewController")
        guard let popUpVC = vc as? ModalNotificationAuthViewController else { return }
        
        self.definesPresentationContext = true
        popUpVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        popUpVC.modalTransitionStyle = .crossDissolve
        self.present(popUpVC, animated: true)
    }
    
}
