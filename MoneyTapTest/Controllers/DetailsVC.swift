//
//  DetailsVC.swift
//  MoneyTapTest
//
//  Created by Divum on 09/09/18.
//  Copyright © 2018 Murali. All rights reserved.
//

import UIKit
import WebKit

class DetailsVC: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    
    var searchText:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let searchText = self.searchText{
            print("self.searchText : "+searchText)
            self.title = searchText
            let newString = searchText.replacingOccurrences(of: " ", with: "_")
            let urlString = "https://en.wikipedia.org/wiki/"+newString
            let url = URL(string: urlString)
            webView.navigationDelegate = self
            webView.load(URLRequest(url: url!))
            webView.allowsBackForwardNavigationGestures = true
        }
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
