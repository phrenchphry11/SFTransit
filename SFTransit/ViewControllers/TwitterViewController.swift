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

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        let swifter = Swifter(consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret, appOnly: true)
        swifter.authorizeAppOnlyWithSuccess({ (accessToken, response) -> Void in
            self.twitterIsAuthenticated = true
            swifter.getSearchTweetsWithQuery("#bart",
                success: { (statuses, searchMetadata) -> Void in
                    self.tweets = Tweet.tweetsWithArray(statuses!)
                    self.tableView.reloadData()
                    println("count: \(self.tweets!.count)")
                },
                failure: { (error) -> Void in
                    println(error)
                })
            },
            failure: { (error) -> Void in
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

extension TwitterViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension TwitterViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        if let tweets = tweets {
            if count(tweets) > indexPath.row {
                let tweet = tweets[indexPath.row]
                cell.setTweet(tweet)
            }
        }
        return cell
    }
}
