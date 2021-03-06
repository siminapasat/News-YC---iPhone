//
//  HNPostsCollectionCell.swift
//  HN
//
//  Created by Ben Gordon on 9/9/14.
//  Copyright (c) 2014 bennyguitar. All rights reserved.
//

import UIKit

let HNPostsCollectionCellIdentifier = "HNPostsCollectionCellIdentifier"


protocol HNPostsCellDelegate {
    func didSelectComments(index: Int)
}

class HNPostsCollectionCell: UITableViewCell {
    @IBOutlet var cellTitleLabel : UILabel!
    @IBOutlet var cellAuthorLabel : UILabel!
    @IBOutlet var cellPointsLabel : UILabel!
    @IBOutlet weak var cellBottomBar: UIView!
    @IBOutlet weak var commentBubbleButton: UIButton!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var commentButtonOverlay: UIButton!
    var index: Int = -1
    var del: HNPostsCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }
    
    func setContentWithPost(post: HNPost?, indexPath: NSIndexPath?, delegate: HNPostsCellDelegate) {
        index = indexPath!.row
        del = delegate
        cellAuthorLabel.attributedText = postSecondaryAttributedString("\(post!.TimeCreatedString) by \(post!.Username)", matches:post!.Username)
        cellTitleLabel.attributedText = postPrimaryAttributedString(post!.Title)
        cellBottomBar.backgroundColor = HNTheme.currentTheme().colorForUIElement(HNTheme.ThemeUIElement.Bar)
        commentBubbleButton.setImage(HNTheme.currentTheme().imageForCommentBubble(), forState: UIControlState.Normal)
        commentCountLabel.text = "\(post!.CommentCount)"
        commentBubbleButton.addTarget(self, action: "didSelectCommentsButton", forControlEvents: UIControlEvents.TouchUpInside)
        commentButtonOverlay.addTarget(self, action: "didSelectCommentsButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Alphas
        commentBubbleButton.alpha = 0.25
        commentCountLabel.alpha = 1.0
        cellTitleLabel.alpha = HNTheme.currentTheme().markAsReadIsActive() && HNManager.sharedManager().hasUserReadPost(post) ? 0.5 : 1.0
        //commentCountLabel.textColor = HNOrangeColor
        
        // UI Coloring
        // Show HN posts contain "Show HN:" in the title
        // Other posts do not.  Jobs posts are of type PostType.Jobs
        let t = NSString(string: post!.Title)
        if (t.contains("Show HN:")) {
            // Show HN
            backgroundColor = HNTheme.currentTheme().colorForUIElement(HNTheme.ThemeUIElement.ShowHNBackground)
            cellBottomBar.backgroundColor = HNTheme.currentTheme().colorForUIElement(HNTheme.ThemeUIElement.ShowHNBar)
        }
        else {
            // Jobs Post
            if (post?.Type == PostType.Jobs) {
                backgroundColor = HNTheme.currentTheme().colorForUIElement(HNTheme.ThemeUIElement.JobsBackground)
                cellBottomBar.backgroundColor = HNTheme.currentTheme().colorForUIElement(HNTheme.ThemeUIElement.JobsBar)
                commentBubbleButton.alpha = 0.0
                commentCountLabel.alpha = 0.0
                cellAuthorLabel.attributedText = postSecondaryAttributedString("HN Jobs", matches: nil)
            }
            // Normal
            else {
                backgroundColor = HNTheme.currentTheme().colorForUIElement(HNTheme.ThemeUIElement.BackgroundColor)
            }
        }
        
        // Backgrounds
        cellTitleLabel.backgroundColor = backgroundColor
        cellAuthorLabel.backgroundColor = cellBottomBar.backgroundColor
        commentCountLabel.textColor = HNTheme.currentTheme().colorForUIElement(HNTheme.ThemeUIElement.MainFont)
        
        // Set Edge Insets
        if (self.respondsToSelector(Selector("layoutMargins"))) {
            layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func postPrimaryAttributedString(t: String!) -> NSAttributedString {
        return NSAttributedString(string: t, attributes: [NSForegroundColorAttributeName:HNTheme.currentTheme().colorForUIElement(HNTheme.ThemeUIElement.MainFont),NSFontAttributeName:UIFont.systemFontOfSize(14.0),NSParagraphStyleAttributeName:NSParagraphStyle.defaultParagraphStyle()])
    }
    
    func postSecondaryAttributedString(text: String!, matches: String?) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName:HNTheme.currentTheme().colorForUIElement(HNTheme.ThemeUIElement.SubFont),NSFontAttributeName:UIFont.systemFontOfSize(11.0)])
    }
    
    func didSelectCommentsButton() {
        del?.didSelectComments(index)
    }
}
