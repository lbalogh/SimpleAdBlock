//
//  ViewController.swift
//  SimpleAdBlock
//
//  Created by Ludovic Balogh on 12.09.15.
//  Copyright © 2015 Ludovic Balogh. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    @IBOutlet weak var updateButton: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    @IBAction func updateButtonPressed(sender: AnyObject)
    {
        self.enableUpdateButton(false)
        
        let url = NSURL(string: kEasyListDownloadURL)!
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        var downloadTask = NSURLSessionDownloadTask()
        downloadTask = session.downloadTaskWithRequest(request)
            {
                (url, response, error) in
                if error != nil
                {
                    self.showAlert("Error", message: "Error downloading file : \(error)")
                    self.enableUpdateButton(true)
                    return
                }

                let containerURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(kAppGroupIdentifier)
                let jsonPath = containerURL!.path! + "/" + kFilterFilename
                
                if NSFileManager.defaultManager().fileExistsAtPath(jsonPath)
                {
                    do
                    {
                        try NSFileManager.defaultManager().removeItemAtPath(jsonPath)
                    }
                    catch let error as NSError
                    {
                        self.showAlert("Error", message: "Error deleting file : \(error)")
                        self.enableUpdateButton(true)
                        return
                    }
                }
                
                do
                {
                    try NSFileManager.defaultManager().moveItemAtPath(url!.path!, toPath: jsonPath)
                }
                catch let error as NSError
                {
                    self.showAlert("Error", message: "Error copying file : \(error)")
                    self.enableUpdateButton(true)
                    return
                }
                
                SFContentBlockerManager.reloadContentBlockerWithIdentifier(kContentBlockerIdentifier, completionHandler: {
                    (NSError error) in
                    if error == nil
                    {
                        self.showAlert(nil, message: "Filter list updated")
                        
                    }
                    else
                    {
                        self.showAlert("Error", message: "Error loading filter list : \(error)")
                    }
                    
                    self.enableUpdateButton(true)
                })

        }
        
        downloadTask.resume()
    }
    
    func showAlert(title: String?, message: String?)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        
        dispatch_async(dispatch_get_main_queue())
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func enableUpdateButton(enabled: Bool)
    {
        dispatch_async(dispatch_get_main_queue())
        {
            self.updateButton.enabled = enabled
        }
    }
}
