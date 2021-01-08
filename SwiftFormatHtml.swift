//
//  TestoLiberoController.swift
//  Genio21
//
//  Created by Fabio Cirruto on 15/07/2019.
//  Copyright © 2019 Dieffetech. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class MioController: UIViewController, WKNavigationDelegate, WKUIDelegate, SFSafariViewControllerDelegate {

    @IBOutlet var webView: WKWebView!
    var height : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //setto i vari delegate e propietà alla mia view
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.delegate = self
        webView.uiDelegate = self
        //richiamo la mia funzione
        loadHTMLContent("<b>Ciao</b>", webView, "#FFFFFF", "#000000")
    }
    //se premono su un link href della webview lo apro in un SFSafariViewController
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            if let url = navigationAction.request.url {
                let safariVc = SFSafariViewController(url: url)
                safariVc.preferredBarTintColor = Config.primaryColor
                safariVc.preferredControlTintColor = .white
                safariVc.delegate = self
                present(safariVc, animated: true, completion: nil)
            }
        }
        return nil
    }
    //siccome uso un font custom lo stetto tramite il font face
    private func loadHTMLContent(_ htmlContent: String, _ webView: WKWebView, _ color: String, _ textColor: String) {
        let htmlStart = """
        <HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"><base target="_blank"></HEAD><BODY><style>
        @font-face {
            font-family: "Raleway";
            font-weight: normal;
            src: url("Raleway-Regular.ttf")
        }
        @font-face {
            font-family: "Raleway";
            font-style: italic;
            src: url("Raleway-Italic.ttf")
        }
        @font-face {
            font-family: "Raleway";
            font-weight: bold;
            src: url("Raleway-Medium.ttf")
        }
        body {
            background-color: \(color);
            margin: 0px;
            font-family: "Raleway";
            font-weight: normal;
            font-size: 12pt;
            color: \(textColor);
            margin-right: 8px;
            margin-left: 8px;
        }
        </style>
        """
        let htmlEnd = "</BODY></HTML>"
        let htmlString = "\(htmlStart)\(htmlContent)\(htmlEnd)"
        webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //con questa funzione recupero l'altezza della web view in base al contenuto, sarebbe ottimale fare il refresh dell'interfaccia
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (heightScroll, error) in
            self.height = heightScroll as! CGFloat
        })
    }
}
