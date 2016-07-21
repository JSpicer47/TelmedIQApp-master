//
//  MasterViewController.m
//  TelmedIQApp
//
//  Created by John Spicer on 2016-07-20.
//  Copyright © 2016 John Spicer. All rights reserved.
//

#import <Realm/Realm.h>
#import "AppDelegate.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "RESTCalls.h"
#import "Utilities.h"
#import "TextViewProfileCell.h"

@implementation imgObject
// None needed
@end


@interface MasterViewController ()

@end

@implementation MasterViewController

@synthesize gallery;
@synthesize galleryArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    galleryArray = [[imgObject allObjects] sortedResultsUsingProperty:@"id" ascending:YES];

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    [self.tableView registerNib:[UINib nibWithNibName:@"TextViewProfileCell" bundle:nil] forCellReuseIdentifier:@"Cell"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToDetailsView:) name:@"goToDetailsView" object:nil];
    
    // if we have a connection, do try
    if ([[AppDelegate app] checkReachability] == ReachableViaWiFi)
    {
        [self fetchData];
    }
    else
    {
        DLog(@"no connection, we will show what we have");
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"No Network connection"
                                                             message:@"There is no network connection. Only items currently saved will be shown."
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
        [alertView show];

    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetails"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        imgObject *theObject = galleryArray[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:theObject];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

- (void)goToDetailsView:(NSNotification*)inNotification
{
    NSInteger tag = [[inNotification object] integerValue];
    DLog(@"tag = %ld", (long)tag);
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0] animated:NO scrollPosition:0];
    [self performSegueWithIdentifier:@"showDetails" sender:self];
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return gallery.count;
    return galleryArray.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 115.0f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextViewProfileCell *cell = (TextViewProfileCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.tag = indexPath.row;
    
    imgObject *object = galleryArray[indexPath.row];
    [cell setUpCell:object];
    
    if (object.mySmallImage != nil)
    {
        //DLog(@"I got an image for this one...");
        UIImage *goodImage = [UIImage imageWithData:object.mySmallImage];
        cell.myImage.image = goodImage;
        [cell.active stopAnimating];
    }
/*
    if (galleryImages.count > 0 && indexPath.row <galleryImages.count && [galleryImages objectAtIndex:indexPath.row] != nil)
    {
        cell.myImage.image = [galleryImages objectAtIndex:indexPath.row];
        [cell.active stopAnimating];
    }
*/
    return cell;
}

-(void)fetchData
{
    DLog(@"TelmedIQApp::fetchData");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void)
    {
        gallery = [RESTCalls getGalleryContents];
        if (gallery.count < 1)
        {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"capturedJSON" ofType:@"txt"];
            NSData *myData = [NSData dataWithContentsOfFile:filePath];
            if (myData)
            {
                NSError *error;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:myData options:kNilOptions error:&error];
                if (error == nil)
                {
                    BOOL success = [[dict objectForKey:@"success"] boolValue];
                    if (success == YES)
                    {
                        gallery = [dict objectForKey:@"data"];
                    }
                }
            }
        }
        
        // now we must write on the main thread
        dispatch_async(dispatch_get_main_queue(),
        ^{
            BOOL weAddedSomething = NO;
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            for (NSInteger index = 0; index < gallery.count; index++)
            {
                // Add row via dictionary. Order is ignored.
                NSDictionary *dict = [gallery objectAtIndex:index];
                
                NSNumber<RLMBool> *nsfw = [dict objectForKey:@"nsfw"];
                NSNumber<RLMBool> *score = [dict objectForKey:@"score"];
                NSNumber<RLMBool> *datetime = [dict objectForKey:@"datetime"];
                NSNumber<RLMBool> *favorite = [dict objectForKey:@"favorite"];
                
                NSNumber *rAccountID = [dict objectForKey:@"id"];
                // DLog(@"id = %@", rAccountID);
                // Query using an NSPredicate
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", rAccountID];
                RLMResults *results = [imgObject objectsWithPredicate:pred];
                
                if (results.count < 1)
                {
                    
                    [imgObject createInRealm:realm withValue:@{@"account_id"    :[dict objectForKey:@"account_id"],
                                                               @"title"         :[dict objectForKey:@"title"],
                                                               @"link"          :[dict objectForKey:@"link"],
                                                               @"favorite"      :favorite,
                                                               @"nsfw"          :nsfw,
                                                               @"score"         :score,
                                                               @"datetime"      :datetime,
                                                               @"id"            :[dict objectForKey:@"id"],
                                                               }];
                    weAddedSomething = YES;
                }
            }
            [realm commitWriteTransaction];
            
            if (weAddedSomething)
            {
                [self fetchImages];
            }
            
            [theBigSpinner setHidden:YES];
            [self.tableView reloadData];
            
        });

    });
}

// Fetch the images in the background
//
- (void)fetchImages
{
    for (NSInteger i = 0; i < [galleryArray count]; i++)
    {
        imgObject *dict = [galleryArray objectAtIndex:i];
        NSString *urlStr = dict.link;
        BOOL nsfw = [dict.nsfw boolValue];
        DLog(@"[%ld] link = %@, nsfw = %d", (long)i, urlStr, nsfw);

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void)
        {

                // if our link has a .gif or .jpg on the end,
                // we can get a thumbnail.
                // if it does not, we won't get anything at all,
                // so just put the stock image in it.
                // if it's NSFW we put up a stock image instead
                // I guess we would actually have an image for this
                // we will use another just so that we know
                // we don't fetch the image if it's NSFW

                UIImage *defaultImage = [UIImage imageNamed:@"Shrimp153.png"];
                BOOL good = YES;

                if (nsfw == YES)
                {
                    good = NO;
                    defaultImage = [UIImage imageNamed:@"img02.jpg"];
                }

                UIImage *goodImage = nil;
                NSString *fileType = nil;
                NSData *data0;
                if (urlStr != nil && good)
                {
                    NSString *name = [urlStr lastPathComponent];
                    //DLog(@"name = %@", name);
                    NSArray *bits = [name componentsSeparatedByString:@"."];
                    // if it has an ending at all, we're good
                    if ([bits count] > 1)
                    {
                        NSString *newStr = [NSString stringWithFormat:@"http://i.imgur.com/%@b.%@", [bits objectAtIndex:0], [bits objectAtIndex:1]];
                        fileType = [bits objectAtIndex:1];
                        NSURL *theURL = [NSURL URLWithString:newStr];
                        data0 = [NSData dataWithContentsOfURL:theURL];
                        
                        goodImage = [UIImage imageWithData:data0];
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
                    [self.tableView reloadData];
                    imgObject *object = galleryArray[i];
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm beginWriteTransaction];
                    object.mySmallImage = data0;
                    [realm commitWriteTransaction];
                });
 
        });
        
    }
}

@end
