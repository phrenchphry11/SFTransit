//
//  Tweet.swift
//  SFTransit
//
//  Created by Amie Kweon on 5/19/15.
//  Copyright (c) 2015 Holly French. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: Int?
    var user: TweetUser?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweet: Bool = false
    var favorited: Bool = false

    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? Int
        user = TweetUser(dictionary: (dictionary["user"] as? NSDictionary)!)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        if let favorited = dictionary["favorited"] as? Bool {
            self.favorited = favorited
        }
    }

    init(json: JSONValue) {
        id = json["id"].integer
        user = TweetUser(json: json["user"])
        text = json["text"].string
        createdAtString = json["created_at"].string
        if let createdAtString = createdAtString {
            var formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.dateFromString(createdAtString)
        }
    }

    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }

    class func tweetsWithArray(array: [JSONValue]) -> [Tweet] {
        var tweets = [Tweet]()
        for json in array {
            tweets.append(Tweet(json: json))
        }
        return tweets
    }

}