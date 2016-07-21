/** @file TextViewProfileCell.h
 *  @brief A custom cell that contains a multiline text box and a title
 *
 *  Copyright (c) 2014 MobileLive.ca
 *
 *  @author John Spicer
 *  @bug No known bugs.
 */

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "MasterViewController.h"
#import "BaseProfileCell.h"

@class imgObject;

// Important fields to display in the list are title, link, datetime, score and nsfw.

/**
 A custom cell that contains a multiline text box and a title
 */
@interface TextViewProfileCell : BaseProfileCell
{
    IBOutlet UILabel *title;
    IBOutlet UILabel *nsfw;
    IBOutlet UILabel *score;
    IBOutlet UILabel *link;
    IBOutlet UILabel *datetime;
}

@property IBOutlet UIImageView *myImage;
@property IBOutlet UIActivityIndicatorView *active;

- (IBAction)gotoDetailsPage:(id)sender;

/**
 Standard class method
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

/**
 Configure the cell
 @param[in] inOwner - the owning table
 */
- (void)setUpCell:(imgObject*)inDict;

@end
