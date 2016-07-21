/** @file BaseProfileCell.h
 *  @brief The base custom cell from which all others derive. Contains methods and properties that are common to all cells.
 *
 *  Copyright (C) 2016 John Spicer (416) 312 8667
 *
 *  @author John Spicer
 *  @bug No known bugs.
 */

#import <UIKit/UIKit.h>

/**
 Values allowed for types of items in a survey list - text box, radio group, etc.
 */
enum DisplayTypeEnum
{
    kDisplayTypeRater                 = 1,
};

/**
 The base custom cell from which all others derive. Contains methods and properties that are common to all cells.
 */
@interface BaseProfileCell : UITableViewCell

@property enum                  DisplayTypeEnum kind;   /**< What kind of cell it is, from our defined list */
@property NSMutableDictionary   *question;              /**< The question for this cell */
@property NSString              *questionID;            /**< The ID of the question */
@property id                    answer;                 /**< The user's answer */
@property NSString              *GUID;                  /**< The GUID of this cell, used for tracking */
@property bool                  iAMSmall;               /**< TRUE if we have no 2nd section, make height smaller */
@property bool                  iAmReallySmall;         /**< A special case for when we don't have 1/2 of section zero (talk) */
@property IBOutlet UIButton     *showHide;              /**< Button to show/hide this drawer */

/**
 Configure the cell
 */
- (void)setUpCell;

/**
 Create a custom label sized to fit the given text with the other given parameters
 @param[in] inText - the actual text to show
 @param[in] offset - offset from top of screen/view/frame
 @param[in] inAlignment - left, right, center
 @param[in] maxWidth - maximum width of this size
 @return rect - our box to fit
 */
- (CGRect)makeAHeaderLabel:(NSString*)inText withOffset:(float)offset andAlignment:(NSTextAlignment)inAlignment andMaxWidth:(float)maxWidth;

/**
 In some circumstances, lists may need to be rebuilt. This is how it's done
 @param[in] inOptions - a list of text items to use
 @param[in] inKey - a key to match against
 */
- (void)rebuildWithOptions:(NSArray*)inOptions forKey:(NSString*)inKey;

/**
 Used to change the dynamics of a cell.
 */
- (void)adjustToSurroundings;

/**
 Standard class method
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

/**
 Standard class method
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

/**
 Remove the keyboard from the screen
 */
- (void)dismissKeyboard;

/**
 Used by makeAHeaderLabel to figure out the proper height for some text
 @param[in] inText - the actual text to show
 @param[in] inAlignment - left, right, center
 @param[in] maxWidth - maximum width of this size
 @return float - the height needed
 */
- (float)calculateLabelHeight:(NSString*)inText andAlignment:(NSTextAlignment)inAlignment andMaxWidth:(float)maxWidth;


@end
