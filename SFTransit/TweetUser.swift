//
//  TweetUser.swift
//  SFTransit
//
//  Created by Amie Kweon on 5/19/15.
//  Copyright (c) 2015 Holly French. All rights reserved.
//

import UIKit

class TweetUser: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var bannerImageUrl: String?
    var friendsCount: Int?
    var followersCount: Int?
    var tweetsCount: Int?

    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        bannerImageUrl = dictionary["profile_banner_url"] as? String
        friendsCount = dictionary["friends_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        tweetsCount = dictionary["statuses_count"] as? Int
    }

    init(json: JSONValue) {
        name = json["name"].string
        screenName = json["screen_name"].string
        profileImageUrl = json["profile_image_url"].string
        tagline = json["description"].string
        bannerImageUrl = json["profile_banner_url"].string
        friendsCount = json["friends_count"].integer
        followersCount = json["followers_count"].integer
        tweetsCount = json["statuses_count"].integer
    }
}
