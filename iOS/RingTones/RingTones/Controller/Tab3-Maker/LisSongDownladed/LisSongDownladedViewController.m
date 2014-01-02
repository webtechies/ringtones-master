//
//  LisSongDownladedViewController.m
//  RingTones
//
//  Created by VinhTran on 12/24/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import "LisSongDownladedViewController.h"
#import "MainMakerViewController.h"
#import "Constants.h"
#import "CommonUtils.h"
#import "SongModel.h"


@interface LisSongDownladedViewController ()

@end

static NSString *letters = @"#abcdefghijklmnopqrstuvwxyz";

@implementation LisSongDownladedViewController

@synthesize searchResults, savedSearchTerm,arContent,arrSource;


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
    //    [CommonUtils startIndicatorDisableViewController:self];
    
   // MPMediaQuery *query = [MPMediaQuery songsQuery];
    SongModel *songModel = [[SongModel alloc] init];
    
    self.arrSource = [songModel getAllRowsInSongTable];
    
    
    self.arContent = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [letters length]; i++ ) {
        //creat title for indexing
        char currentLetter[2] = { toupper([letters characterAtIndex:i]), '\0'};
        
        NSString *letterIndex = [NSString stringWithCString:currentLetter encoding:NSASCIIStringEncoding];
        
        NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *list = [[NSMutableArray alloc] init];
        
        for (int j = 0; j < [self.arrSource count]; j++) {
            SongField *item = [self.arrSource objectAtIndex:j];
            NSString *title = item.name;
            
            NSString *firstCharacter = [[title substringToIndex:1] lowercaseString];
            NSCharacterSet *nonLetterSet = [NSCharacterSet lowercaseLetterCharacterSet];
            if ([firstCharacter rangeOfCharacterFromSet:nonLetterSet].location == NSNotFound && i == 0)
            {
                //not lower letter, set to #section
                [list addObject:item];
                
            } else if ([title hasPrefix:letterIndex]) {
                [list addObject:item];
            }
        }
        
        if (list != nil && [list count] > 0) {
            [row setValue:letterIndex
                   forKey:@"headerTitle"];
            
            //set list of items for index title
            [row setValue:list forKey:@"rowValues"];
            
            [self.arContent addObject:row];
        }
        
        
    }
    
    
    arIndices = [self.arContent valueForKey:@"headerTitle"];
    
    [mainTableView reloadData];
    
    //    [CommonUtils stopIndicatorDisableViewController:self];
}

- (void)updateOffset;
{
    mainTableView.contentOffset = CGPointMake(0.0f, 44.0f);
}


#pragma Tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == [[self searchDisplayController] searchResultsTableView]) {
        return 1;
    } else {
        return [self.arContent count];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == [[self searchDisplayController] searchResultsTableView])
    {
        return [searchResults count];
    }
    else
    {
        //        return [self.arrSource count];
        return [[[self.arContent objectAtIndex:section] objectForKey:@"rowValues"] count] ;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // cell.textLabel.textAlignment = UITextAlignmentLeft;
    
    SongField *item;
    
    if (tableView == [[self searchDisplayController] searchResultsTableView]) {
        item = [searchResults objectAtIndex:indexPath.row];
    } else {
        
        //        item = [self.arrSource objectAtIndex:indexPath.row];
        item = [[[self.arContent objectAtIndex:indexPath.section] objectForKey:@"rowValues"]
                objectAtIndex:indexPath.row];
    }
    
    NSString *title = item.name;
//    NSString *artist = [item valueForProperty:MPMediaItemPropertyArtist];
//    NSString *album = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
    
    title = (title) ? title : @"";
//    artist = (artist) ? artist : @"";
//    album = (album) ? album : @"";
    NSString *subDetail = @"";//[NSString stringWithFormat:@"%@ - %@", album, artist];
    
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subDetail;
    
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == [[self searchDisplayController] searchResultsTableView]) {
        return nil;
    } else {
        return [self.arContent valueForKey:@"headerTitle"];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (tableView == [[self searchDisplayController] searchResultsTableView]) {
        return -1;
    } else {
        return [arIndices indexOfObject:title];
    }
}


#pragma tableview delegate
- (void)handleTapCellForIndex:(NSInteger)index
{
//     SongField *item;
//  
//     if (mainTableView == [[self searchDisplayController] searchResultsTableView]) {
//         item = [searchResults objectAtIndex:indexPath.row];
//     } else {
//         item = [self.arrSource objectAtIndex:indexPath.row];
//     }
//  
//        MainMakerViewController *creator = [[MainMakerViewController alloc]initWithNibName:@"MainMakerViewController" bundle:nil];
//    creator.songid =
//    
//    
//        [self.navigationController pushViewController:creator animated:YES];
    //
    //    [creator release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SongField *item;
    
    if (tableView == [[self searchDisplayController] searchResultsTableView]) {
        item = [searchResults objectAtIndex:indexPath.row];
    } else {
        //        item = [self.arrSource objectAtIndex:indexPath.row];
        item = [[[self.arContent objectAtIndex:indexPath.section] objectForKey:@"rowValues"]
                objectAtIndex:indexPath.row];
    }
    
    MainMakerViewController *creator = [[MainMakerViewController alloc]initWithNibName:@"MainMakerViewController" bundle:nil];
    creator.songid = item.rowid;
//    self.title = @"Back";
    [self.navigationController pushViewController:creator animated:YES];

}




#pragma mark - Search Bar
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
        searchResults = nil;
    }
	
    if ([savedSearchTerm length] != 0 && [self.arrSource count] > 0)
    {
        int total = 0;
        searchResults = [[NSMutableArray alloc] init];
        
        NSString *temp = [searchTerm lowercaseString];
        
        // search
        for (int i = 0; i < [self.arrSource count]; i++)
        {
            SongField *item = [self.arrSource objectAtIndex:i];
            NSString *title = [item.name lowercaseString];
            
            if ([title rangeOfString:temp].location != NSNotFound)
            {
                total++;
                [searchResults addObject:item];
            }
        }
    }
    
    [mainTableView reloadData];
}




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self updateOffset];
    
    [self reloadDataSource];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = TITLE_VIEW_LIST_IPOD_SONG;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
