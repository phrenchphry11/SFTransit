//
//  TweetCell.swift
//  SFTransit
//
//  Created by Amie Kweon on 5/19/15.
//  Copyright (c) 2015 Holly French. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var retweetSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pictureTopSpacingConstraint: NSLayoutConstraint!

    var didSetupConstraints = false

    override func awakeFromNib() {
        super.awakeFromNib()

        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero

        pictureView.layer.cornerRadius = 3
        pictureView.clipsToBounds = true

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setTweet(tweet: Tweet) {
//        if let user = tweet.user {
//            usernameLabel.text = "@\(user.screenName!)"
//            nameLabel.text = user.name
//            var imageURL = NSURL(string: user.profileImageUrl!)
//            pictureView.loadAsync(imageURL!, animate: true, failure: nil)
//        }
//        messageLabel.text = tweet.text
//        timeLabel.text = tweet.createdAt?.shortTimeAgoSinceNow()
//        if tweet.retweet && !tweet.retweetedByCurrentUser {
//            if let retweeter = tweet.retweetUser {
//                retweetLabel.text = "\(retweeter.name!) retweeted"
//            }
//            retweetSpacingConstraint.constant = 22
//            pictureTopSpacingConstraint.constant = 22
//            retweetLabel.hidden = false
//        } else {
//            retweetLabel.text = ""
//            retweetSpacingConstraint.constant = 0
//            pictureTopSpacingConstraint.constant = 0
//            retweetLabel.hidden = true
//        }
    }
}
