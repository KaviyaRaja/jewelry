//
//  ProductOneVC.swift
//  Jewelry
//
//  Created by Febin Puthalath on 17/10/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import SKActivityIndicatorView
import Alamofire
import WebKit


class ProductOneVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,IQDropDownTextFieldDelegate,IQDropDownTextFieldDataSource,UICollectionViewDelegateFlowLayout,WKNavigationDelegate  {
    
    @IBOutlet weak var SimilarProductViewAll: UIButton!
    @IBOutlet weak var SimilarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var SimilarHeight: NSLayoutConstraint!
    @IBOutlet weak var ViewAllHeight: NSLayoutConstraint!
    @IBOutlet weak var questionTableHtCnst: NSLayoutConstraint!
    @IBOutlet weak var specificationSegment: UISegmentedControl!
    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var ratingDetailLbl: UILabel!
    @IBOutlet weak var userRatingDetailLabel: UILabel!
    @IBOutlet weak var CartCountlLabel: UILabel!
    @IBOutlet weak var serachTF: UITextField!
    @IBOutlet weak var ratingTableView: UITableView!
    @IBOutlet weak var seperator3Cnst: NSLayoutConstraint!
    @IBOutlet weak var searchBtnHt: NSLayoutConstraint!
    @IBOutlet weak var searchTFHtCnst: NSLayoutConstraint!//40
    @IBOutlet weak var ratingTableHtCnst: NSLayoutConstraint!
    @IBOutlet weak var seperator1Cnst: NSLayoutConstraint!//1
    @IBOutlet weak var userRatinghtCnst: NSLayoutConstraint!//21
    @IBOutlet weak var ratingDetailHtCnst: NSLayoutConstraint!//28
    @IBOutlet weak var writeReviewHtCnst: NSLayoutConstraint!//30
    @IBOutlet weak var ratingLblHtCnst: NSLayoutConstraint!//25
    @IBOutlet weak var speceficationDetailCnst: NSLayoutConstraint!//200
    @IBOutlet weak var SpecificationDetailView: UIView!
    @IBOutlet weak var similarProductCollectionView: UICollectionView!
    @IBOutlet weak var quantityTF: CustomFontTextField!
    @IBOutlet weak var sizeTF: IQDropDownTextField!
    @IBOutlet weak var weightTF: CustomFontTextField!
    @IBOutlet weak var polishTF: IQDropDownTextField!
    @IBOutlet weak var offLbl: CustomFontLabel!
    @IBOutlet weak var discountLbl: CustomFontLabel!
    @IBOutlet weak var priceLbl: CustomFontLabel!
    @IBOutlet weak var userRatingLbl: CustomFontLabel!
    @IBOutlet weak var mainRatingLbl: CustomFontLabel!
    @IBOutlet weak var productNameLbl: CustomFontLabel!
    @IBOutlet weak var HeaderNameLbl: CustomFontLabel!
    @IBOutlet weak var writereviewbtn: CustomFontButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var QuantityPopUpView : UIView!
    @IBOutlet weak var quantitypopLbl: CustomFontLabel!
    
    
    var ProductID  : String!
    var bannerArray : NSArray = []
    var isSimilarProducts : Bool = false
    var similarArray = [[String:Any]]()
    var detailarray : NSArray = []
    var collectionType : NSString = ""
    var slideCount : Int?
    var RatingsArray = [[String:Any]]()
    var QuestionsArray = [[String:Any]]()
    var relatedID : NSString!
    var SizeArray : NSArray = []
    var tempRatingArray = [[String:Any]]()
    var tempQuestionArray = [[String:Any]]()
    var htmlString = String()
    var productDesc = String()
    var orderID : String!
    var shopnow = String()
    var isRatingExpanded = false
    var isQuestionExpanded = false
    var type : String!
    var wishListStatus = "0"
    var PolArray   : NSArray = []
    

    let pink = UIColor(red: 229/255.0, green: 67/255.0, blue: 153/255.0, alpha: 1)
    
    var webViewHtConstraint: NSLayoutConstraint?
    lazy var webView: WKWebView = {
        guard let path = Bundle.main.path(forResource: "style", ofType: "css") else {
            return WKWebView()
        }
        
        let cssString = try! String(contentsOfFile: path).components(separatedBy: .newlines).joined()
        let source = """
        var style = document.createElement('style');
        style.innerHTML = '\(cssString)';
        document.head.appendChild(style);
        """
        
        let userScript = WKUserScript(source: source,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: true)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        let webView = WKWebView(frame: .zero,
                                configuration: configuration)
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        return webView
    }()
    
    let textView = UITextView()

    

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
        self.CartCountlLabel.layer.cornerRadius = self.CartCountlLabel.frame.size.width/2
        self.CartCountlLabel.layer.masksToBounds = true
        
        writereviewbtn.isHidden = true
        ratingTableView.delegate = self
        ratingTableView.dataSource = self
        questionTableView.delegate = self
        questionTableView.dataSource = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        similarProductCollectionView.delegate = self
        similarProductCollectionView.dataSource = self
        sizeTF.dataSource = self
        sizeTF.delegate = self
        polishTF.dataSource = self
        polishTF.delegate = self
        
        ratingTableView.estimatedRowHeight = 397
        ratingTableView.rowHeight = UITableViewAutomaticDimension
        ratingTableView.estimatedRowHeight = 147
        ratingTableView.rowHeight = UITableViewAutomaticDimension
        
