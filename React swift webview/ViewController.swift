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
            let promiseId = String(describing: messageBody.value(forKey: "promiseId" )!);

            switch(functionToRun) {
            case "getCurrentVersion":
                getCurrentVersion(promiseId: promiseId);
            default:
                return {}();
            }
        }
    }

    func executeJavascript(_ functionToRun:String, arguments:Array<String>?) {
        var function:String;
        var args:String;

        if (arguments != nil) {
            args = arguments!.joined(separator: ", ");
        } else {
            args = "";
        }

        function = "\(functionToRun)(\(args))";
        self.webView!.evaluateJavaScript(function, completionHandler: handleJavascriptCompletion as? (Any?, Error?) -> Void);
    }

    func currentVersion() -> String {
        return "'0.0.1'";
    }
    
    func getCurrentVersion(promiseId: String) {
        executeJavascript("resolvePromise", arguments:[promiseId, currentVersion()])
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
