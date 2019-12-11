//
//  PayUVC.swift
//  Nisarga
//
//  Created by Hari Krish on 17/08/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import SKActivityIndicatorView
import Alamofire
import SDWebImage
import Toast_Swift
import PlugNPlay

class PayUVC: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var mWebView: UIWebView!
    let TestEnvironment = 1
    var merchantKey = ""
    var salt = ""
    var PayUBaseUrl = ""
    var hashKey: String! = nil
    var amountPayable = String()
    let productInfo = "Jewelry"
    let firstName = "Kaviya"
    let email = "Kaviyashetty18@gmail.com"
    let phone = "8682867295"
    let successUrl = "https://www.payumoney.com/mobileapp/payumoney/successs.php"   //Success URL
    let failureUrl = "https://www.payumoney.com/mobileapp/payumoney/failuree.php"   //Failure URL
    let service_provider = "payu_paisa"
    var txnid1: String! = ""    //a unique id for specific order number.
    var type : String!
    var paymenttype = Int()
    var shopnow : String!
    var status : String = ""
    var paymentstatus : String!
    var orderid : String!
    var totalpayable = String()
    override func viewDidLoad() {
        if #available(iOS 13, *){
                     let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
                     statusBar.backgroundColor = UIColor(red:0.98, green:0.17, blue:0.61, alpha:1.0)
                     UIApplication.shared.keyWindow?.addSubview(statusBar)
                 }
        else {
            UIApplication.shared.statusBarView?.backgroundColor = UIColor(red:0.98, green:0.17, blue:0.61, alpha:1.0)
        }
        
        print("amount",amountPayable)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(TestEnvironment == 1)
        {
//            self.merchantKey = "6TsK9kaI"
//            self.salt = "Twb7XPbHtZ"
//            self.merchantKey = "kYz2vV"
//            self.salt = "zhoXe53j"
            self.PayUBaseUrl = "https://test.payu.in"
            
            self.merchantKey = "H2hGKpQw"
            self.salt = "KmSD8dcq9c"

            

            
        }
        else
        {
            self.merchantKey = "H2hGKpQw"
            self.salt = "KmSD8dcq9c"
            self.PayUBaseUrl = "https://test.payu.in"
        }
