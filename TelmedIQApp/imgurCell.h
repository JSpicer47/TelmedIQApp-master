/** @file imgurCell.h
 *  @brief A custom cell that contains a bunch of bits from an imgur gallery
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
 A custom cell that contains a bunch of bits from an imgur gallery
 */
@interface imgurCell : BaseProfileCell
{
    IBOutlet UILabel *title;
    IBOutlet UILabel *nsfw;
    IBOutlet UILabel *score;
    IBOutlet UILabel *link;
    IBOutlet UILabel *datetime;
    
    imgObject *myObject;
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
 @param[in] inObject - the object we get data from (and potentially add data to)
 */
- (void)setUpCell:(imgObject*)inObject;

@end
