//
//  OfferVC.swift
//  Jewelry
//
//  Created by Febin Puthalath on 03/10/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import SKActivityIndicatorView
import SDWebImage
import Alamofire



class OfferVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var menuSegment: UISegmentedControl!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var offerCollectionView: UICollectionView!
    @IBOutlet weak var mCartCountLabel : CustomFontLabel!
    @IBOutlet weak var collectionViewHtCnst: NSLayoutConstraint!

    var bannerArray : NSArray = []
    var offerArray : NSArray = []

    
    let segmentBottomBorder = CALayer()
    var slideCount : Int?
    var selectedofferCategory = 1
    var selecteditem = 1
    var timer:Timer = Timer()



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
        
        menuSegment.removeBorder()
        segmentBottomBorder.removeFromSuperlayer()
        setBorder(sender: menuSegment)
        self.bannerCollectionView.register(UINib(nibName: "SliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SliderCollectionViewCell")
         self.offerCollectionView.register(UINib(nibName: "offerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "offerCollectionViewCell")

        
        self.mCartCountLabel.layer.cornerRadius = self.mCartCountLabel.frame.size.width/2
        self.mCartCountLabel.layer.masksToBounds = true
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timer.invalidate()

        callForOfferListApi()
        getCartCount()
    }
    func startTimer() {
        
        timer =  Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        if let coll  = bannerCollectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                
                if ((indexPath?.row)! < bannerArray.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                    self.pageControl.currentPage = indexPath1!.row
                    
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                    self.pageControl.currentPage = indexPath1!.row
                    
                    
                }
                
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
        collectionViewHtCnst?.constant = self.offerCollectionView.contentSize.height
        getCartCount()
    }
    @IBAction func menuSegmentSelected(_ sender: Any) {
        segmentBottomBorder.removeFromSuperlayer()
        setBorder(sender: menuSegment)
        selectedofferCategory = menuSegment.selectedSegmentIndex+1
            callForOfferListApi()
    }
    
    func setBorder(sender:UISegmentedControl){
        
        let underlineWidth: CGFloat = sender.bounds.size.width / CGFloat(sender.numberOfSegments)
        let underlineHeight: CGFloat = 2
        let underlineXPosition = CGFloat(sender.selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = sender.bounds.size.height - underlineHeight
        segmentBottomBorder.frame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        //let underline = UIView(frame: underlineFrame)
        segmentBottomBorder.backgroundColor = UIColor(red: 229/255.0, green: 66/255.0, blue: 153/255.0, alpha: 1).cgColor
        sender.layer.addSublayer(segmentBottomBorder)
        
    }
    @IBAction func menuBtnClk(_ sender: Any) {
    }
    
    @IBAction func uploadBtnClk(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "uploadPicVC") as? uploadPicVC
        self.navigationController?.pushViewController(myVC!, animated: true)
        
    }
    
    @IBAction func notificationBtnClk(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func cartbtnClk(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - API
    func getCartCount()
    {
        let Url = String(format: "%@api/cart/cartcount&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
        let headers: HTTPHeaders =
            [
                "Content-Type": "application/json"
        ]
        Alamofire.request(Url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
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
                            self.mCartCountLabel.text = JSON["data"] as? String
                            if(self.mCartCountLabel.text == "0")
                            {
                                self.mCartCountLabel.isHidden = true
                            }
                            else
                            {
                                self.mCartCountLabel.isHidden = false
                            }
                        }
                        else
                        {
                            //self.view.makeToast(JSON["message"] as? String)
                        }
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
        
    }
    
    
    
    func callForOfferListApi(){
    SKActivityIndicator.show("Loading...")
    let userID =  UserDefaults.standard.string(forKey: "customer_id")
    let parameters =
        [
            "data_id" : selectedofferCategory
          
        ] as [String : Any]
    
    SKActivityIndicator.dismiss()
    
    print (parameters)
    
    NetworkClass.shared.postDetailsToServer(withUrl: "api/custom/offerList", withParam: parameters) { (isSuccess, response) in
    // Your Will Get Response here
    
    SKActivityIndicator.dismiss()
    
    print(response)
    
    
    if  isSuccess{
    
    
    print("details:",response)
    
    
    if  (response["status"] as? String == "error"){
    
    self.view.makeToast( response["message"] as? String)
    
    }
    
    
    
    
    else{
    
    if  (response["status"] as? String == "success"){
    self.startTimer()
    self.bannerArray = (response["banner_offer"] as? NSArray)!
    self.bannerCollectionView.reloadData()
    self.pageControl.numberOfPages = self.bannerArray.count
    self.offerArray = (response["result"] as? NSArray)!
    self.mCartCountLabel.text = String(format: "%d Products found",self.bannerArray.count)
    self.offerCollectionView.reloadData()
   
    
    }
    }
    }
    else{
    self.view.makeToast("Issue with connecting to server")
    
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
    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if(collectionView == self.bannerCollectionView)
        {
            return self.bannerArray.count
        }
        if(collectionView == self.offerCollectionView)
        {
            return self.offerArray.count
        }
        return 0

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var defaultCell : UICollectionViewCell!
        if(collectionView == self.bannerCollectionView)
        {
            let cell: SliderCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionViewCell", for: indexPath) as! SliderCollectionViewCell
            let dict = self.bannerArray[indexPath.row] as? NSDictionary
            var image = dict!["image"] as? String
            if(image != nil){
                image = image?.replacingOccurrences(of: " ", with: "%20")
                cell.imageView.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "placeholder"))
            }
            return cell
        }
        if(collectionView == self.offerCollectionView)
        {
            let cell: offerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "offerCollectionViewCell", for: indexPath) as! offerCollectionViewCell
            
            
            cell.productContainerView.layer.shadowColor = UIColor.darkGray.cgColor
            cell.productContainerView.layer.shadowOffset = CGSize(width: 1, height:3)
            cell.productContainerView.layer.shadowOpacity = 0.6
            cell.productContainerView.layer.shadowRadius = 3.0
            cell.productContainerView.layer.cornerRadius = 5.0
            cell.layer.cornerRadius = 2.0
           
            let dict = self.offerArray[indexPath.row] as? NSDictionary
            var image = dict!["image"] as? String
            if(image != nil){
                image = image?.replacingOccurrences(of: " ", with: "%20")
                cell.offerImageView.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "placeholder"))
            }
            cell.offerLabel.text = dict!["title"] as? String
            cell.titleLabel.text = dict!["name"] as? String
            
            return cell
        }
        return defaultCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if(collectionView == self.bannerCollectionView)
        {
            return CGSize(width: Constants.SCREEN_WIDTH, height: collectionView.bounds.size.height)
        }
        if(collectionView == self.offerCollectionView)
        {
            return CGSize(width: 100, height: 120)
        }
        
        return CGSize(width: 0, height: 0)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if(scrollView == self.bannerCollectionView)
        {
            for cell in self.bannerCollectionView.visibleCells  as! [SliderCollectionViewCell]    {
                let indexPath = self.bannerCollectionView.indexPath(for: cell as UICollectionViewCell)
                self.slideCount = (indexPath?.item)!
                self.pageControl.currentPage = self.slideCount!
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
        {
            let dict = self.offerArray[indexPath.row] as? NSDictionary
            let productID = dict![ "offer_id"] as? String
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "ListVC") as? ListVC
            myVC?.selectedCategory = productID
            myVC?.type = "offer"
            self.navigationController?.pushViewController(myVC!, animated: false)
    }
    
    
    
}
