//
//  Utilities.h
//  myaccountlite
//
//  Created by John Spicer on 2015-01-20.
//  Copyright (c) Rogers Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <sys/utsname.h>

/*!
 This class contains assorted CLASS methods for use by other classes.
 */
@interface Utilities : NSObject

/**
 Returns the name of the machine.
 @return machineName - the name of the device
 */
+ (NSString*)machineName;

/**
 Assigns a title to all button states for the given button
 @param[in] inTitle - text to use for the button
 @param[in] inButton - the button that gets assigned the title
 */
+ (void)setTitle:(NSString*)inTitle forAllButtonStates:(UIButton*)inButton;

/**
 Assigns an attributed title to all button states for the given button
 @param[in] inTitle - text to use for the button
 @param[in] inButton - the button that gets assigned the title
 */
+ (void)setAttributedTitle:(NSAttributedString*)inTitle forAllButtonStates:(UIButton*)inButton;

/**
 Assigns a color to the titles of a given button
 @param[in] inColor - the color to use
 @param[in] inButton - the button that gets the color assigned
 */
+ (void)setTitleColor:(UIColor*)inColor forAllButtonStates:(UIButton*)inButton;

/**
 Assigns an image to all the button states of the given button
 @param[in] inImage - image to use
 @param[in] inButton - the button that gets the image
 */
+ (void)setImage:(UIImage*)inImage forAllButtonStates:(UIButton*)inButton;

/**
 Assigns an image to all the background states of the given button
 @param[in] inImage - image to use
 @param[in] inButton - the button that gets the image
 */
+ (void)setBackgroundImage:(UIImage*)inImage forAllButtonStates:(UIButton*)inButton;

/**
 Returns the days between two dates
 @param[in] first date
 @param[in] second date
 @param[out] days between
 */
+ (NSUInteger)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2;

/**
 Takes a raw phone number and formats it pretty.
 */
+ (NSString*)phoneNumber:(NSString*)inStr;

/**
 Given a float value which can be from 0-5 in .5 increments,
return an array of images to show for the item
 we have fullStar, halfStar, noStar
*/
+ (NSMutableArray*)allTheStars:(float)inValue;

/**
 Hash a string using 256 SHA
 */
+ (NSString *)hashed_string:(NSString *)input;
@end
