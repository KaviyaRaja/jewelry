//
//  Rate&ReviewVC.swift
//  Nisarga
//
//  Created by Hari Krish on 11/09/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView
import Cosmos

class Rate_ReviewVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate

{
    
    @IBOutlet weak var mRatingnumLabel : CustomFontLabel!
    @IBOutlet weak var mRatingheadingLabel : CustomFontLabel!
    @IBOutlet weak var mUserNameLabel : CustomFontLabel!
    @IBOutlet weak var mReviewTextview: UITextView!
    @IBOutlet weak var mWriteReviewBtn: CustomFontButton!
    @IBOutlet weak var mTittletf: CustomFontTextField!
    @IBOutlet weak var mSubmitReviewBtn: CustomFontButton!
    @IBOutlet weak var mlikeBtn: CustomFontButton!
    @IBOutlet weak var mUnlikeBtn: CustomFontButton!
    @IBOutlet weak var mLikeImage : UIImageView!
    @IBOutlet weak var mUnLikeImage : UIImageView!
    @IBOutlet weak var mWriteView : UIView!
    @IBOutlet weak var mtitleView : UIView!
    @IBOutlet weak var writeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var mRatecollectionView : UICollectionView!
    @IBOutlet weak var mRatingView: CosmosView!
    @IBOutlet weak var collectionViewHt: NSLayoutConstraint!
    
    private let startRating = Int.self
    var ProductId  : String!
    var reviewArray : NSArray = []
    var rate : String!
    var imageArray = [UIImage]()
    var imageLinkArray = [String]()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorView.Style.whiteLarge)
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
        mRatecollectionView.delegate = self
        mRatecollectionView.dataSource = self
        
      mRatecollectionView.register(UINib(nibName: "UploadCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UploadCollectionViewCell")

        
        
      
        
        
//        self.mRatingheadingLabel.layer.shadowColor = UIColor.darkGray.cgColor
//        self.mRatingheadingLabel.layer.shadowOffset = CGSize(width: 1, height:3)
//        self.mRatingheadingLabel.layer.shadowOpacity = 0.6
//        self.mRatingheadingLabel.layer.shadowRadius = 3.0
//        self.mRatingheadingLabel.layer.cornerRadius = 5.0
//        self.mRatingheadingLabel.layer.borderWidth = 1.0
        
        self.mWriteView.layer.shadowColor = UIColor.lightGray.cgColor
        self.mWriteView.layer.shadowOffset = CGSize(width: 1, height:3)
        self.mWriteView.layer.shadowOpacity = 0.6
        self.mWriteView.layer.shadowRadius = 3.0
        self.mWriteView.layer.cornerRadius = 5.0
        
       
//        self.mWriteView.layer.borderWidth = 1.0
//        self.mWriteView.layer.shadowColor = UIColor.lightGray.cgColor
//        self.mWriteView.layer.shadowOffset = CGSize(width: 1, height:3)
//        self.mWriteView.layer.shadowOpacity = 0.6
//        self.mWriteView.layer.shadowRadius = 3.0
       
        
        
         //self.mRatecollectionView.backgroundView?.backgroundColor = UIColor.lightGray.cgColor
        
        
        // Do any additional setup after loading the view.
        
//        self.mReviewTextview.layer.cornerRadius = 5
//        self.mReviewTextview.layer.borderColor = UIColor.lightGray.cgColor
//        self.mReviewTextview.layer.borderWidth = 1
        
        self.mReviewTextview.layer.borderColor = UIColor.lightGray.cgColor
        self.mReviewTextview.layer.borderWidth = 1.0
        
        self.mReviewTextview.text = "Write Something About."
        self.mReviewTextview.textColor = UIColor.lightGray
        
        self.mtitleView.layer.borderColor = UIColor.lightGray.cgColor
        self.mtitleView.layer.borderWidth = 1.0
        
        //self.mtitleView.textColor = UIColor.lightGray
       // getData()
        
//        var dataDict : NSDictionary = [:]
//        var data = UserDefaults.standard.object(forKey: "UserData") as? Data
//        if let aData = data {
//            dataDict = NSKeyedUnarchiver.unarchiveObject(with: aData) as! NSDictionary
//            print(dataDict)
//            self.mUserNameLabel.text =  String(format:"%@ %@",(dataDict["firstname"] as? String)!,(dataDict["lastname"] as? String)!)
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        imageArray.append(UIImage(named: "Upload Image")!)
        mRatecollectionView.reloadData()
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        collectionViewHt?.constant = self.mRatecollectionView.contentSize.height
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Mark: - Btn Action
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func writeReviewBtnAction(_ sender: Any)
    {
        self.mWriteView.isHidden = false
        self.writeViewHeight.constant = 250
        self.mWriteReviewBtn.alpha = 0.8
    }
    @IBAction func uploadBtnClk(_ sender: Any) {
        
        //api/uploadprofile/userreviewimageupload
        
        if imageArray.contains(UIImage(named: "Upload Image")!){
            
            imageArray.removeLast()
            
        }
        if imageArray.count<1{
            
            imageArray.append(UIImage(named: "Upload Image")!)
           // self.view.makeToast("please select a minimum of four images")
            return
        }
        uploadSelectedImage()
    }
  
    @IBAction func mSubmitReviewBtn(_ sender: Any)
    {
            //(self.mRatingView.rating < 0)&&
     if  (self.mReviewTextview.text != "Write Something About.") && (self.mRatingView.rating != 0 )
        {
            self.submitreview()
          
        }
        else
       {
            self.view.makeToast("Please give Review")
        }
    }
     //if(self.mRatingView.rating == Double(0)) && (self.mReviewTextview.text == "Write Something About.") && (self.mTittletf.text == "") && (imageArray.contains(UIImage(named: "Upload Image")!))
    @IBAction func cancelBtnClk(_ sender: Any) {
           
        self.navigationController?.popViewController(animated: true)
       }
       
       func textViewDidBeginEditing(_ textView: UITextView) {
           if textView.textColor == UIColor.lightGray {
               textView.text = nil
               textView.textColor = UIColor.black
              
           }
       }
       
       func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text.isEmpty {
               textView.text = "Write Something About."
               textView.textColor = UIColor.lightGray
           }
       }
    // MARK: - API
   // func getData()
