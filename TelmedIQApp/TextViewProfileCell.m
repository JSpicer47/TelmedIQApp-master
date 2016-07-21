/** @file TextViewProfileCell.m
 *  @brief A custom cell that contains an image and some bits from an imgur gallery
 *
 *  Copyright (c) 2016 John Spicer
 *
 *  @author John Spicer
 *  @bug No known bugs.
 */

#import "AppDelegate.h"
#import "TextViewProfileCell.h"

@implementation TextViewProfileCell

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

    title.text = inDict.title;

    NSTimeInterval seconds = [inDict.datetime integerValue];
    NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy h:mm a"];
    datetime.text = [dateFormatter stringFromDate:epochNSDate];
    
    NSInteger iScore = [inDict.score integerValue];
    score.text = [NSString stringWithFormat:@"%ld", (long)iScore];
    
    link.text = inDict.link;
    
    bool notSafe = [inDict.nsfw boolValue];
    if (notSafe == 0)
    {
        nsfw.text = @"NO";
    }
    else
    {
        nsfw.text = @"YES";
    }

}

// this is a workaround since segues won't work if you have a custom cell.
// go figure.
// a bug I hope Apple will soon fix!
//
- (IBAction)gotoDetailsPage:(id)sender
{
    DLog(@"button pressed!");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToDetailsView" object:[NSNumber numberWithInteger:self.tag]];
}

@end
