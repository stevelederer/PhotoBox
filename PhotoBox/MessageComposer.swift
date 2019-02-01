//
//  MessageComposer.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/23/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import Foundation
import MessageUI

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate{
    
    // MARK: - Invite Text Message Functions
    
    // checks to see if the device can send text messages
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    func composeEventInviteTextMessageWith(eventName: String, code: String, creator: String) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self
        messageComposeVC.body = "You’ve been invited to contribute to a PhotoBox! \(creator) has created a Photobox for \(eventName). To add your photos to the collection, open the Photobox app and enter \(code)."
        return messageComposeVC
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Report Inappropriate Content Email Functions
    
    func canSendEmail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    func composePhotoReportEmailWith(photo: Photo) -> MFMailComposeViewController {
        let emailComposeVC = MFMailComposeViewController()
        emailComposeVC.mailComposeDelegate = self
        emailComposeVC.setToRecipients(["PhotoBoxApp@pm.me"])
        emailComposeVC.setSubject("Innappropriate Photo")
        emailComposeVC.setMessageBody("Dear PhotoBox,\n\nI would like to report this photo as inappropriate.\n\nPhoto ID: \(photo.uuid)\n\nUser ID: \(photo.creatorID)", isHTML: false)
        return emailComposeVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