//
    fileprivate func uploadSelectedImage() {
        
        
        self.activityIndicator.startAnimating()
        
        NetworkClass.shared.uploadImagesAsArray(withUrl: "api/uploadprofile/userreviewimageupload", withImages: self.imageArray){
            (isSuccess, response) in
            
            self.activityIndicator.stopAnimating()
            
            
            print("response:",response)
            if  isSuccess{
                if  (response["status"] as? String == "success"){
                    
                    
                    let detailDict = response["images"] as? [[String:Any]]
                    let dict = detailDict![0]
                    var imageForUpload = [String:Any]()
                    for i in 0...(dict.keys.count)-1{
                        
                        let titleStr =  String(format: "image%@", String(i+1))
                        let currentTitle = String(format: "image%@", String(i))
                        imageForUpload[titleStr] = dict[currentTitle] as? String
                        
                    }
                    
                    print("imageupload",imageForUpload)
                  self.calluploadImage(uploadImage: imageForUpload)
                    
                }
                else{
                    
                    self.view.makeToast(response["message"]as? String)
                    
                }
                
            }
                
                
                

        }
        
        
    }
//    func callForuploadApi(uploadImage:[String:Any]){
//
//
//        /*"customer_id" : "5",
//         "category" : "1",
//         "size" : "2",
//         "description" : "aaaaaaa",
//         "weight" : "2.5",
//         "polish" : "Normal",
//         "image1" : "url1",
//         "image2" : "url2",
//         "image3" : "url3",
//         "image4" : "url4",
//         "image5" : "url5",
//         "image6" : "url6" */
//        let userID =  UserDefaults.standard.string(forKey: "customer_id")
//        let
//        var parameters = uploadImage
//        parameters["customer_id"] = userID
//        // parameters["category"] = categoryTF.selectedItem
//       // parameters["description"] = discTextView.text ?? "   "
//       // parameters["size"] = sizeTF.text
//       // parameters["weight"] = weightTF.text
//        //parameters["polish"] = polishTextField.selectedItem
//
////        var selectedcategoryid = Int()
////        for i in 0..<categoryArray.count{
////            if categoryArray[i] == categoryTF.selectedItem{
////
////                selectedcategoryid = (categoryDetail[i]["category_id"] as! NSString).integerValue
////
////            }
////        }
//       //parameters["category"] = selectedcategoryid
//
//
//        print("parameters",parameters)
//        self.activityIndicator.startAnimating()
//        NetworkClass.shared.postDetailsToServer(withUrl: "api/uploadprofile/insertuseproductreviewdetails", withParam: parameters) { (isSuccess, response) in
//
//            self.activityIndicator.stopAnimating()
//            self.activityIndicator.isHidden = true
//
//            print(response)
//
//
//            if  isSuccess{
//                if response["status"] as? String == "success"{
//
//                    self.view.makeToast(response["message"]as? String)
//                    return
//
//                }
//                else{
//
//
//
//                }
//
//            }
//
//
//
//        }
//
//
//    }
    
    func calluploadImage(uploadImage:[String:Any])
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/uploadprofile/editNavImage",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "profile_pic" : uploadImage
                ]
        print(parameters)
        let headers: HTTPHeaders =
            [
                "Content-Type": "application/json"
        ]
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
                        if(JSON["status"] as? String == "success")
                        {
//                            UserDefaults.standard.setValue(self.imageUrl, forKey: "ProfilePic")
                        }
                        else
                        {
                            self.view.makeToast(JSON["message"] as? String)
                        }
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
        
    }
    func submitreview()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/uploadprofile/insertuseproductreviewdetails",Constants.BASEURL)
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
        var parameter = calluploadImage
        //let productID = dict["product_id"] as! String
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "product_id" : ProductId ?? "",
//                "image1" : calluploadImage,
//                "image2" : calluploadImage,
//                "image3" : calluploadImage,
//                "image4" : calluploadImage,
                "text" : self.mReviewTextview.text ?? "",
                 "title" : self.mTittletf.text ?? "",
                 "rating" : rate,
                ]
        print(parameters)
        let headers: HTTPHeaders =
            [
                "Content-Type": "application/json"
        ]
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
                        if(JSON["status"] as? String == "success")
                        {
                           Constants.appDelegate?.goToHome()    //UserDefaults.standard.setValue(self.imageUrl, forKey: "ProfilePic")
                        }
                        else
                        {
                            self.view.makeToast(JSON["message"] as? String)
                        }
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
        
    }

