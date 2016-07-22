//
//  DetailViewController.m
//  TelmedIQApp
//
//  Created by John Spicer on 2016-07-20.
//  Copyright © 2016 John Spicer. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Utilities.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize favoriteToggle;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem = newDetailItem;
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem)
    {
        self.detailDescriptionLabel.text = self.detailItem.title;
        
        NSTimeInterval seconds = [self.detailItem.datetime integerValue];
        NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM dd, yyyy h:mm a"];
        self.datetime.text = [dateFormatter stringFromDate:epochNSDate];
        
        NSInteger iScore = [self.detailItem.score integerValue];
        self.score.text = [NSString stringWithFormat:@"%ld", (long)iScore];
        
        self.link.text = self.detailItem.link;
        
        // use the opposite to set it in one step
        isFavorite = ![self.detailItem.favorite boolValue];
        [self toggleFavorite:self];
        
        bool notSafe = [self.detailItem.nsfw boolValue];
        if (notSafe == 0)
        {
            self.nsfw.text = @"NO";
        }
        else
        {
            self.nsfw.text = @"YES";
        }

        // if we already have the image, just show it.
        if (self.detailItem.myBigImage != nil)
        {
            UIImage *goodImage = [UIImage imageWithData:self.detailItem.myBigImage];
            self.bigImage.image = goodImage;
            [self.view setNeedsDisplay];
            [self.active setHidden:YES];
        }
        else
        {
            [self fetchImage];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Fetch

// Fetch the image in the background
//
- (void)fetchImage
{
    NSString *urlStr = self.detailItem.link;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void)
    {
        // if our link has a .gif or .jpg on the end,
        // we can get an image.
        // if it does not, we won't get anything at all,
        // so just put the stock image in it.
        // my assumption here is that we show the ACTUAL image
        // if it's NSFW

        UIImage *defaultImage = [UIImage imageNamed:@"Shrimp153.png"];
        BOOL good = YES;

        NSData *data0;
        UIImage *goodImage = nil;
        NSString *fileType = nil;
        if (urlStr != nil && good)
        {
            NSString *name = [urlStr lastPathComponent];
            //DLog(@"name = %@", name);
            NSArray *bits = [name componentsSeparatedByString:@"."];
            // if it has an ending at all, we're good
            if ([bits count] > 1)
            {
                NSURL *theURL = [NSURL URLWithString:urlStr];
                data0 = [NSData dataWithContentsOfURL:theURL];
                goodImage = [UIImage imageWithData:data0];
                fileType = [bits objectAtIndex:1];
                if (goodImage == nil)
                {
                    good = NO;
                }
            }
            else
            {
                //DLog(@"it's not something we can load!");
                good = NO;
            }
        }

        if (good == NO)
        {
            data0 = UIImagePNGRepresentation(defaultImage);
        }

        dispatch_async(dispatch_get_main_queue(),
        ^{
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            self.detailItem.myBigImage = data0;
            [realm commitWriteTransaction];

            self.bigImage.image = [UIImage imageWithData:data0];
            [self.view setNeedsDisplay];
            [self.active setHidden:YES];
        });

    });
}

#pragma mark - Action Methods

- (IBAction)toggleFavorite:(id)sender
{
    isFavorite = !isFavorite;
    
    // set the right image
    if (isFavorite == YES)
    {
        [Utilities setImage:[UIImage imageNamed:@"checkbox_hl.png"] forAllButtonStates:favoriteToggle];
    }
    else
    {
        [Utilities setImage:[UIImage imageNamed:@"checkbox_bg.png"] forAllButtonStates:favoriteToggle];
    }
    
    // update our item in the DB
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    self.detailItem.favorite = [NSNumber numberWithBool:isFavorite];
    [realm commitWriteTransaction];

}

@end
