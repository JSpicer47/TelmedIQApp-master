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
#import "imgurCell.h"

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

    [self.tableView registerNib:[UINib nibWithNibName:@"imgurCell" bundle:nil] forCellReuseIdentifier:@"imgurCell"];

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
    //DLog(@"tag = %ld", (long)tag);
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
    imgurCell *cell = (imgurCell *)[tableView dequeueReusableCellWithIdentifier:@"imgurCell"];
    
    cell.tag = indexPath.row;
    
    imgObject *object = galleryArray[indexPath.row];
    [cell setUpCell:object];

    return cell;
}

-(void)fetchData
{
    //DLog(@"TelmedIQApp::fetchData");
    
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
                    else
                    {
                        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"No data returned from service."
                                                                             message:@"Perhaps we've reached our daily limit?"
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles: nil];
                        [alertView show];
                    }
                }
            }
        }
        
        // now we must write on the main thread
        dispatch_async(dispatch_get_main_queue(),
        ^{
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
                }
            }
            [realm commitWriteTransaction];
            
            [theBigSpinner setHidden:YES];
            [self.tableView reloadData];
        });

    });
}

@end