//    func submitReview()
//    {
//
//        var rate :  String = ""
//        if(self.mlikeBtn.isSelected)
//        {
//            rate = "1"
//        }
//        else if(self.mUnlikeBtn.isSelected)
//        {
//            rate = "0"
//        }
//        SKActivityIndicator.show("Loading...")
//        let Url = String(format: "%@api/rateus/giveRateUs",Constants.BASEURL)
//        print(Url)
//        let userID =  UserDefaults.standard.string(forKey: "customer_id")
//        let headers: HTTPHeaders =
//            [
//                "Content-Type": "application/json"
//        ]
//        let parameters: Parameters =
//            [
//                "customer_id" : userID ?? "",
//                "feedback" : self.mReviewTextview.text,
//                "rate" : rate,
//                ]
//        print(parameters)
//        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//            .responseJSON { response in
//                print(response)
//                SKActivityIndicator.dismiss()
//                switch(response.result) {
//
//                case .success:
//                    if let json = response.result.value
//                    {
//                        let JSON = json as! NSDictionary
//                        print(JSON)
//                        self.view.makeToast(JSON["message"] as? String)
//                        self.mReviewTextview.text = ""
//                        self.mlikeBtn.isSelected = false
//                        self.mLikeImage.image = UIImage(named: "Ratelike")
//                        self.mUnlikeBtn.isSelected = false
//                        self.mUnLikeImage.image = UIImage(named: "Rateunlike")
//                        self.getData()
//                    }
//                    break
//
//                case .failure(let error):
//                    print(error)
//                    break
//
//                }
//        }
//    }

    // MARK: - TableView Delegates
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
      
            let cell: UploadCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadCollectionViewCell", for: indexPath) as! UploadCollectionViewCell
            //Upload Image
//            cell.bgView.layer.shadowColor = UIColor.darkGray.cgColor
//            cell.bgView.layer.shadowOffset = CGSize(width: 1, height:3)
//            cell.bgView.layer.shadowOpacity = 0.6
//            cell.bgView.layer.shadowRadius = 3.0
//            cell.bgView.layer.cornerRadius = 5.0
        
            cell.layer.cornerRadius = 5.0
            
            cell.selectedImage.image = imageArray[indexPath.row]
            
            if imageArray[indexPath.row] == UIImage(named: "Upload Image") {
                cell.cancelButton.isHidden = true
            }
            else{
                cell.cancelButton.isHidden = false
            }
            cell.cancelButton.tag = indexPath.row
            cell.cancelButton.addTarget(self, action: #selector(cancelButtonClk(sender:)), for: .touchUpInside)
            
            
            return cell
        
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       
    
            return CGSize(width:100, height:100)
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Got clicked!")
        
        if imageArray[indexPath.row] == UIImage(named: "Upload Image") {
            
            self.showActionSheet()
            
        }
        
        
        
    }
    
    @objc func cancelButtonClk(sender: UIButton){
        
        
        if !imageArray.contains(UIImage(named: "Upload Image")!){
            imageArray.append(UIImage(named: "Upload Image")!)
        }
        
        imageArray.remove(at: sender.tag)
        
        
        mRatecollectionView.reloadData()
        
        
        
        
    }
    func showActionSheet() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
            
            //self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            
            self.photoLibrary()
            // self.photoLibrary()
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    

//extension uploadPicVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        imageArray.insert(image, at: 0)
        
        if imageArray.count>4{
            imageArray.removeLast()
        }
        let numberOfRows = CGFloat(imageArray.count)
        collectionViewHt.constant =  (numberOfRows/3).rounded(.up)*100
        self.mRatecollectionView.reloadData()
        
    }
    
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    func photoLibrary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
}
}
