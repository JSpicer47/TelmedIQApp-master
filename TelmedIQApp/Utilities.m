//
//  Utilities.m
//  myaccountlite
//
//  Created by John Spicer on 2015-01-20.
//  Copyright (c) Rogers Inc. All rights reserved.
//

#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
#import "SystemConfiguration/SCNetworkReachability.h"
#import "Utilities.h"
#import "AppDelegate.h"
#ifdef ROGERS
#import "SignIn.h"
#endif

@implementation Utilities

#pragma mark - Misc. Functions

+ (NSString*)machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

#pragma mark - Assorted helper functions for buttons

+ (void)setTitle:(NSString*)inTitle forAllButtonStates:(UIButton*)inButton
{
    [inButton setTitle:inTitle forState:UIControlStateDisabled];
    [inButton setTitle:inTitle forState:UIControlStateSelected];
    [inButton setTitle:inTitle forState:UIControlStateHighlighted];
    [inButton setTitle:inTitle forState:UIControlStateNormal];
}

+ (void)setAttributedTitle:(NSAttributedString*)inTitle forAllButtonStates:(UIButton*)inButton
{
    [inButton setAttributedTitle:inTitle forState:UIControlStateDisabled];
    [inButton setAttributedTitle:inTitle forState:UIControlStateSelected];
    [inButton setAttributedTitle:inTitle forState:UIControlStateHighlighted];
    [inButton setAttributedTitle:inTitle forState:UIControlStateNormal];
}

+ (void)setTitleColor:(UIColor*)inColor forAllButtonStates:(UIButton*)inButton
{
    [inButton setTitleColor:inColor forState:UIControlStateDisabled];
    [inButton setTitleColor:inColor forState:UIControlStateSelected];
    [inButton setTitleColor:inColor forState:UIControlStateHighlighted];
    [inButton setTitleColor:inColor forState:UIControlStateNormal];
}

+ (void)setImage:(UIImage*)inImage forAllButtonStates:(UIButton*)inButton
{
    [inButton setImage:inImage forState:UIControlStateDisabled];
    [inButton setImage:inImage forState:UIControlStateNormal];
    [inButton setImage:inImage forState:UIControlStateSelected];
    [inButton setImage:inImage forState:UIControlStateHighlighted];
}

+ (void)setBackgroundImage:(UIImage*)inImage forAllButtonStates:(UIButton*)inButton
{
    [inButton setBackgroundImage:inImage forState:UIControlStateDisabled];
    [inButton setBackgroundImage:inImage forState:UIControlStateNormal];
    [inButton setBackgroundImage:inImage forState:UIControlStateSelected];
    [inButton setBackgroundImage:inImage forState:UIControlStateHighlighted];
}

#pragma mark - Days between dates

+ (NSUInteger)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2
{
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return [components day]+1;
}

#pragma mark - Format phone #

