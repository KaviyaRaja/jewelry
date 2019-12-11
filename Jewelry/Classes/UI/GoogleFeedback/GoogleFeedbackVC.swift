//
//  GoogleFeedbackVC.swift
//  Nisagra
//
//  Created by Apple on 27/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import SDWebImage
import SKActivityIndicatorView
import Toast_Swift

class GoogleFeedbackVC: UIViewController {
    
    @IBOutlet weak var mRatingView: CosmosView!

    @IBOutlet weak var mNameLabel: CustomFontLabel!
    @IBOutlet weak var mProfileImageView: UIImageView!
    @IBOutlet weak var mTextView: UITextView!
    
    private let startRating = Int.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13, *){
                     let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
                     statusBar.backgroundColor = UIColor(red:0.98, green:0.17, blue:0.61, alpha:1.0)
                     UIApplication.shared.keyWindow?.addSubview(statusBar)
                 }
        else {
            UIApplication.shared.statusBarView?.backgroundColor = UIColor(red:0.98, green:0.17, blue:0.61, alpha:1.0)
        }
        
        self.mProfileImageView.layer.cornerRadius = self.mProfileImageView.frame.size.width/2
        self.mProfileImageView.layer.masksToBounds = true
        refreshmenu()
        
        
        
    }
    @objc func refreshmenu()
    {
    var dataDict : NSDictionary = [:]
    var data = UserDefaults.standard.object(forKey: "UserData") as? Data
    if let aData = data {
        dataDict = NSKeyedUnarchiver.unarchiveObject(with: aData) as! NSDictionary
        print(dataDict)
        self.mNameLabel.text =  String(format:"%@ %@",(dataDict["firstname"] as? String)!,(dataDict["lastname"] as? String)!)
    }
    var image = dataDict["image"] as? String
    if(image != nil){
    if(image == "0")
    {
    image = "http://3.213.33.73/Ecommerce/upload/image/backend/profile.png"
    }
    else
    {
    image = image?.replacingOccurrences(of: " ", with: "%20")
    }
    self.mProfileImageView.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "Rectangle"))
    }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnAction(_ sender: Any)
    {
        if  (self.mTextView.text != "") || (self.mRatingView.rating != 0 )
            {
                self.submitReview()
              
            }
            else
           {
                self.view.makeToast("Please give Review")
            }
        }
    
    func submitReview()
        {
            
            var rate :  String = ""
            SKActivityIndicator.show("Loading...")
            let Url = String(format: "%@api/rateus/giveRateUs",Constants.BASEURL)
            print(Url)
            let userID =  UserDefaults.standard.string(forKey: "customer_id")
            if(mRatingView.rating == 1)
            {
                rate = "1"
            }
            else if(mRatingView.rating == 2)
            {
                rate = "2"
            }
            else if(mRatingView.rating == 3)
            {
                rate = "3"
            }
            else if(mRatingView.rating == 4)
            {
                rate = "4"
            }
            else if(mRatingView.rating == 5)
            {
                rate = "5"
            }
            //let updateOnTouch = CosmosDefaultSettings.updateOnTouch
            let headers: HTTPHeaders =
                [
                    "Content-Type": "application/json"
            ]
            let parameters: Parameters =
                [
                    "customer_id" : userID ?? "",
                    "feedback" : self.mTextView.text,
                    "rate" : rate,
                    ]
            print(parameters)
            Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    print(response)
                    SKActivityIndicator.dismiss()
                    switch(response.result) {
                        
                    case .success:
                        if let json = response.result.value
                        {
                            let JSON = json as! NSDictionary
                            print(JSON)
                            self.view.makeToast(JSON["message"] as? String)
                            Constants.appDelegate?.goToHome()
                        }
                        break
                        
                    case .failure(let error):
                        print(error)
                        break
                        
                    }
            }
        }
        
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
