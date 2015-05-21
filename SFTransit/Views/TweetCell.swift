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

        var font = UIFont.getLato(.Regular, fontSize: 13.0)
        nameLabel.font = font
        usernameLabel.font = font
        timeLabel.font = font
        messageLabel.font = font

        pictureView.layer.cornerRadius = 3
        pictureView.clipsToBounds = true

        timeLabel.textColor = UIColor.myGrayColor()
        usernameLabel.textColor = UIColor.myGrayColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setTweet(tweet: Tweet) {
        if let user = tweet.user {
            usernameLabel.text = "@\(user.screenName!)"
            nameLabel.text = user.name
            var imageURL = NSURL(string: user.profileImageUrl!)
            pictureView.loadAsync(imageURL!, animate: true, failure: nil)
        }
        messageLabel.text = tweet.text
        if let createdAt = tweet.createdAt {
            timeLabel.text = NSDate.shortTimeAgoSince(createdAt)
        } else {
            timeLabel.text = ""
        }
        timeLabel.sizeToFit()
    }
}
