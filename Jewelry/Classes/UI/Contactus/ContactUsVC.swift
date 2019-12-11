//
//  ContactUsVC.swift
//  Nisagra
//
//  Created by Apple on 27/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView
import WebKit
//extension String {
//    var htmlToAttributedString: NSAttributedString? {
//        guard let data = data(using: .utf8) else { return NSAttributedString() }
//        do {
//            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
//        } catch {
//            return NSAttributedString()
//        }
//    }
//    var htmlToString: String {
//        return htmlToAttributedString?.string ?? ""
//    }
//}
//extension String{
//    func convertHtml() -> NSAttributedString{
//        guard let data = data(using: .utf8) else { return NSAttributedString() }
//        do{
//
//            return try NSAttributedString(data: data, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
//        }catch{
//            return NSAttributedString()
//        }
//    }
//}

class ContactUsVC: UIViewController,UIWebViewDelegate, WKNavigationDelegate {

    @IBOutlet weak var mWebView: UIWebView!
    @IBOutlet weak var mHeaderLabel : CustomFontLabel!
    var screenType : String!
    var contactText : String!
    @IBOutlet weak var mDescriptionLabel : CustomFontLabel!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    var webViewHtConstraint: NSLayoutConstraint?
    var htmlString = String()
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
        

        // Do any additional setup after loading the view.
        if(self.screenType == "About")
        {
            self.mHeaderLabel.text = "About & Contact us"
        }
        else if(self.screenType == "Terms")
        {
            self.mHeaderLabel.text = "Terms & Conditions"
        }
        else if(self.screenType == "Policy")
        {
            self.mHeaderLabel.text = "Policy"
        }
        else if(self.screenType == "FAQ")
        {
            self.mHeaderLabel.text = "FAQ"
        }
        else if(self.screenType == "Delivery")
        {
            self.mHeaderLabel.text = "Delivery Information"
        }
        webView.frame  = CGRect(x: 0, y: 0, width: contentView.frame.width, height: 100)
        webView.navigationDelegate = self
        //webView.scrollView.isScrollEnabled = false;
        contentView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: mDescriptionLabel.topAnchor, constant: 0).isActive = true
        webView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        webView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        contentViewHeight = webView.heightAnchor.constraint(equalToConstant: 200)
        contentViewHeight?.isActive = true
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadHTMLContent(_ htmlContent: String) {
        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></HEAD><BODY>"
        let htmlEnd = "</BODY></HTML>"
        let htmlString = "\(htmlStart)\(htmlContent)\(htmlEnd)"
        print("htmelString:",htmlString)
        webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
    }
    
    // MARK:- Btn Action
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - API
    
    func getData()
    {
        
        var id : String!
        if(self.screenType == "About")
        {
            id = "4"
        }
      if(self.screenType == "ContactUs")
        {
            id = "4"
        }
        else if(self.screenType == "Terms")
        {
            id = "5"
        }
        else if(self.screenType == "Policy")
        {
            id = "3"
        }
      else if(self.screenType == "FAQ")
      {
        id = "7"
        }
      else if(self.screenType == "Delivery")
      {
        id = "6"
        }
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/custom/pages",Constants.BASEURL)
        print(Url)
        let parameters: Parameters =
        [
                "id" : id ?? ""
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
                            let resultArray = (JSON["result"] as? NSArray)!
                            let dict = resultArray[0] as! NSDictionary
                            if(self.screenType == "About")
                            {
                                self.mDescriptionLabel.text = dict["title"] as? String
                                self.htmlString = dict["desciption"] as! String
                               // self.contactText = String(format:"%@ %@",dict["title"] as! String,dict["desciption"] as! String)
                                self.screenType = "ContactUs"
                                //self.getData()
                            }
                            else if(self.screenType == "ContactUs")
                            {
                                self.mDescriptionLabel.text = dict["title"] as? String
                                self.htmlString = dict["desciption"] as! String
                                //self.screenType = "ContactUs"
                                //self.getData()
                                //let htmlStr = String(format: "%@%@%@",self.contactText,dict["title"] as! String,dict["desciption"] as! String)
                               // self.mDescriptionLabel.attributedText = htmlStr.convertHtml()
                                //self.mDescriptionLabel.sizeToFit()
                                //self.descriptionHeight.constant = self.mDescriptionLabel.bounds.size.height
                            }
                            else if(self.screenType == "Terms")
                            {
                                
                                self.mDescriptionLabel.text = dict["title"] as? String
                                self.htmlString = dict["desciption"] as! String
                                //self.screenType = "ContactUs"
                               // self.getData()
                               // let htmlStr = dict["desciption"] as! String
                               // self.mDescriptionLabel.attributedText = htmlStr.convertHtml()
                                //self.mDescriptionLabel.sizeToFit()
                                //self.descriptionHeight.constant = self.mDescriptionLabel.bounds.size.height
                                //let descStr = dict["description"] as? String ?? ""
                                //print(descStr)
                                //self.mWebView.loadHTMLString(descStr, baseURL: nil)
                            }
                            else if(self.screenType == "Policy")
                            {
                                
                                self.mDescriptionLabel.text = dict["title"] as? String
                                self.htmlString = dict["desciption"] as! String
                                //self.screenType = "ContactUs"
                                //self.getData()
                                // let htmlStr = dict["desciption"] as! String
                                // self.mDescriptionLabel.attributedText = htmlStr.convertHtml()
                                //self.mDescriptionLabel.sizeToFit()
                                //self.descriptionHeight.constant = self.mDescriptionLabel.bounds.size.height
                                //let descStr = dict["description"] as? String ?? ""
                                //print(descStr)
                                //self.mWebView.loadHTMLString(descStr, baseURL: nil)
                            }
                            else if(self.screenType == "FAQ")
                            {
                                
                                self.mDescriptionLabel.text = dict["title"] as? String
                                self.htmlString = dict["desciption"] as! String
                               // self.screenType = "ContactUs"
                                //self.getData()
                                // let htmlStr = dict["desciption"] as! String
                                // self.mDescriptionLabel.attributedText = htmlStr.convertHtml()
                                //self.mDescriptionLabel.sizeToFit()
                                //self.descriptionHeight.constant = self.mDescriptionLabel.bounds.size.height
                                //let descStr = dict["description"] as? String ?? ""
                                //print(descStr)
                                //self.mWebView.loadHTMLString(descStr, baseURL: nil)
                            }
                            else if(self.screenType == "Delivery")
                            {
                                
                                self.mDescriptionLabel.text = dict["title"] as? String
                                self.htmlString = dict["desciption"] as! String
                               // self.screenType = "ContactUs"
                               // self.getData()
                                // let htmlStr = dict["desciption"] as! String
                                // self.mDescriptionLabel.attributedText = htmlStr.convertHtml()
                                //self.mDescriptionLabel.sizeToFit()
                                //self.descriptionHeight.constant = self.mDescriptionLabel.bounds.size.height
                                //let descStr = dict["description"] as? String ?? ""
                                //print(descStr)
                                //self.mWebView.loadHTMLString(descStr, baseURL: nil)
                            }
                            
                            
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
