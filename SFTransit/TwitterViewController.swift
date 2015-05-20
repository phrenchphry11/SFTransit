//
//  TwitterViewController.swift
//  SFTransit
//
//  Created by Amie Kweon on 5/19/15.
//  Copyright (c) 2015 Holly French. All rights reserved.
//

import UIKit

let twitterConsumerKey = "tl2Av403xlyFF1MsPsAoXKA7Q"
let twitterConsumerSecret = "DBm4OMnrVHKVNIeQsLr88cNvQBIPjSeyy0kZDiwNXDNB9A1lHv"
let twitterURL = NSURL(string: "https://api.twitter.com")

class TwitterViewController: UIViewController {

    var twitterIsAuthenticated = false
    var tweets: [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()

        let swifter = Swifter(consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret, appOnly: true)
        swifter.authorizeAppOnlyWithSuccess({ (accessToken, response) -> Void in
            self.twitterIsAuthenticated = true
            swifter.getSearchTweetsWithQuery("test", success: { (statuses, searchMetadata) -> Void in
                // TODO: statuses is [JSONValue] and it needs to be parsed in Tweet class
                //self.tweets = Tweet.tweetsWithArray(statuses as! [NSDictionary])
                println(statuses)
                }) { (error) -> Void in
                    println(error)
            }

            }, failure: { (error) -> Void in
                println("Error Authenticating: \(error.localizedDescription)")
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
