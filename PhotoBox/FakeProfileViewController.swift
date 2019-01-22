//
//  FakeProfileViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/21/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit
/*

class FakeProfileViewController: UIViewController {
    
    var event: Event?{
        didSet{
            updateViews()
        }
    }
    var eventMember: [BasicProfile] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func updateViews(){
        fetchMembersOfEvent(){
            for memberID in event?.memberIDs{
                fetchBasicMemberInfo(for: memberID, completion: { (baseProfile) in
                    eventMember.append(baseProfile)
                })
            }
        }
    }
    
    func fetchBasicMemberInfo(for memberId: String, completion: @escaping (BasicProfile) -> ()){
        if let basicProfile = basicProfileCasche.object(forKey: NSString(string: memberId)){
            completion(basicProfile)
        }
        FireStoreManager.fetchbasicProfile(for: memberId) { basicProfile in
            basicProfileCasche.setObject(basicProfile, forKey: memberId)
            completion(basicProfile)
        }
    }

    var basicProfileCasche: NSCache<NSString, BasicProfile> = NSCache()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
*/
