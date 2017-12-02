//
//  ViewController.swift
//  Swift web hybrid template
//
//  Created by Willson Smith on 2015-11-09.
//
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKScriptMessageHandler {

//    var webView: WKWebView?
    @IBOutlet weak var webView: WKWebView!

    override func loadView() {
        super .loadView();
        let contentController = WKUserContentController();
        contentController.add(self, name: "callbackHandler");

        let config = WKWebViewConfiguration();
        config.userContentController = contentController;

        webView = WKWebView(frame: self.view.frame, configuration: config);
        webView.uiDelegate = self as? WKUIDelegate;
        view = webView;
    }

    override func viewDidLoad() {
        super.viewDidLoad();

        // enable developer tools in webview
        self.webView?.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")


        // let url = Bundle.main.url(forResource: "index", withExtension:"html");
        // self.webView!.loadFileURL(url!, allowingReadAccessTo: url!);
        let url = NSURL(string: "http://localhost:3000")! as URL;
        self.webView.load(URLRequest(url: url));
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let messageBody:NSDictionary = message.body as? NSDictionary {
            let functionToRun = String(describing: messageBody.value(forKey: "functionToRun")!);
            switch(functionToRun) {
            case "getCurrentVersion":
                getCurrentVersion();
            default:
                return {}();
            }
        }
    }

    func executeJavascript(_ functionToRun:String, argument:String?) {
        var functionName:String;
        var arg:String;
        if ((argument) != nil) {
            arg = argument!;
        } else {
            arg = "";
        }

        functionName = "\(functionToRun)('\(arg)')";
        self.webView!.evaluateJavaScript(functionName, completionHandler: handleJavascriptCompletion as? (Any?, Error?) -> Void);
    }

    func currentVersion() -> String {
        return "Swift iOS web hybrid template 1.0.0";
    }
    
    func getCurrentVersion() {
//        return (currentVersion());
        executeJavascript("addVersion", argument:currentVersion())
    }

    func handleJavascriptCompletion(_ object:AnyObject?, error:NSError?) -> Void {
        if (error != nil) {
            print(error as Any);
        }
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning();
//        // Dispose of any resources that can be recreated.
//    }

}
