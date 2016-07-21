//
//  RESTCalls.h
//  TelmedIQApp
//
//  Created by John Spicer on July 20, 2016
//  Copyright © 2016 John Spicer. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class handles all rest calls.
 */
@interface RESTCalls : NSObject

/**
 Dictionary with the gallery contents
 */
+ (NSArray*)getGalleryContents;

@end