+ (NSString*)phoneNumber:(NSString*)inStr
{
    static NSCharacterSet* set = nil;
    if (set == nil)
    {
        set = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    }
    NSString* phoneString = [[inStr componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    switch (phoneString.length)
    {
        case 7: return [NSString stringWithFormat:@"%@-%@", [phoneString substringToIndex:3], [phoneString substringFromIndex:3]];
        case 10: return [NSString stringWithFormat:@"(%@) %@-%@", [phoneString substringToIndex:3], [phoneString substringWithRange:NSMakeRange(3, 3)],[phoneString substringFromIndex:6]];
        case 11: return [NSString stringWithFormat:@"%@ (%@) %@-%@", [phoneString substringToIndex:1], [phoneString substringWithRange:NSMakeRange(1, 3)], [phoneString substringWithRange:NSMakeRange(4, 3)], [phoneString substringFromIndex:7]];
        case 12: return [NSString stringWithFormat:@"+%@ (%@) %@-%@", [phoneString substringToIndex:2], [phoneString substringWithRange:NSMakeRange(2, 3)], [phoneString substringWithRange:NSMakeRange(5, 3)], [phoneString substringFromIndex:8]];
        default: return nil;
    }
}

#pragma mark - Helper Methods

// Given a float value which can be from 0-5 in .5 increments,
// return an array of images to show for the item
//
// we have fullStar, halfStar, noStar
//
+ (NSMutableArray*)allTheStars:(float)inValue
{
    if ((inValue < 0.0f ) || (inValue > 5.0f))
    {
        return nil;
    }
    
    NSMutableArray *theStars = [[NSMutableArray alloc] init];
    UIImage *image1;
    UIImage *image2;
    UIImage *image3;
    UIImage *image4;
    UIImage *image5;

    if (inValue == 0.0f)
    {
        image1 = [UIImage imageNamed:@"noStar.png"];
        image2 = [UIImage imageNamed:@"noStar.png"];
        image3 = [UIImage imageNamed:@"noStar.png"];
        image4 = [UIImage imageNamed:@"noStar.png"];
        image5 = [UIImage imageNamed:@"noStar.png"];
    }
    if (inValue == 0.5f)
    {
        image1 = [UIImage imageNamed:@"halfStar.png"];
        image2 = [UIImage imageNamed:@"noStar.png"];
        image3 = [UIImage imageNamed:@"noStar.png"];
        image4 = [UIImage imageNamed:@"noStar.png"];
        image5 = [UIImage imageNamed:@"noStar.png"];
    }
    if (inValue == 1.0f)
    {
        image1 = [UIImage imageNamed:@"fullStar.png"];
        image2 = [UIImage imageNamed:@"noStar.png"];
        image3 = [UIImage imageNamed:@"noStar.png"];
        image4 = [UIImage imageNamed:@"noStar.png"];
        image5 = [UIImage imageNamed:@"noStar.png"];
    }
    if (inValue == 1.5f)
    {
        image1 = [UIImage imageNamed:@"fullStar.png"];
        image2 = [UIImage imageNamed:@"halfStar.png"];
        image3 = [UIImage imageNamed:@"noStar.png"];
        image4 = [UIImage imageNamed:@"noStar.png"];
        image5 = [UIImage imageNamed:@"noStar.png"];
    }
    if (inValue == 2.0f)
    {
        image1 = [UIImage imageNamed:@"fullStar.png"];
        image2 = [UIImage imageNamed:@"fullStar.png"];
        image3 = [UIImage imageNamed:@"noStar.png"];
        image4 = [UIImage imageNamed:@"noStar.png"];
        image5 = [UIImage imageNamed:@"noStar.png"];
    }
    if (inValue == 2.5f)
    {
        image1 = [UIImage imageNamed:@"fullStar.png"];
        image2 = [UIImage imageNamed:@"fullStar.png"];
        image3 = [UIImage imageNamed:@"halfStar.png"];
        image4 = [UIImage imageNamed:@"noStar.png"];
        image5 = [UIImage imageNamed:@"noStar.png"];
    }
    if (inValue == 3.0f)
    {
        image1 = [UIImage imageNamed:@"fullStar.png"];
        image2 = [UIImage imageNamed:@"fullStar.png"];
        image3 = [UIImage imageNamed:@"fullStar.png"];
        image4 = [UIImage imageNamed:@"noStar.png"];
        image5 = [UIImage imageNamed:@"noStar.png"];
    }
    if (inValue == 3.5f)
    {
        image1 = [UIImage imageNamed:@"fullStar.png"];
        image2 = [UIImage imageNamed:@"fullStar.png"];
        image3 = [UIImage imageNamed:@"fullStar.png"];
        image4 = [UIImage imageNamed:@"halfStar.png"];
        image5 = [UIImage imageNamed:@"noStar.png"];
    }
    if (inValue == 4.0f)
    {
        image1 = [UIImage imageNamed:@"fullStar.png"];
        image2 = [UIImage imageNamed:@"fullStar.png"];
        image3 = [UIImage imageNamed:@"fullStar.png"];
        image4 = [UIImage imageNamed:@"fullStar.png"];
        image5 = [UIImage imageNamed:@"noStar.png"];
    }
    if (inValue == 4.5f)
    {
        image1 = [UIImage imageNamed:@"fullStar.png"];
        image2 = [UIImage imageNamed:@"fullStar.png"];
        image3 = [UIImage imageNamed:@"fullStar.png"];
        image4 = [UIImage imageNamed:@"fullStar.png"];
        image5 = [UIImage imageNamed:@"halfStar.png"];
    }
    if (inValue == 5.0f)
    {
        image1 = [UIImage imageNamed:@"fullStar.png"];
        image2 = [UIImage imageNamed:@"fullStar.png"];
        image3 = [UIImage imageNamed:@"fullStar.png"];
        image4 = [UIImage imageNamed:@"fullStar.png"];
        image5 = [UIImage imageNamed:@"fullStar.png"];
    }
    
    [theStars addObject:image1];
    [theStars addObject:image2];
    [theStars addObject:image3];
    [theStars addObject:image4];
    [theStars addObject:image5];
    
    return theStars;
}

#pragma mark - Hashing

+ (NSString *)hashed_string:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    // This is an iOS5-specific method.
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end
