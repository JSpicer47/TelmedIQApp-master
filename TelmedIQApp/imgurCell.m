/** @file imgurCell.m
 *  @brief A custom cell that contains an image and some bits from an imgur gallery
 *
 *  Copyright (c) 2016 John Spicer
 *
 *  @author John Spicer
 *  @bug No known bugs.
 */

#import "AppDelegate.h"
#import "imgurCell.h"

@implementation imgurCell

@synthesize myImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)setUpCell:(imgObject*)inDict
{    
    [super setUpCell];
    //DLog(@"inDict = %@", [inDict description]);
    myObject = inDict;
    
    title.text = myObject.title;

    NSTimeInterval seconds = [myObject.datetime integerValue];
    NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy h:mm a"];
    datetime.text = [dateFormatter stringFromDate:epochNSDate];
    
    NSInteger iScore = [myObject.score integerValue];
    score.text = [NSString stringWithFormat:@"%ld", (long)iScore];
    
    link.text = myObject.link;
    
    bool notSafe = [myObject.nsfw boolValue];
    if (notSafe == 0)
    {
        nsfw.text = @"NO";
    }
    else
    {
        nsfw.text = @"YES";
    }

    // if we already have the image, just show it.
    if (myObject.mySmallImage != nil)
    {
        UIImage *goodImage = [UIImage imageWithData:myObject.mySmallImage];
        myImage.image = goodImage;
        [self.active setHidden:YES];
        [self setNeedsDisplay];
    }
    else
    {
        [self fetchImage];
    }

}

// this is a workaround since segues won't work if you have a custom cell.
// go figure.
// a bug I hope Apple will soon fix!
//
- (IBAction)gotoDetailsPage:(id)sender
{
    //DLog(@"button pressed!");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToDetailsView" object:[NSNumber numberWithInteger:self.tag]];
}

// Fetch the image in the background
//
- (void)fetchImage
{
    NSString *urlStr = myObject.link;
    BOOL bNSFW = [myObject.nsfw boolValue];
    //DLog(@"urlStr = %@", urlStr);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void)
    {
        // if our link has a .gif or .jpg on the end,
        // we can get an image.
        // if it does not, we won't get anything at all,
        // so just put the stock image in it.
        // if it's NSFW we show a different image

        UIImage *defaultImage = [UIImage imageNamed:@"Shrimp153.png"];
        BOOL good = YES;
        BOOL useForBig = NO;
        
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
                NSString *newStr = [NSString stringWithFormat:@"http://i.imgur.com/%@b.%@", [bits objectAtIndex:0], [bits objectAtIndex:1]];
                NSURL *theURL = [NSURL URLWithString:newStr];
                data0 = [NSData dataWithContentsOfURL:theURL];
                if (data0 == nil)
                {
                    // something went wrong. maybe we can't get a small image for this.
                    // happens a lot with gif files since many are animated.
                    // so just go for the default then.
                    NSString *newStr = [NSString stringWithFormat:@"http://i.imgur.com/%@.%@", [bits objectAtIndex:0], [bits objectAtIndex:1]];
                    NSURL *theURL = [NSURL URLWithString:newStr];
                    data0 = [NSData dataWithContentsOfURL:theURL];
                    // this will be the same as the big image, so set them both
                    // unless it's NSFW, in which case we'll try to get the original
                    if (bNSFW == NO)
                    {
                        useForBig = YES;
                    }
                }
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

        if (bNSFW == YES)
        {
            data0 = UIImagePNGRepresentation([UIImage imageNamed:@"NSFW.jpg"]);
        }
        
        dispatch_async(dispatch_get_main_queue(),
        ^{
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            myObject.mySmallImage = data0;
            // set it here
            if (useForBig)
            {
                myObject.myBigImage = data0;
            }
            [realm commitWriteTransaction];

            myImage.image = [UIImage imageWithData:data0];
            [self.active setHidden:YES];
            [self setNeedsDisplay];
        });

    });
}

@end
