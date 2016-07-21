//
//  RESTCalls.m
//  TelmedIQApp
//
//  Created by John Spicer on July 20, 2016
//  Copyright © 2016 John Spicer. All rights reserved.
//

#import "Utilities.h"
#import "RESTCalls.h"
#import "AppDelegate.h"

@implementation RESTCalls

#pragma mark - API Request Methods that return data

/**
 Dictionary with the discovery page contents
 */
+ (NSArray*)getGalleryContents
{
    // Create the request.
    
    NSURL *stringUrl = [NSURL URLWithString:@"https://api.imgur.com/3/gallery/hot/viral/0.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:stringUrl];
    
    // Specify that it will be a GET request
    request.HTTPMethod = @"GET";
    
    // 'Authorization': 'Client-ID' '917fbe7adfae1b7'
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"'Client-ID' '917fbe7adfae1b7'" forKey:@"'Authorization'"];
    [request setAllHTTPHeaderFields:dict];
    DLog(@"getGalleryContents");
    
    // Create url connection and fire request
    NSHTTPURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: nil];
    
    if ([data length] > 0)
    {
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error == nil)
        {
            BOOL success = [[dict objectForKey:@"success"] boolValue];
            if (success == YES)
            {
                NSArray *results = [dict objectForKey:@"data"];
                return results;
            }
            else
            {
                DLog(@"dict = %@", [dict description]);
                return nil;
            }
        }
        else
        {
            return nil;
        }
    }
    return nil;
}

@end
