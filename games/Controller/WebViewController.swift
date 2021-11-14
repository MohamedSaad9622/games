//
//  WebViewController.swift
//  games
//
//  Created by MAC on 14/11/2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var url : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let webUrl = url {
            if let urlRequest = URL(string: webUrl){
                webView.load(URLRequest(url: urlRequest))
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

}
