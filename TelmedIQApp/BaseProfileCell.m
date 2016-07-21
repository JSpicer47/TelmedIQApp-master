/** @file BaseProfileCell.m
 *  @brief The base custom cell from which all others derive. Contains methods and properties that are common to all cells.
 *
 *  Copyright (c) 2014 MobileLive.ca
 *
 *  @author John Spicer
 *  @bug No known bugs.
 */

#import "BaseProfileCell.h"

@implementation BaseProfileCell

@synthesize question;
@synthesize kind;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpCell
{
    // handled by decendants
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self addGestureRecognizer:tap];
    
}

- (void)dismissKeyboard
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MIRSomeoneWantsToHideTheKeyboard" object:nil userInfo:nil];
}

- (CGRect)makeAHeaderLabel:(NSString*)inText withOffset:(float)offset andAlignment:(NSTextAlignment)inAlignment andMaxWidth:(float)maxWidth
{
    float titleHeight = [self calculateLabelHeight:inText andAlignment:inAlignment andMaxWidth:maxWidth];
    if (maxWidth == 0) maxWidth = 280.0f;
    
    CGRect frame = { 20.0f, 0 + offset, maxWidth, titleHeight };
    
    return frame;
}

- (float)calculateLabelHeight:(NSString*)inText andAlignment:(NSTextAlignment)inAlignment andMaxWidth:(float)maxWidth
{
    float titleHeight = 0.0f;
    // need the text
    NSString *title = inText;
    //title = @"A really long title that should take up at least two lines maybe three no its not so make it much much longer dude man you the man!";

    // need a fake label to set up and use for height calculation
    if (maxWidth == 0) maxWidth = 280.0f;
    
    CGRect frame = { 20.0f, 100.0f, maxWidth, 22.0f };
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
    [titleLabel setTextAlignment:inAlignment];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:14.0f]];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:title
                                                                         attributes:@
                                          {
                                          NSFontAttributeName: titleLabel.font
                                          }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){280.0f, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    titleHeight = rect.size.height;
    if (titleHeight < 22.0)
        titleHeight = 22.0f;
    
    // we want multiples of 22
    int remainder = (int)titleHeight % 22;
    if (remainder != 0)
    {
        //DLog(@"not a clean 22 * n");
        // add difference
        titleHeight += (22 - remainder);
    }
    
    //DLog(@"[calculateLabelHeight] title = %@, titleHeight = %f", title, titleHeight);
    return titleHeight;
}

#pragma mark - Methods just blank for compiler

- (void)rebuildWithOptions:(NSArray*)inOptions forKey:(NSString*)inKey
{
    
}

- (void)adjustToSurroundings
{
   // DLog(@"base cell adjusting to surroundings, boss!");
}

@end
