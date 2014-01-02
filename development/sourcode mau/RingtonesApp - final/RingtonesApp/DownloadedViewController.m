//
//  DownloadedViewController.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadedViewController.h"
#import "CommonUtils.h"
#import "Constants.h"

#import "DatabaseManager.h"
#import "RingtoneHelpers.h"





@implementation DownloadedViewController
@synthesize searchResults, savedSearchTerm;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma -custom methods
- (void)reloadDataSource;
{
    [CommonUtils startIndicatorDisableViewController:self];
    
    arrSource = [[RingtoneHelpers defaultHelper]getListRingtoneFromDocument];
    
    [mainTableView reloadData];
    
    [CommonUtils stopIndicatorDisableViewController:self];
}

- (void)updateOffset;
{
    CGFloat offsetY = self.searchDisplayController.searchBar.frame.size.height;
    NSLog(@"offsetY: %f", offsetY);
    mainTableView.contentOffset = CGPointMake(0.0f, offsetY);
}


#pragma Tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == [[self searchDisplayController] searchResultsTableView])
    {
        return [searchResults count];
    }
    else
    {     
        return [arrSource count];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DownloadedCell";
    
    customCell = (DownloadedCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (customCell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DownloadedCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[DownloadedCell class]])
            {
                customCell = (DownloadedCell *)currentObject;
                break;
            }
        }
    }

    UILabel *labelTitle = (UILabel *)[customCell viewWithTag:1];
    UILabel *labelSize = (UILabel *)[customCell viewWithTag:2];
    UILabel *labelDuration = (UILabel *)[customCell viewWithTag:3];
    

    NSDictionary *dict;
    if (tableView == [[self searchDisplayController] searchResultsTableView])
    {
        dict = [searchResults objectAtIndex:indexPath.row];
    }
    else
    {     
        dict = [arrSource objectAtIndex:indexPath.row];
    }
    
    NSString *name = [dict objectForKey:@"title"];
    labelTitle.text = [name substringToIndex:[name length] - 4];
    
    
    NSString *size = [dict objectForKey:@"size"];
    labelSize.text = [NSString stringWithFormat:@"%.0f Kb", [size floatValue] / 1000.0];
    
    
    NSString *duration = [dict objectForKey:@"duration"];
    labelDuration.text = [CommonUtils convertToDateTimeFrom:[duration floatValue]];
    
    
    return customCell;
}

#pragma tableview delegate
- (void)handleTapCellForIndex:(NSInteger)index
{
    //test add player
    
//    [delegate playRingtone:kTestLocalSound onViewController:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [self handleTapCellForIndex:indexPath.row];
    
    NSDictionary *dict;
    if (tableView == [[self searchDisplayController] searchResultsTableView])
    {
        dict = [searchResults objectAtIndex:indexPath.row];
    }
    else
    {     
        dict = [arrSource objectAtIndex:indexPath.row];
    }
    
    NSString *fileName = [dict objectForKey:@"title"];
    NSString *filePath = [CommonUtils pathForSourceFile:fileName inDirectory:nil];
    [delegate playRingtone:filePath onViewController:self];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict;
    if (tableView == [[self searchDisplayController] searchResultsTableView])
    {
        dict = [searchResults objectAtIndex:indexPath.row];
    }
    else
    {     
        dict = [arrSource objectAtIndex:indexPath.row];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDidChooseSendEmail object:dict];
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == [[self searchDisplayController] searchResultsTableView])
    {
        return NO;
    }
    
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSDictionary *dict;
        if (tableView == [[self searchDisplayController] searchResultsTableView])
        {
            dict = [searchResults objectAtIndex:indexPath.row];
        }
        else
        {     
            dict = [arrSource objectAtIndex:indexPath.row];
        }
        //remove from folder
        [[RingtoneHelpers defaultHelper]deleteRingtoneFromDocument:[dict objectForKey:@"title"]];
        
        //remove file from source
        [arrSource removeObjectAtIndex:indexPath.row];
        
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
//        [self updateOffset];
        
        //close player
        [delegate.ringtonePlayer stopPlayingRingtoneAndRemoveFromSuperView];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


#pragma -
#pragma Search Bar
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self handleSearchForTerm:searchString];
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self setSavedSearchTerm:nil];
	
    [mainTableView reloadData];
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    [self setSavedSearchTerm:searchTerm];
	
    if (searchResults != nil)
    {
        [searchResults removeAllObjects];
        [searchResults release], searchResults = nil;
    }
	
    if ([savedSearchTerm length] != 0 && [arrSource count] > 0)
    {
        int total = 0;
        searchResults = [[NSMutableArray alloc] init];
        
        NSString *temp = [searchTerm lowercaseString];
        
        // search
        for (int i = 0; i < [arrSource count]; i++)
        {
            NSDictionary *dict = [arrSource objectAtIndex:i];
            
            NSString *title = [[dict objectForKey:@"title"
                               ] lowercaseString];
            
            if ([title rangeOfString:temp].location != NSNotFound)
            {
                total++;
                [searchResults addObject:dict];
            }
        }
    }
}


#pragma Notification handler
- (void)didFinishDownloadRingtone:(NSNotification *)notif;
{

    NSLog(@"Notif: downloaded 1 ringtone");
    if (notif != nil) {
        
    }
    
    [self reloadDataSource];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self updateOffset];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFinishDownloadRingtone:) name:kNotificationCompleteOneDownloadRingtone object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear downloaded");
//    [self reloadDataSource];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    return YES;
}


@end
