//
//  uploadPicVC.swift
//  Jewelry
//
//  Created by Febin Puthalath on 04/10/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Alamofire

class uploadPicVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate {
    @IBOutlet weak var imageUploadCollectionView: UICollectionView!
    
    @IBOutlet weak var discTextView: UITextView!
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var collectionViewHt: NSLayoutConstraint!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var sizeTF: UITextField!
    @IBOutlet weak var categoryTF: IQDropDownTextField!
    
    @IBOutlet weak var alertContainerView: UIView!
    @IBOutlet weak var okbtn: UIButton!
    var imageArray = [UIImage]()
    var imageLinkArray = [String]()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorView.Style.whiteLarge)
    var categoryDetail = [[String:Any]]()
    var categoryArray = [String]()
    var polishDetails = [[String:Any]]()
    var polishArray = [String]()

    @IBOutlet weak var polishTextField: IQDropDownTextField!
    
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
        
          self.imageUploadCollectionView.register(UINib(nibName: "UploadCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UploadCollectionViewCell")
        
        imageArray.append(UIImage(named: "Upload Image")!)
        
        categoryTF.layer.borderColor = UIColor.lightGray.cgColor
        categoryTF.layer.borderWidth = 1.0
        categoryTF.setLeftPaddingPoints(10)

        
        sizeTF.layer.borderColor = UIColor.lightGray.cgColor
        sizeTF.layer.borderWidth = 1.0
        sizeTF.setLeftPaddingPoints(10)

        weightTF.layer.borderColor = UIColor.lightGray.cgColor
        weightTF.layer.borderWidth = 1.0
        weightTF.setLeftPaddingPoints(10)

        polishTextField.layer.borderColor = UIColor.lightGray.cgColor
        polishTextField.layer.borderWidth = 1.0
        polishTextField.setLeftPaddingPoints(10)

        discTextView.layer.borderColor = UIColor.lightGray.cgColor
        discTextView.layer.borderWidth = 1.0
        
        discTextView.text = "Write Something About."
        discTextView.textColor = UIColor.lightGray
        
        okbtn.layer.cornerRadius = 5.0
        
       
        
        discTextView.delegate = self
        
        alertContainerView.backgroundColor =  UIColor.black.withAlphaComponent(0.5)
        alertContainerView.isHidden = true
        
        self.activityIndicator.center = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        self.activityIndicator.color = UIColor.black
        self.view.addSubview(self.activityIndicator)
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            ])
        
        callForGetCategoryApi()
        callForGetPolishDetail()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
        collectionViewHt?.constant = self.imageUploadCollectionView.contentSize.height
        
        
    }
    
    
    @IBAction func backBtnClk(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func faqBtnClk(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "FAQSVC") as? FAQSVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func menuBtnClk(_ sender: Any) {
    }
    
    @IBAction func uploadBtnClk(_ sender: Any) {
        
        //api/uploadprofile/userreviewimageupload
        
       if imageArray.contains(UIImage(named: "Upload Image")!){
            
            imageArray.removeLast()
            
        }
        if imageArray.count<4{
            
            imageArray.append(UIImage(named: "Upload Image")!)
            self.view.makeToast("please select a minimum of four images")
            return
        }
       
        if categoryTF.selectedItem == ""{
            self.view.makeToast("Pease select a category")
            return
        }
        if polishTextField.selectedItem == ""{
            self.view.makeToast("Pease select a polish type")
            return
        }
        if sizeTF.text == ""{
            self.view.makeToast("Pease enter the size")
            return
        }
        if weightTF.text == ""{
            self.view.makeToast("Pease enetr the weight")
            return
        }
        
        
        
        
        uploadSelectedImage()
        
        
        
    }
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
    func callForGetCategoryApi(){
        activityIndicator.startAnimating()
        
        
        
        NetworkClass.shared.getDetailsFromServer(withUrl: "api/custom/categoryListForUpload") { (isSuccess, response) in
            self.activityIndicator.stopAnimating()
            print(response)
            
            
            if  isSuccess{
                if (response["status"] as? String == "success"){
                    
                    self.categoryDetail = response["result"] as! [[String : Any]]
                    for category in self.categoryDetail{
                        self.categoryArray.append(category["category_name"]! as! String)
                    }
                    self.categoryTF.itemList = self.categoryArray
                }
                else{
                    self.view.makeToast(response["message"]as? String)
                }
            }
        }
        
        
        
        
    }
    func callForGetPolishDetail(){
        activityIndicator.startAnimating()
        
        
        
        NetworkClass.shared.getDetailsFromServer(withUrl: "api/uploadprofile/polishList") { (isSuccess, response) in
            self.activityIndicator.stopAnimating()
            print(response)
            
            
            if  isSuccess{
                if (response["status"] as? String == "success"){
                    
                    self.polishDetails = response["result"] as! [[String : Any]]
                    for polish in self.polishDetails{
                        self.polishArray.append(polish["polish_name"] as! String)
                    }
                    self.polishTextField.itemList = self.polishArray
                }
                else{
                    self.view.makeToast(response["message"]as? String)
                }
            }
        }
        
        
        
        
    }
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
                    self.callForuploadApi(uploadImage: imageForUpload)
                    
                }
                else{
                    
                    self.view.makeToast(response["message"]as? String)
                   
                    }
                    
                }
                
                
            
            else{
                
                let alert = UIAlertController(title: "Alert", message: "Error in connecting to server", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                        
                        
                    @unknown default:
                        print("error")
                    }}))
                self.present(alert, animated: true, completion: nil)
                
                
            }
        }
        
   
    }
    func callForuploadApi(uploadImage:[String:Any]){
        
        
/*"customer_id" : "5",
 "category" : "1",
 "size" : "2",
 "description" : "aaaaaaa",
 "weight" : "2.5",
 "polish" : "Normal",
 "image1" : "url1",
 "image2" : "url2",
 "image3" : "url3",
 "image4" : "url4",
 "image5" : "url5",
 "image6" : "url6" */
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        var parameters = uploadImage
        parameters["customer_id"] = userID
       // parameters["category"] = categoryTF.selectedItem
        parameters["description"] = discTextView.text ?? "   "
        parameters["size"] = sizeTF.text
        parameters["weight"] = weightTF.text
        parameters["polish"] = polishTextField.selectedItem
        
        var selectedcategoryid = Int()
        for i in 0..<categoryArray.count{
            if categoryArray[i] == categoryTF.selectedItem{
                
                selectedcategoryid = (categoryDetail[i]["category_id"] as! NSString).integerValue

            }
        }
        parameters["category"] = selectedcategoryid
        
       
        print("parameters",parameters)
        self.activityIndicator.startAnimating()
        NetworkClass.shared.postDetailsToServer(withUrl: "api/uploadprofile/insertuseruploadedimages", withParam: parameters) { (isSuccess, response) in
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            print(response)
            
            
            if  isSuccess{
                if response["status"] as? String == "success"{
                 
                    self.alertContainerView.isHidden = false
                    
                }
                else{
                    
                    self.view.makeToast(response["message"]as? String)
                    return
                    
                }
                
            }
            else{
                self.activityIndicator.stopAnimating()
                let alert = UIAlertController(title: "Alert", message: "issue with connecting to server", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                        
                        
                    @unknown default:
                        print("error")
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
        
        
    }
     
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func okBtnclk(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        

            return imageArray.count
       

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var defaultCell : UICollectionViewCell!
        if(collectionView == self.imageUploadCollectionView)
        {
            let cell: UploadCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadCollectionViewCell", for: indexPath) as! UploadCollectionViewCell
            //Upload Image
            cell.bgView.layer.shadowColor = UIColor.darkGray.cgColor
            cell.bgView.layer.shadowOffset = CGSize(width: 1, height:3)
            cell.bgView.layer.shadowOpacity = 0.6
            cell.bgView.layer.shadowRadius = 3.0
            cell.bgView.layer.cornerRadius = 5.0
            
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
      return defaultCell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if(collectionView == self.imageUploadCollectionView)
        {
            return CGSize(width:100, height:100)
        }
        
         return CGSize(width: 0, height: 0)
        
        
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
        
        
        imageUploadCollectionView.reloadData()
        
        
        
        
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

}
extension uploadPicVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        imageArray.insert(image, at: 0)
        
        if imageArray.count>6{
            imageArray.removeLast()
        }
        let numberOfRows = CGFloat(imageArray.count)
        collectionViewHt.constant =  (numberOfRows/3).rounded(.up)*100
        self.imageUploadCollectionView.reloadData()
        
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
