//
//  ActionRequestHandler.swift
//  ContentBlocker
//
//  Created by Ludovic Balogh on 12.09.15.
//  Copyright © 2015 Ludovic Balogh. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequestWithExtensionContext(context: NSExtensionContext) {
        let containerURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(kAppGroupIdentifier)
        let jsonURL = NSURL(fileURLWithPath: containerURL!.path! + "/" + kFilterFilename)
        
        let attachment = NSItemProvider(contentsOfURL: jsonURL)!
    
        let item = NSExtensionItem()
        item.attachments = [attachment]
    
        context.completeRequestReturningItems([item], completionHandler: nil);
    }
    
}
