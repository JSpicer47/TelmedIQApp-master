//
//  DetailViewController.h
//  TelmedIQApp
//
//  Created by John Spicer on 2016-07-20.
//  Copyright © 2016 John Spicer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

@class imgObject;

@interface DetailViewController : UIViewController
{
    bool isFavorite;                                                   /**< If true, its a favorite */
}

@property (strong, nonatomic) imgObject *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *link;
@property (weak, nonatomic) IBOutlet UILabel *datetime;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *nsfw;
@property (weak, nonatomic) IBOutlet UIButton *favoriteToggle;
@property (weak, nonatomic) IBOutlet UIImageView *bigImage;

@property IBOutlet UIActivityIndicatorView *active;

- (IBAction)toggleFavorite:(id)sender;

@end