        polishTF.layer.borderColor = UIColor(red: 0.98, green: 0.13, blue: 0.62, alpha: 1.0).cgColor
        sizeTF.layer.borderColor = UIColor(red: 0.98, green: 0.13, blue: 0.62, alpha: 1.0).cgColor
        weightTF.layer.borderColor = UIColor(red: 0.98, green: 0.13, blue: 0.62, alpha: 1.0).cgColor
        quantityTF.layer.borderColor = UIColor(red: 0.98, green: 0.13, blue: 0.62, alpha: 1.0).cgColor
        
        self.bannerCollectionView.register(UINib(nibName: "SliderCell", bundle: nil), forCellWithReuseIdentifier: "SliderCell");
        self.similarProductCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        
        self.ratingTableView.register(UINib(nibName: "ProductDetailRatingTableViewCell", bundle: .main), forCellReuseIdentifier: "ProductDetailRatingTableViewCell")
        self.questionTableView.register(UINib(nibName: "ProductQuestionTableViewCell", bundle: .main), forCellReuseIdentifier: "ProductQuestionTableViewCell")
        specificationSegment.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.darkGray], for: UIControlState.selected)
        specificationSegment.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray], for: UIControlState.normal)
        
        
        webView.frame  = CGRect(x: 0, y: 0, width: SpecificationDetailView.frame.width, height: 100)
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false;
        SpecificationDetailView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: SpecificationDetailView.topAnchor, constant: 0).isActive = true
        webView.leftAnchor.constraint(equalTo: SpecificationDetailView.leftAnchor, constant: 0).isActive = true
        webView.rightAnchor.constraint(equalTo: SpecificationDetailView.rightAnchor, constant: 0).isActive = true
        webView.bottomAnchor.constraint(equalTo: SpecificationDetailView.bottomAnchor, constant: 0).isActive = true
        
        
        
        
        webViewHtConstraint = webView.heightAnchor.constraint(equalToConstant: 10)
        webViewHtConstraint?.isActive = true
        
        
        textView.frame.origin = CGPoint(x:0, y: 0)
        textView.frame.size = CGSize(width:SpecificationDetailView.frame.width , height: SpecificationDetailView.frame.height - 16)
        textView.clipsToBounds = true
        textView.font = UIFont(name: Constants.FONTNAME as String, size: 15)!
       
        textView.isScrollEnabled = false
       
        textView.textColor = UIColor.darkGray
        textView.textAlignment = .center
        textView.backgroundColor = UIColor.clear
        
        
        self.sizeTF.delegate = self as? IQDropDownTextFieldDelegate
        weightTF.backgroundColor = UIColor(red: 248/255.0, green: 215/255.0, blue: 234/255.0, alpha: 1)
        
        weightTF.isUserInteractionEnabled = false
        quantityTF.layer.borderColor = pink.cgColor
        polishTF.layer.borderColor = pink.cgColor
        sizeTF.layer.borderColor = pink.cgColor
        quantityTF.layer.borderWidth = 1.0
        polishTF.layer.borderWidth = 1.0
        sizeTF.layer.borderWidth = 1.0
        weightTF.layer.borderWidth = 1.0
        offLbl.sizeToFit()
        self.serachTF.isHidden = true
        self.searchBtn.isHidden = true
    
        getOrderDetail()
        getCartCount()


        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.ratingTableView.addObserver(self, forKeyPath: "RatingcontentSize", options: .new, context: nil)
         self.questionTableView.addObserver(self, forKeyPath: "QuestioncontentSize", options: .new, context: nil)

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.ratingTableView.removeObserver(self, forKeyPath: "RatingcontentSize")
        self.questionTableView.removeObserver(self, forKeyPath: "QuestioncontentSize")

        super.viewWillDisappear(true)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "RatingcontentSize"){
            
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.ratingTableHtCnst.constant = newsize.height
            }
        }
        if(keyPath == "QuestioncontentSize"){
            
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
               self.questionTableHtCnst.constant = newsize.height
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.ratingTableHtCnst?.constant = self.ratingTableView.contentSize.height
        self.questionTableHtCnst?.constant = self.questionTableView.contentSize.height
       
       // self.SimilarHeightConstraint?.constant = self.similarProductCollectionView.contentSize.height


        
    }
    @IBAction func closeBtnAction(_ sender: UIButton)
    {
        self.QuantityPopUpView.removeFromSuperview()
        
        
    }
    @IBAction func cartBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "MyCartVC") as? MyCartVC
        self.navigationController?.pushViewController(myVC!, animated: true)
        
        
    }
    @IBAction func BackBtnAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func writereviewBtnAction(_ sender: UIButton)
    {
       
    }
    @IBAction func AddtTOBagBtnAction(_ sender: UIButton)
    {
        let dict = self.detailarray[0] as! NSDictionary
        let SizeDict = self.SizeArray[0] as? [String:Any]
        
        let quantity = SizeDict!["stock_quantity"] as?  String
        if quantityTF.text != ""{
        let textfieldInt: Int? = Int(quantityTF.text!)
        
        let quantityInt: Int? = Int(quantity!)
        if (textfieldInt! > quantityInt!)
        {
            self.QuantityPopUpView.frame = self.view.frame
            self.view .addSubview(self.QuantityPopUpView)
            self.quantitypopLbl.text = String(format : "%@ Pieces only available. please choose the quantity accordingly.",SizeDict!["stock_quantity"] as! String)
            return
        }
        
        addtobag()
        }
        else{
            self.view.makeToast("Add quantity")
        }
    }
        
       func addtobag()
       {
        let dict = self.detailarray[0] as! NSDictionary
        let selectedRow = self.polishTF.selectedRow
        let sizeselectedRow = self.sizeTF.selectedRow
        var optionID : String!
        var optionValueID : String!
        var isOPtionsAvailable : Bool = false
        var PolishID : String!
        var PolishValueID : String!
        var isPolishValueAvailable : Bool = false
        
        let polish = dict["polish"] as? AnyObject
        let size =  dict["size"] as? AnyObject
        
        if(polish as? String == "null" && size as? String == "null")
        {
        }
        else{
            var polishArray = dict["polish"] as? NSArray
            if((polishArray?.count)! > 0)
            {
                if (selectedRow < 0){
                           self.view.makeToast("add valid Polish Style")
                    return
                       }
                else{
                var polishDict = polishArray![selectedRow] as? NSDictionary
                PolishID = polishDict!["product_option_id"] as? String
                PolishValueID = polishDict!["product_option_value_id"] as? String
                isOPtionsAvailable = true
                }
            }
        }
        if(size as? String == "null" && size as? String == "null")
        {
        }
        else{
            var SizeArray = dict["size"] as? NSArray
            if((SizeArray?.count)! > 0)
            {
                if (sizeselectedRow < 0){
                           self.view.makeToast("add valid size")
                    return
                       }
                else{
                var sizeDict = SizeArray![sizeselectedRow] as? NSDictionary
                optionID = sizeDict!["product_option_id"] as? String
                optionValueID = sizeDict!["product_option_value_id"] as? String
                isOPtionsAvailable = true
                }
            }
        }
        
        
        
       
        SKActivityIndicator.show("Loading...")
        let Url =  String(format: "%@api/cart/add&api_token=api/cart/products&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        var parameters: Parameters = [:]
        if(isOPtionsAvailable)
        {
            parameters = [
                "customer_id" : userID ?? "",
                "product_id" : ProductID ?? "",
                "quantity" : self.quantityTF.text ?? "",
                "product_option_id" : optionID ?? "",
                "product_option_value_id" : optionValueID ?? "",
                "product_option_id_polish" : PolishID ?? "",
                "product_option_value_id_polish" : PolishValueID ?? "",
                "buy_now_flag" :"0"
            ]
        }
        else{
            parameters = [
                "customer_id" : userID ?? "",
                "product_id" : self.ProductID ?? "",
                "quantity" : "1",
            ]
        }
        print (parameters)
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
                            self.view.makeToast(JSON["message"] as? String)
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let myVC = storyboard.instantiateViewController(withIdentifier: "MyCartVC") as? MyCartVC
                            self.navigationController?.pushViewController(myVC!, animated: true)

                            
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
    @IBAction func ShopNowBtnAction(_ sender: UIButton)
    {
        let dict = self.detailarray[0] as! NSDictionary
        let SizeDict = self.SizeArray[0] as? [String:Any]
        let quantity = SizeDict!["stock_quantity"] as? String
        
        if(self.quantityTF.text == "")
        {
            self.view.makeToast("Please Enter Quantity")
            return
            
        }
        
        if (self.quantityTF.text)! > quantity!
        {
            self.QuantityPopUpView.frame = self.view.frame
            self.view .addSubview(self.QuantityPopUpView)
            self.quantitypopLbl.text = String(format : "%@ Pieces only available. please choose the quantity accordingly.",SizeDict!["stock_quantity"] as! String)
            return
        }
        
        getshopnow()
    }
    func getshopnow()
    {
            let dict = self.detailarray[0] as! NSDictionary
            let selectedRow = self.polishTF.selectedRow
            let sizeselectedRow = self.sizeTF.selectedRow
            var optionID : String!
            var optionValueID : String!
            var isOPtionsAvailable : Bool = false
            var PolishID : String!
            var PolishValueID : String!
            var isPolishValueAvailable : Bool = false

            let polish = dict["polish"] as? AnyObject
            let size =  dict["size"] as? AnyObject
        
        if (sizeselectedRow < 0){
            self.view.makeToast("add valid ")
        }
        else{
            if(polish as? String == "null" && size as? String == "null")
            {
            }
            else{
                var polishArray = dict["polish"] as? NSArray
                if((polishArray?.count)! > 0)
                {
                    var polishDict = polishArray![selectedRow] as? NSDictionary
                    PolishID = polishDict!["product_option_id"] as? String
                    PolishValueID = polishDict!["product_option_value_id"] as? String
                    isOPtionsAvailable = true
                }
            }
            if(size as? String == "null" && size as? String == "null")
            {
            }
            else{
                var SizeArray = dict["size"] as? NSArray
                if((SizeArray?.count)! > 0)
                {
                    
                    var sizeDict = SizeArray![sizeselectedRow] as? NSDictionary
                    optionID = sizeDict!["product_option_id"] as? String
                    optionValueID = sizeDict!["product_option_value_id"] as? String
                    isOPtionsAvailable = true
                }
    
            }
    }
           SKActivityIndicator.show("Loading...")
            let Url =  String(format: "%@api/cart/add&api_token=api/cart/products&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
            print(Url)
            let userID =  UserDefaults.standard.string(forKey: "customer_id")
            var parameters: Parameters = [:]
            if(isOPtionsAvailable)
            {
                parameters = [
                    "customer_id" : userID ?? "",
                    "product_id" : ProductID ?? "",
                    "quantity" : self.quantityTF.text ?? "",
                    "product_option_id" : optionID ?? "",
                    "product_option_value_id" : optionValueID ?? "",
                    "product_option_id_polish" : PolishID ?? "",
                    "product_option_value_id_polish" : PolishValueID ?? "",
                    "buy_now_flag" :"1"
                ]
            }
            else{
                parameters = [
                    "customer_id" : userID ?? "",
                    "product_id" : self.ProductID ?? "",
                    "quantity" : "1",
                ]
            }
            print (parameters)
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
                                self.view.makeToast(JSON["message"] as? String)
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let myVC = storyboard.instantiateViewController(withIdentifier: "ShippingVC") as? ShippingVC
                                myVC?.type = "shopnow";
                            self.navigationController?.pushViewController(myVC!, animated: true)


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
    @IBAction func speceficationSelectClk(_ sender: UISegmentedControl) {
        
        //webView.removeFromSuperview()
        textView.removeFromSuperview()

        switch sender.selectedSegmentIndex {
        case 0:
            SpecificationDetailView.addSubview(webView)
            if(htmlString != ""){
            loadHTMLContent(htmlString)
            }
            webView.isHidden = false
            //webView.reload()
        case 1:
            webView.isHidden = true
            SpecificationDetailView.addSubview(textView)
            textView.text = productDesc
            textView.isUserInteractionEnabled = false
            let fixedWidth = textView.frame.size.width
            textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var newFrame = textView.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            textView.frame = newFrame
            speceficationDetailCnst.constant = textView.frame.height
            
        default:
            print("error")
        }
        
        
        
        
        
    }
    
    
    
    
    
    @IBOutlet weak var ratingDetailLblWidthCnst: NSLayoutConstraint!
    
    
    func hideRatingView(){
        
        ratingDetailLblWidthCnst.constant=0
        userRatingDetailLabel.text = "Be the first one to rate."
        seperator1Cnst.constant = 0
        
        
    }
    @IBOutlet weak var questionLblHtCnst: NSLayoutConstraint!
    func hideQuestionView(){
        questionLblHtCnst.constant = 0
       // searchTFHtCnst.constant = 0
        //searchBtnHt.constant = 0
        seperator3Cnst.constant = 0
        
    }
   
    
    
    func setUpDetailView(){

       specificationSegment.setEnabled(true, forSegmentAt: 0)
        SpecificationDetailView.addSubview(webView)
        if(htmlString != ""){
            loadHTMLContent(htmlString)
        }


    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
            self.speceficationDetailCnst.constant = height as! CGFloat
            self.webViewHtConstraint?.constant = height as! CGFloat
        })


    }
    func loadHTMLContent(_ htmlContent: String) {
        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></HEAD><BODY>"
        let htmlEnd = "</BODY></HTML>"
        let htmlString = "\(htmlStart)\(htmlContent)\(htmlEnd)"
        print("htmelString:",htmlString)
        webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
    }
    
    func getOrderDetail()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@product/productdetails/productdetailsForAndroid",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        var id : String = ""
        if(self.isSimilarProducts)
        {
            id = self.relatedID as String
        }
        else{
            id = self.ProductID as String
        }
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "product_id" : id
        ]
        //        let parameters: Parameters =
        //            [
        //                "customer_id" : "4",
        //                "product_id" : "41"
        //        ]
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
                            // self.getsimilarProducts()
                            self.detailarray = (JSON["result"] as? NSArray)!
                            let dict = self.detailarray[0] as! NSDictionary
                            
                            self.productNameLbl.text = dict["name"] as? String
                            self.HeaderNameLbl.text = dict["name"] as? String
                            
                            self.mainRatingLbl.text = dict["rating"] as? String
                            self.ratingDetailLbl.text = dict["rating"] as? String
                            self.userRatingLbl  .text = dict["users_rating"] as? String
                            self.userRatingDetailLabel  .text = dict["users_rating"] as? String
                            let offer = dict["offer"]
                            if offer as? String == "null" || offer as? String == "0"
                            {
                                self.offLbl.isHidden = true
                            }
                            else
                            {
                                self.offLbl.isHidden = false
                                self.offLbl.text = dict["offer"] as? String
                                self.offLbl.text = String(format : "%@ %off",dict["offer"] as! String)
                            }
                            
                            //                            let offerPrice = rupee + String(discountPrice) + " " + String(dict!["offer"] as! String) + " % off"
                            //                            let offerPrice =  String(format : "%@",dict["offer"] as! String)
                            //                            self.offLbl.text = String(dict["offer"] as! String) + " % off"
                            //                            cell.offerPriceText.attributedText = self.makeAttributedString(text: offerPrice, linkTextWithColor: rupee + String(discountPrice))
                            //offLbl
                            
                            //    if(dict["wishlist_status"] as? Int == 1)
                            //    {
                            //    self.mWishlistBtn .setTitle("Added to Wishlist", for: .normal)
                            //    }
                            //    else
                            //    {
                            //    self.mWishlistBtn .setTitle("Add to Wishlist", for: .normal)
                            //    }
                            
                            let priceSting = String(format : "%@",dict["price"] as? String ?? "")
                            let priceDouble =  Double (priceSting)
                            if((priceDouble) != nil)
                            {
                                self.priceLbl.text = String(format : "₹%.2f",priceDouble!)
                            }
                            var discount = String(format : "%@",dict["discount_price"] as? String ?? "")
                            if(discount == "null" || discount == "0")
                            {
                                self.discountLbl.isHidden == true
                            }
                            else
                            {
                                let discountSting = String(format : "%@",dict["discount_price"] as? String ?? "")
                                let discountDouble =  Double (discountSting)
                                if((discountDouble) != nil)
                                {
                                    discount = String(format : "₹%.2f",discountDouble!)
                                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                                    self.discountLbl.attributedText = attributeString
                                }
                                
                            }
                            //
                            self.htmlString = dict["product_specification"] as! String
                            self.productDesc = dict["description"] as! String
                            if  self.productDesc == "null" {
                                self.productDesc = "description not available"
                            }
                            
                            self.setUpDetailView()
                            
                            
                            
                            
                            
                            //    self.mPrdSpecificationLabel.attributedText = htmlStr.convertHtml()
                            //       // self.DetailsViewHeight.constant = self.DetailsView.bounds.size.height
                            //    self.mPrdDetailDes.text = dict["description"] as? String
                            //self.DetailsViewHeight.constant = self.DetailsView.bounds.size.height
                            
                            
                            //self.ContentHeight.constant = 170 + self.RatingViewHeight.constant + self.SimilarHeight.constant + self.QuestionViewHeight.constant + self.DetailsViewHeight.constant
                            
                            //self.descriptionHeight.constant = self.mDescriptionLabel.bounds.size.height
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            self.bannerArray = (dict["image"] as? NSArray)!
                            self.wishListStatus = dict["wishlist_status"] as! String
                            self.bannerCollectionView.reloadData()
                            self.pageControl.numberOfPages = self.bannerArray.count
                            let resultSimilarProducts = JSON["similar_product"]as? AnyObject
                            if(resultSimilarProducts as? String == "null")
                            {
                                self.SimilarHeightConstraint.constant = 0
                                self.SimilarHeight.constant = 0
                                self.ViewAllHeight.constant = 0
                                self.SimilarProductViewAll.isHidden = true
                                self.similarProductCollectionView.reloadData()
                            }
                            else
                            {
                                self.SimilarProductViewAll.isHidden = false
                                
                                self.similarArray = (JSON["similar_product"]  as?[[String:Any]])!
                                self.similarProductCollectionView.reloadData()
                            }
                            let result = JSON["review_list"]as? AnyObject
                            if(result as? String == "null")
                            {
                                self.hideRatingView()
                            }
                            else{
                                self.tempRatingArray = (JSON["review_list"]  as?[[String:Any]])!
                                
                                
                                if self.tempRatingArray.count > 4{
                                    
                                    self.RatingsArray.append(self.tempRatingArray[0])
                                    self.RatingsArray.append(self.tempRatingArray[1])
                                    self.RatingsArray.append(self.tempRatingArray[2])
                                    self.RatingsArray.append(self.tempRatingArray[3])
                                    
                                }
                                else{
                                    self.RatingsArray = self.tempRatingArray
                                }
                                
                                self.ratingTableView.reloadData()
                            }
                            
                            
                            let tempValue1 = dict["polish"]
                            if tempValue1 as? String == "null"{
                                
                            }
                            else{
                                let polishArray = dict["polish"] as? NSArray
                                self.PolArray = dict["polish"] as! NSArray
                                if((polishArray?.count)! > 0)
                                {
                                    var polishnameArray = [String]()
                                    
                                    for polishDict in polishArray! {
                                        let size = (polishDict as AnyObject).object(forKey: "name") as? String
                                        polishnameArray.append(size!)
                                    }
                                    print("polishArray=\(polishnameArray)")
                                    
                                    self.polishTF.itemList = polishnameArray
                                    self.polishTF.selectedRow = 1
                                    
                                }
                            }
                            let tempValue2 = dict["size"]
                            if tempValue2 as? String == "null"{
                                
                            }
                            else{
                                self.SizeArray = (dict["size"] as? NSArray)!
                                if((self.SizeArray.count) > 0)
                                {
                                    var SizenameArray = [String]()
                                    
                                    for sizeDict in self.SizeArray {
                                        let size = (sizeDict as AnyObject).object(forKey: "name") as? String
                                        SizenameArray.append(size!)
                                    }
                                    print("SizeArray=\(SizenameArray)")
                                    
                                    self.sizeTF.itemList = SizenameArray
                                    self.sizeTF.selectedRow = 1
                                    let SizeDict = self.SizeArray[0] as? [String:Any]
                                    self.weightTF.text = SizeDict!["weight"] as? String
                                    
                                    let quantity = SizeDict!["stock_quantity"] as? String
                                    
                                }
                            }
                            
                            let tempValue3 = JSON["question_answer"]
                            if tempValue3 as? String == "null"{
                                self.hideQuestionView()
                            }
                            else{
                                
                                
                                
                                self.tempQuestionArray = (JSON["question_answer"]  as?[[String:Any]])!
                                
                                
                                
                                if self.tempQuestionArray.count > 4{
                                    
                                    self.QuestionsArray.append(self.tempQuestionArray[0])
                                    self.QuestionsArray.append(self.tempQuestionArray[1])
                                    self.QuestionsArray.append(self.tempQuestionArray[2])
                                    self.QuestionsArray.append(self.tempQuestionArray[3])
                                    
                                }
                                else{
                                    
                                    self.QuestionsArray = self.tempQuestionArray
                                }
                                self.questionTableView.reloadData()
                            }
                        }
                        else
                        {
                            self.view.makeToast(JSON["message"] as? String)
                            
                        }
                    }
                    break
                    
                case .failure( let  error):
                    print(error)
                    break
                    
                    
                }
        }
    }
    
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
                            self.CartCountlLabel.text = JSON["data"] as? String
                            if(self.CartCountlLabel.text == "0")
                            {
                                self.CartCountlLabel.isHidden = true
                            }
                            else
                            {
                                self.CartCountlLabel.isHidden = false
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
    // MARK: - Collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection
        section: Int) -> Int {
        
        if(collectionView == self.bannerCollectionView)
        {
            return self.bannerArray.count
        }
        else if(collectionView == self.similarProductCollectionView)
        {
            return self.similarArray.count
        }
//        else if(collectionView == self.mSimilarProductsCollectionView)
//        {
//            return self.similarArray.count
//        }
        return 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var defaultCell : UICollectionViewCell!
        if(collectionView == self.bannerCollectionView)
         {
            let cell: SliderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
            let dict = self.bannerArray[indexPath.row] as? NSDictionary
            var image = dict!["image"] as? String
            if(image != nil){
                image = image?.replacingOccurrences(of: " ", with: "%20")
                cell.mSliderImageView.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "placeholder"))
            }
            let dict2 = self.detailarray[0] as! NSDictionary
