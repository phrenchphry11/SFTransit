//
//  UIImageView+Utils.swift
//  SFTransit
//
//  Created by Amie Kweon on 5/19/15.
//  Copyright (c) 2015 Holly French. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadAsync(url:NSURL, animate: Bool = true,
        failure: ((request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void)?) {
            weak var weakSelf = self

            var request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 5)
            self.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) -> Void in
                var isCached = request == nil
                if !isCached && animate {
                    if let weakSelf = weakSelf {
                        weakSelf.alpha = 0.0
                        weakSelf.image = image
                        UIView.animateWithDuration(0.5, animations: { () -> Void in
                            weakSelf.alpha = 1.0
                        })
                    }
                } else {
                    weakSelf?.image = image
                }
                }, failure: failure)
    }
}