//      self.merchantKey = "rjQUPktU"
//       self.salt = "e5iIg1jwi8"
        
        mWebView.delegate = self
        //SKActivityIndicator.show("Loading...")
        initPayment()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Mark: - Btn Action
    @IBAction func backBtnAction(_ sender: Any)
    {
        if(self.type == "shopnow")
        {
            buybackbutton()
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // Mark: Pay U
    func initPayment() {
        //Creating taxation id with timestamp
        txnid1 = "Jewelry\(String(Int(NSDate().timeIntervalSince1970)))"
        
        //Generating Hash Key
        let hashValue = String.localizedStringWithFormat("%@|%@|%@|%@|%@|%@|||||||||||%@",merchantKey,txnid1,amountPayable,productInfo,firstName,email,salt)
        let hash=self.sha1(string: hashValue)
        

//        let postStr = "txnid="+txnid1+"&key="+merchantKey+"&amount="+totalPriceAmount+"&productinfo="+productInfo+"&firstname="+firstName+"&email="+email+"&phone="+phone+"&surl="+successUrl+"&furl="+failureUrl+"&hash="+hash+"&service_provider="+service_provider
//
//
//        let postData = postStr.data(using: .ascii, allowLossyConversion: true)
//
//        let postLength = String(format: "%lu", UInt(postData?.count ?? 0))
//        let request = NSMutableURLRequest()
//        request.url = URL(string: PayUBaseUrl)
//        request.httpMethod = "POST"
//        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Current-Type")
//        request.httpBody = postData
//
//        self.mWebView.loadRequest(request as URLRequest)
        let txnParam = PUMTxnParam()
        //Set the parameters
        txnParam.phone = phone
        txnParam.email = email
        txnParam.amount = amountPayable
        txnParam.environment = .test
        txnParam.firstname = firstName
        txnParam.key = merchantKey
        txnParam.merchantid = "6774592"
        txnParam.txnID = txnid1
        txnParam.surl = successUrl
        txnParam.furl = failureUrl
        txnParam.productInfo = productInfo
        txnParam.udf1 = "udf1"
        txnParam.udf2 = "udf2"
        txnParam.udf3 = "udf3"
        txnParam.udf4 = "udf4"
        txnParam.udf5 = "udf5"
        txnParam.udf6 = "udf6"
        txnParam.udf7 = "udf7"
        txnParam.udf8 = "udf8"
        txnParam.udf9 = "udf9"
        txnParam.udf10 = "udf10"
        txnParam.hashValue = generateHash(txnParam, salt: salt)
        
        PlugNPlay.presentPaymentViewController(withTxnParams: txnParam, on: self, withCompletionBlock: { paymentResponse, error, extraParam in
            SKActivityIndicator.dismiss()
            
            if error != nil {
                UIUtility.toastMessage(onScreen: error?.localizedDescription)
                self.paymentstatus = "failure"
            } else {
                var message = ""
                if paymentResponse?["result"] != nil && (paymentResponse?["result"] is [AnyHashable : Any]) {
                    print(paymentResponse!)
                   // message = "Hello Asad sucess"
                    self.paymentstatus = "success"
                    //                    message = paymentResponse?["result"]?["error_Message"] as? String ?? ""
                    //                    if message.isEqual(NSNull()) || message.count == 0 || (message == "No Error") {
                    //                        message = paymentResponse?["result"]?["status"] as? String ?? ""
                    //                    }
                } else {
                    message = paymentResponse?["status"] as? String ?? ""
                }
                self.getpayment()
                UIUtility.toastMessage(onScreen: message)
            }
        })
        
        
        
        
        
  

    }
    
    func sha1(string:String) -> String {
        let cstr = string.cString(using: String.Encoding.utf8)
        let data = NSData(bytes: cstr, length: string.characters.count)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA512_DIGEST_LENGTH))
        CC_SHA512(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = digest.map { String(format: "%02x", $0) }
        return hexBytes.joined(separator: "")
    }
    func generateHash(_ txnParam: PUMTxnParam, salt: String) -> String {
        let hashSequence = "\(txnParam.key!)|\(txnParam.txnID!)|\(txnParam.amount!)|\(txnParam.productInfo!)|\(txnParam.firstname!)|\(txnParam.email!)|\(txnParam.udf1!)|\(txnParam.udf2!)|\(txnParam.udf3!)|\(txnParam.udf4!)|\(txnParam.udf5!)|\(txnParam.udf6!)|\(txnParam.udf7!)|\(txnParam.udf8!)|\(txnParam.udf9!)|\(txnParam.udf10!)|\(salt)"
        
        let hash = createSHA512(hashSequence).replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        
        return hash
    }
    
    func createSHA512(_ string: String) -> String{
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        if let data = string.data(using: String.Encoding.utf8) {
            let value =  data as NSData
            CC_SHA512(value.bytes, CC_LONG(data.count), &digest)
            
        }
        var digestHex = ""
        for index in 0..<Int(CC_SHA512_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
    }
    
    
    
    
    
    

    // Mark: - Webview
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SKActivityIndicator.dismiss()
        let requestURL = self.mWebView.request?.url
        let requestString:String = (requestURL?.absoluteString)!
         print(requestString)
        if requestString.contains("https://www.payumoney.com/mobileapp/payumoney/success.php") {
            print("success payment done")
            self.paymentstatus = "success"
            
        }else if requestString.contains("https://www.payumoney.com/mobileapp/payumoney/failure.php") {
            print("payment failure")
            self.paymentstatus = "failure"
        }
        self.getpayment()
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SKActivityIndicator.dismiss()
        let requestURL = self.mWebView.request?.url
        print("WebView failed loading with requestURL: \(requestURL) with error: \(error.localizedDescription) & error code: \(error)")
        
        if error._code == -1009 || error._code == -1003 {
            showAlertView(string: "Please check your internet connection!")
        }else if error._code == -1001 {
            showAlertView(string: "The request timed out.")
        }
    }
    
    func showAlertView(string: String) {
        let alertController = UIAlertController(title: "Alert", message: string, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){
            (result : UIAlertAction) -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK:- API
    func getpayment()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/payment/onlinePayment",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        //let OrderID =  UserDefaults.standard.string(forKey: "order_id")
        
        
        let parameters: Parameters =
        [
            "customer_id" : userID ?? "",
            "order_id" : orderid!,
            "amount" : amountPayable ,
            "payment_mode" : service_provider,
            "payment_type" : paymenttype,
            "payment_status" : self.paymentstatus ,
            "payment_transaction_id" : txnid1
            
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
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "PayNowSuccessVC") as! PayNowSuccessVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else
                        {
                             self.view.makeToast(JSON["message"] as? String)
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "PaynowFailureVC") as! PaynowFailureVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    break

                case .failure(let error):
                    print(error)
                    break

                }
        }
    }
    func buybackbutton()
    {
        
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/cart/updateBuyNowStatustInCart",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        //    let OrderID =  UserDefaults.standard.string(forKey: "order_id")
        //    let ShippingCountryID = UserDefaults.standard.string(forKey: "shipping_country_id")
        //    let ShippingZoneID = UserDefaults.standard.string(forKey: "shipping_zone_id")
        //    let userID =  UserDefaults.standard.string(forKey: "customer_id")
        //    let sessionID =  UserDefaults.standard.string(forKey: "api_token")
        
        let parameters: Parameters =
            [
                
                "customer_id" : userID ?? "",
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
                            self.view.makeToast(JSON["message"] as? String)
                        }
                        else
                        {
                            
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
