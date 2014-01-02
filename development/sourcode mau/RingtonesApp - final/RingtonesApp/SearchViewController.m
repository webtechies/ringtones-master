//
//  SearchViewController.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "Constants.h"
#import "CommonUtils.h"

#import "RingtoneHelpers.h"



@interface SearchViewController(privateMethods)

- (void)reloadDataSource;

- (void)callLoadmore;
- (void)doneLoadmore:(ASIHTTPRequest *)request;
- (void)failLoadmore:(ASIHTTPRequest *)request;
- (void)didPurchased:(NSNotification *)notif;

@end



@implementation SearchViewController
@synthesize savedSearchTerm;


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


#pragma Custom methods
- (void)reloadDataSource;
{
    isLoading = FALSE;
    
    F_RELEASE(arrSource);
    //get new source here
    arrSource = [[NSMutableArray alloc]init];
    
    
    currentMinId = 999999999;
    
    [self callLoadmore];
    
}


#pragma Loadmore
- (void)callLoadmore;
{
    if (isLoading) {
        return;
    }
    
    isLoading = TRUE;
    //call service here
    
    NSString *urlServer = [NSString stringWithFormat:SERVER_API_SEARCH, savedSearchTerm, currentMinId, kNoItemsPerPage];
    NSLog(@"urlServer: %@", urlServer);
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlServer]];
    request.delegate = self;
    [request setTimeOutSeconds:kTimeoutSearch];
    
    [request setDidFailSelector:@selector(failLoadmore:)];
    [request setDidFinishSelector:@selector(doneLoadmore:)];
//    [request startAsynchronous];
    
    [CommonUtils startIndicatorDisableViewController:self];    
    
    [request startAsynchronous];
    
//    NSLog(@"status code: %@", [request responseHeaders]);
//    if ([request error] == nil) {
//        [self doneLoadmore:request];
//    } else {
//        [self failLoadmore:request];
//    }
    
    [request release];
    
    
}

- (void)doneLoadmore:(ASIHTTPRequest *)request;
{
    isLoading = FALSE;
    
    //new data goes here
    F_RELEASE(arrLoadmore);
    
    arrLoadmore = [[[RingtoneHelpers defaultHelper]convertDataToList:[request responseData]] retain];
    
    //add more data to source data
    for (int i = 0; i < [arrLoadmore count]; i++) {
        NSDictionary *dict = [arrLoadmore objectAtIndex:i];
        
        [arrSource addObject:dict];
        
        if (i == [arrLoadmore count] - 1) {
            currentMinId = [[dict objectForKey:@"id"] intValue];
        }
    }
    
    NSLog(@"new minID: %d", currentMinId);
    
    
    [mainTableView reloadData];
    
    [CommonUtils stopIndicatorDisableViewController:self];
    
}

- (void)failLoadmore:(ASIHTTPRequest *)request;
{
    isLoading = FALSE;
    
    [CommonUtils stopIndicatorDisableViewController:self];
    
    //handle fail
    NSLog(@"error: %@", [[request error]localizedDescription]);
}



