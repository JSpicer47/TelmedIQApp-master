//
//  MasterViewController.h
//  TelmedIQApp
//
//  Created by John Spicer on 2016-07-20.
//  Copyright © 2016 John Spicer. All rights reserved.
//

#import "Realm/Realm.h"
#import <UIKit/UIKit.h>

// Realm model object
@interface imgObject : RLMObject
@property NSString *id;
@property NSString *title;
@property NSString *link;
@property NSNumber<RLMBool> *nsfw;
@property NSNumber<RLMBool> *favorite;
@property NSNumber<RLMInt> *account_id;
@property NSNumber<RLMInt> *score;
@property NSNumber<RLMInt> *datetime;
@property NSData *mySmallImage;
@property NSData *myBigImage;
@end


@class DetailViewController;

@interface MasterViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIActivityIndicatorView *theBigSpinner;       /**< This shows until we get some results back */
    
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@property NSArray                   *gallery;              /**< The fetched list of gallieries */
//@property NSMutableArray            *galleryImages;        /**< The images for the above galleries */

@property (nonatomic, strong) RLMResults *galleryArray;


@end