//                   cell.slideofferLbl.layer.cornerRadius = cell.slideofferLbl.bounds.width / 2
//                  cell.slideofferLbl.text = String(format : "%@ %%off",dict2["offer"] as! String)
//            let dict2 = self.detailarray[0] as! NSDictionary
            let offer2 = dict2["offer"]
            if offer2 as? String == "null" || offer2 as? String == "0"
            {
                cell.slideofferLbl.isHidden = true
            }
            else
            {
                cell.slideofferLbl.isHidden = false
                //cell.offerLbl.text = dict?["offer"] as? String
                cell.slideofferLbl.layer.cornerRadius = cell.slideofferLbl.bounds.width / 2
                cell.slideofferLbl.text = String(format : "%@ %%off",dict2["offer"] as! String)
            }
            
            
            
            cell.Sharebtn.addTarget(self, action: #selector(sharebtnClk), for: .touchUpInside)
            
            
            if(self.wishListStatus == "1")
            {
                cell.likebtn.setBackgroundImage(UIImage(named: "Like-pink"), for: .normal)
            }
            else
            {
                cell.likebtn.setBackgroundImage(UIImage(named: "LikeWhite"), for: .normal)
            }
            
            
            cell.likebtn.addTarget(self, action: #selector(likebtnclk), for: .touchUpInside)
            
            //                let detaildict = self.detailarray[0] as! NSDictionary
            //                if(detaildict["wishlist_status"] as? Int == 1)
            //                {
            //                    cell.wishListImage.image = UIImage(named: "Like")
            //                }
            //                else
            //                {
            //                    cell.wishListImage.image = UIImage(named: "AddWishlist")
            //                }
            //                cell.mBgView.layer.shadowColor = UIColor.darkGray.cgColor
            //                cell.mBgView.layer.shadowOffset = CGSize(width: 1, height:3)
            //                cell.mBgView.layer.shadowOpacity = 0.6
            //                cell.mBgView.layer.shadowRadius = 3.0
            //                cell.mBgView.layer.cornerRadius = 5.0
            //
            return cell
        }
        else if(collectionView == self.similarProductCollectionView)
        {
            let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
            
            cell.productContainerView.layer.shadowColor = UIColor.darkGray.cgColor;                cell.productContainerView.layer.shadowOffset = CGSize(width: 1, height:3)
            cell.productContainerView.layer.shadowOpacity = 0.6
            cell.productContainerView.layer.shadowRadius = 3.0
            cell.productContainerView.layer.cornerRadius = 5.0
            
            let dict = self.similarArray[indexPath.row] as? NSDictionary
            var image = dict!["image"] as? String
            if(image != nil){
                image = image?.replacingOccurrences(of: " ", with: "%20")
                cell.productImageView.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "category"))
            }
            cell.productTitleLabel.text = dict!["name"] as? String
            
            let priceSting = String(format : "%@",dict!["price"] as? String ?? "")
            let priceDouble =  Double (priceSting)
            if((priceDouble) != nil)
            {
                cell.actualPriceText.text = String(format : "₹%.2f",priceDouble!)
            }
            // cell.mGramTF.text = String(format : "%@ Grams",dict!["quantity"] as? String ?? "")
            var discount = String(format : "%@",dict!["discount_price"] as? String ?? "")
            if(discount == "null")
            {
                
            }
            else
            {
                let discountSting = String(format : "%@",dict!["discount_price"] as? String ?? "")
                let discountDouble =  Double (discountSting)
                if((discountDouble) != nil)
                {
                    discount = String(format : "₹%.2f",discountDouble!)
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                    cell.offerPriceText.attributedText = attributeString
                    cell.rating.text = dict!["body"] as? String
                    cell.userRating.text = dict!["firstname"] as? String
                }
                cell.rating.text = String(dict!["rating"] as! String)+" ⃰"
                cell.userRating.text = dict!["users_rating"] as? String
                
            }
            //
            return cell
        }
        
        return defaultCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if(collectionView == self.bannerCollectionView)
        {
            return CGSize(width: Constants.SCREEN_WIDTH, height: collectionView.bounds.size.height)
        }
        
        if(collectionView == self.similarProductCollectionView )
        {
            return CGSize(width: 160, height: 200)
        }
        
        
        
        //        else if(collectionView == self.mDealCollectionView || collectionView == self.mCategoryCollectionView || collectionView == self.mRecommendedCollectionView)
        //        {
        //           return CGSize(width: 140, height: 150)
        //        }
        //        else if(collectionView == self.mlayout1CollectionView)
        //        {
        //             return CGSize(width: self.view.frame.size.width/2 - 10, height: 140)
        //        }
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
    @objc func sharebtnClk(){
        
        let originalString = "https://itunes.apple.com/app/id1484627646"
        
        var objectsToShare = [AnyObject]()
        objectsToShare.append("Let me recommend you this application" as AnyObject)
        
        objectsToShare.append(originalString as AnyObject)
        
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    @objc func likebtnclk(){
        
        let dict = self.detailarray[0] as! NSDictionary
        
        
        let productID = dict["product_id"] as! String
        SKActivityIndicator.show("Loading...")
        var Url =  ""
        if(dict["wishlist_status"] as? String == "1")
        {
            Url = String(format: "%@account/wishlist/removeWishList",Constants.BASEURL)
        }
        else
        {
            Url = String(format: "%@account/wishlist/insertWishList",Constants.BASEURL)
        }
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "product_id" : productID
        ]
        
        print (parameters)
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
                            self.view.makeToast(JSON["message"] as? String)
                            self.getOrderDetail()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.ratingTableView)
        {
           
            
            
            if self.RatingsArray.count>=4 && !isRatingExpanded{
                return self.RatingsArray.count+1

            }
            else{
                return self.RatingsArray.count

            }
            
        }
        else if(tableView == self.questionTableView)
        {
            
            if self.QuestionsArray.count>=4 && !isQuestionExpanded{
                return self.QuestionsArray.count+1

            }
            else{
                return self.QuestionsArray.count

            }
            
        }
        
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var defaultCell : UITableViewCell!
        
        if(tableView == self.ratingTableView)
        {
            if indexPath.row < self.RatingsArray.count{
            let cell: ProductDetailRatingTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "ProductDetailRatingTableViewCell", for: indexPath) as!ProductDetailRatingTableViewCell
            let dict = self.RatingsArray[indexPath.row] as? NSDictionary
            
            
            var image1 = dict!["image1"] as? String

            if image1 == "null"{
                cell.image1HtConst.constant = 0
            }
            else{
                
                
            image1 = image1?.replacingOccurrences(of: " ", with: "%20")
                    cell.image1.sd_setImage(with: URL(string: image1 ?? "" ), placeholderImage:nil)
            
            var image2 = dict!["image2"] as? String
            image2 = image2?.replacingOccurrences(of: " ", with: "%20")
            cell.image2.sd_setImage(with: URL(string: image2 ?? "" ), placeholderImage:nil)
            
            var image3 = dict!["image3"] as? String
            image3 = image3?.replacingOccurrences(of: " ", with: "%20")
            cell.image3.sd_setImage(with: URL(string: image3 ?? "" ), placeholderImage:nil)
            
            var image4 = dict!["image4"] as? String
            image4 = image4?.replacingOccurrences(of: " ", with: "%20")
            cell.image1.sd_setImage(with: URL(string: image4 ?? "" ), placeholderImage:nil)
            
            }
            
            
            cell.mRatingTitleLabel.text = dict!["title"] as? String
            cell.mRatingDateLbl.text = dict!["date_added"] as? String
            cell.mRatingDesLbl.text = dict!["feedback"] as? String
            cell.mRatingLbl.text = dict!["rating"] as? String
            cell.mRatingNameLbl.text = dict!["firstname"] as? String
            cell.mRatinglikes.text = dict!["count_like"] as? String
            cell.mRatingDislikes.text = dict!["count_dislike"] as? String
//            cell.mRatingDesLbl.text = "Subjects to ecstatic children he. Could ye leave up as built match. Dejection agreeable attention set suspected led offending. Admitting an performed supposing by. Garden agreed matter are should formed temper had. Full held gay now roof whom such next was. Ham pretty our people moment put excuse narrow. Spite mirth money six above get going great own. Started now shortly had for assured hearing expense. Led juvenile his laughing speedily put pleasant relation offering."

            return cell
            }
            else{
                let cell:UITableViewCell =  (tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell?)!
                
                // set the text from the data model
                cell.textLabel?.text = "All Review"
                cell.textLabel?.textColor = UIColor.darkGray
                cell.textLabel?.font = UIFont(name: Constants.FONTNAME as String, size: 13)
               
                return cell
            }
            
        }
        else if(tableView == self.questionTableView)
        {
            
              if indexPath.row < self.QuestionsArray.count{
            let cell: ProductQuestionTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "ProductQuestionTableViewCell", for: indexPath) as!ProductQuestionTableViewCell
            print("ques index",indexPath.row)
            let dict = self.QuestionsArray[indexPath.row] as? [String:Any]
          
            cell.answerLabel.text = String(format: "Ans: %@",dict!["answer"] as? String ?? "Not Available")
            //cell.mDateLabel.text = dict!["date_added"] as? String
            cell.questionLabel.text = String(format: "Que: %@",dict!["question"] as? String ?? "Not Available")
            
            cell.likeLabel.text = dict!["count_like"] as?String
            cell.unlikeLabel.text = dict!["count_dislike"] as?String


            // cell.mAnswerLabel.text = dict!["firstname"] as? String
            return cell
            }
              else{
                let cell:UITableViewCell =  (tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell?)!

                // set the text from the data model
                cell.textLabel?.text = "All Review"
                cell.textLabel?.textColor = UIColor.darkGray
                cell.textLabel?.font = UIFont(name: Constants.FONTNAME as String, size: 13)

                return cell
            }
            
        }
        return defaultCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.ratingTableView{
            if indexPath.row == RatingsArray.count && !isRatingExpanded{
                self.RatingsArray.removeAll()
                self.RatingsArray = self.tempRatingArray
                isRatingExpanded = true
                self.ratingTableView.reloadData()
            }
        }
        if tableView == self.questionTableView{
            if indexPath.row == QuestionsArray.count && !isQuestionExpanded{
                self.QuestionsArray.removeAll()
                self.QuestionsArray = self.tempQuestionArray
                isQuestionExpanded = true
                self.questionTableView.reloadData()
            }
        }
        
        
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    //    {
    //        if(collectionView == self.BannerCollectionView)
    //        {
    //            return CGSize(width: 320, height: collectionView.bounds.size.height)
    //        }
    //        else if(collectionView == self.mSimilarProductsCollectionView)
    //        {
    //            return CGSize(width: 320, height: 150)
    //        }
    //        return CGSize(width: 0, height: 0)
    //    }
    //
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        if(tableView == self.mRatingsTableView)
    //        {
    //            return 150
    //        }
    //        else if(tableView == self.mQuestionTableView)
    //        {
    //            return 150
    //        }
    //        return 0
    //    }
   // MARK: IQDropdown delegate
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        
//        print ("Tag=\(textField.tag)")
//
//        if(textField.tag == 100)
//        {
//
//            print ("textFieldTag=\(textField.tag)")
//            print ("item=\(textField.selectedRow)")
//            if (textField.selectedRow == -1) {
//                textField.selectedRow = 1
//            }
//            let selectedRow = textField.selectedRow
//            let path = IndexPath(row: textField.tag, section: 0)
//            var dict : NSDictionary!
//            dict = self.SizeArray[selectedRow] as! NSDictionary
//            let priceSting = String(format : "%@",dict["price"] as? String ?? "")
//            let priceDouble =  Double (priceSting)
//            if((priceDouble) != nil)
//            {
//                self.priceLbl.text = String(format : "₹%.2f",priceDouble!)
//            }
//            var discount = String(format : "%@",dict["discount_price"] as? String ?? "")
//            if(discount == "null" || discount == "0")
//            {
//
//            }
//            else
//            {
//                let discountSting = String(format : "%@",dict["discount_price"] as? String ?? "")
//                let discountDouble =  Double (discountSting)
//                if((discountDouble) != nil)
//                {
//                    discount = String(format : "₹%.2f",discountDouble!)
//                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
//                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
//                    self.discountLbl.attributedText = attributeString
//                }
//            }
//        }
        
        if textField == sizeTF{
            
            let selectedRow = textField.selectedRow
            
            print("selected row ",selectedRow)
            
            if(selectedRow >= 0){
            
            let SizeDict = self.SizeArray[selectedRow] as? [String:Any]
            
            
            weightTF.text = SizeDict!["weight"] as? String
            // priceLbl.text = SizeDict!["price"] as? String
            //discountLbl.text = SizeDict!["discount_price"] as? String
            
            let priceSting = String(format : "%@",SizeDict!["price"] as? String ?? "")
            let priceDouble =  Double (priceSting)
            if((priceDouble) != nil)
            {
                self.priceLbl.text = String(format : "₹%.2f",priceDouble!)
            }
            var discount = String(format : "%@",SizeDict!["discount_price"] as? String ?? "")
            if(discount == "null" || discount == "0")
            {
                
            }
            else
            {
                let discountSting = String(format : "%@",SizeDict!["discount_price"] as? String ?? "")
                let discountDouble =  Double (discountSting)
                if((discountDouble) != nil)
                {
                    discount = String(format : "₹%.2f",discountDouble!)
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                    self.discountLbl.attributedText = attributeString
                }
                
            }
            
            }
            
            
            
        }
        if textField == polishTF{
            
            let selectedRow = textField.selectedRow
             if(selectedRow >= 0){
            
            let SizeDict = self.PolArray[selectedRow] as? [String:Any]
            
            
            //  weightTF.text = SizeDict!["weight"] as? String
            let priceSting = String(format : "%@",SizeDict!["price"] as? String ?? "")
            let priceDouble =  Double (priceSting)
            if((priceDouble) != nil)
            {
                self.priceLbl.text = String(format : "₹%.2f",priceDouble!)
            }
            var discount = String(format : "%@",SizeDict!["discount_price"] as? String ?? "")
            if(discount == "null" || discount == "0")
            {
                
            }
            else
            {
                let discountSting = String(format : "%@",SizeDict!["discount_price"] as? String ?? "")
                let discountDouble =  Double (discountSting)
                if((discountDouble) != nil)
                {
                    discount = String(format : "₹%.2f",discountDouble!)
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                    self.discountLbl.attributedText = attributeString
                }
                
            }
        }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
 func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if tableView == self.ratingTableView{
    
        return 397
    }
    if tableView == self.questionTableView{
        return 147
    }
    return 0
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