#pragma Tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger sourceCount = [arrSource count];
    
    if (arrLoadmore == nil || (arrLoadmore != nil && [arrLoadmore count] < kNoItemsPerPage)) {
        return sourceCount;
    }
    
    return sourceCount + 1; //loadmore cell
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell = nil;
    
    if (indexPath.row != [arrSource count]) {
        CellIdentifier = @"RingtoneCell";
        
        customCell = (RingtoneCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (customCell == nil){
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RingtoneCell" owner:nil options:nil];
            for(id currentObject in topLevelObjects)
            {
                if([currentObject isKindOfClass:[RingtoneCell class]])
                {
                    customCell = (RingtoneCell *)currentObject;
                    break;
                }
            }
        }
        
        NSDictionary *dict = [arrSource objectAtIndex:indexPath.row];
        
        NSInteger star = [[dict objectForKey:@"rate"]intValue];
        
        
        UILabel *labelTitle = (UILabel *)[customCell viewWithTag:1];
        UILabel *labelSize = (UILabel *)[customCell viewWithTag:4];
        
        
        NSString *title = [dict objectForKey:@"title"];
        
        labelTitle.text = title;
        [customCell updateStars:star];
        
        labelSize.text = [NSString stringWithFormat:@"%dKb", [[dict objectForKey:@"file_size"] intValue] / 1000];
        
        cell = customCell;
        
    } else { //loadmore cell
        CellIdentifier = @"LoadmoreCell";
        loadmoreCell = (LoadmoreCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (loadmoreCell == nil){
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LoadmoreCell" owner:nil options:nil];
            for(id currentObject in topLevelObjects)
            {
                if([currentObject isKindOfClass:[LoadmoreCell class]])
                {
                    loadmoreCell = (LoadmoreCell *)currentObject;
                    break;
                }
            }
        }
        
        cell = loadmoreCell;
        
        //begin loadmore when loadmore cell visible
        [self performSelector:@selector(callLoadmore) withObject:nil afterDelay:1.0f];
        
    }
    
    
    //    NSInteger index = indexPath.row;
    
    return cell;
}

#pragma tableview delegate
- (void)handleTapCellForIndex:(NSInteger)index
{
    selectedIndex = index;
    
    //show actionsheet to ask for preview or download
    NSDictionary *dict = [arrSource objectAtIndex:index];
    NSString *title = [dict objectForKey:@"title"];
    //show actionsheet to send mail
    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:title 
                                                            delegate:self 
                                                   cancelButtonTitle:BUTTON_ACTIONSHEET_CANCEL 
                                              destructiveButtonTitle:nil 
                                                   otherButtonTitles:BUTTON_ACTIONSHEET_RING_PREVIEW, BUTTON_ACTIONSHEET_RING_DOWNLOAD, nil];
    actionsheet.tag = TAG_ACTIONSHEET_PREVIEW_DOWNLOAD;
    [actionsheet showInView:self.tabBarController.tabBar];
    [actionsheet release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self handleTapCellForIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    [self handleTapCellForIndex:indexPath.row];
}

#pragma Actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet tag] == TAG_ACTIONSHEET_PREVIEW_DOWNLOAD) {
        NSDictionary *dict = [arrSource objectAtIndex:selectedIndex];
        
        if (buttonIndex == 0) {
            NSLog(@"preview selected");
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            [delegate previewRingtone:dict onViewController:self];
        } else if (buttonIndex == 1) {
            NSLog(@"download selected");
            
            //check if reach max limit of download
            NSArray *array = [[RingtoneHelpers defaultHelper]getListRingtoneFromDocument];
            //            NSNumber *countDownloaded = [[NSUserDefaults standardUserDefaults]objectForKey:kDownloadedCount];
            NSInteger count = (array != nil) ? [array count] : 0;
            BOOL willDownload = TRUE;
            BOOL willPurchase = TRUE;
#ifdef kLiteVersion 
            willPurchase = FALSE;
            if (count >= kMaxRingtoneFree) {
                willDownload = FALSE;
            }
#elif kFreeVersion
            BOOL purchased = [[[NSUserDefaults standardUserDefaults]objectForKey:kPurchaseKey] boolValue];
            if (!purchased && count >= kMaxRingtoneFree) {
                willDownload = FALSE;
            }
#else
            willDownload = TRUE;
#endif
            
            if (willDownload) {
                [[RingtoneHelpers defaultHelper] downloadRingtoneFromDict:dict];
            } else {
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                if (willPurchase) {
                    [delegate showAlertUpgradeOnView:self upgradeMethod:@selector(onUpgradeClicked)];
                } else {
                    [delegate showAlertLinkToFull:self];
                }
                
            }
        }
    }
}

- (void)onUpgradeClicked;
{
    NSLog(@"onUpgradeClicked Search");
}

#pragma -Purchase delegate from App Delegate
- (void)purchaseDidFinish {
    [self didPurchased:nil];
    
    NSLog(@"purchaseDidFinish search ");
}

- (void)purchaseDidFail {
    NSLog(@"purchaseDidFail search ");
}

#pragma -
#pragma Search Bar
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self setSavedSearchTerm:nil];
	
    [searchBar resignFirstResponder];
//    [mainTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self handleSearchForTerm:searchBar.text];
    
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    return YES;
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    [self setSavedSearchTerm:searchTerm];
	
    //send search query to server
    [self reloadDataSource];
    
    
}


- (void)didPurchased:(NSNotification *)notif
{
    NSLog(@"did purchased on search, remove banner");
    //re-frame view and remove banner
    [viewBannerPlaceHolder removeFromSuperview];
    
    CGRect tableFrame = mainTableView.frame;
    tableFrame.origin.y = 44.0f;
    tableFrame.size.height = self.view.frame.size.height - 44.0f;
    mainTableView.frame = tableFrame;
}





#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
#ifdef kFullVersion
    [self didPurchased:nil];
#else
    
#ifdef kFreeVersion
        
    BOOL purchased = [[[NSUserDefaults standardUserDefaults]objectForKey:kPurchaseKey] boolValue];
    NSLog(@"purchased: %d", purchased);
    if (!purchased) {

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didPurchased:) name:kPurchaseKey object:nil];
#endif
        //add banner view
        banner = [[BannerViewController alloc]initWithNibName:@"BannerViewController" bundle:nil];
        
        banner.view.frame = CGRectMake(0.0f, 0.0f, viewBannerPlaceHolder.frame.size.width, viewBannerPlaceHolder.frame.size.height);
        [viewBannerPlaceHolder addSubview:banner.view];
        
        [banner startRandomAd]; 
        
#ifdef kFreeVersion
    } else {
        [self didPurchased:nil];
    }
#endif 
#endif
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
#ifdef kFreeVersion    
    BOOL purchased = [[[NSUserDefaults standardUserDefaults]objectForKey:kPurchaseKey] boolValue];
    NSLog(@"purchased: %d", purchased);
    if (purchased) {
        [self didPurchased:nil];
    }
#endif 

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    banner = nil;
    
    //remove observer
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [banner release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    return YES;
}


@end
