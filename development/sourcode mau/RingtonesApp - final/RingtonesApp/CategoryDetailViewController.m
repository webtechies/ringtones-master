//
//  CategoryDetailViewController.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryDetailViewController.h"
#import "Constants.h"
#import "CommonUtils.h"
#import "RingtoneHelpers.h"


@interface CategoryDetailViewController(privateMethods)
- (void)reloadDataSource;

- (void)callLoadmore;
- (void)doneLoadmore:(ASIHTTPRequest *)request;
- (void)failLoadmore:(ASIHTTPRequest *)request;


@end


@implementation CategoryDetailViewController
@synthesize categoryId;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil category:(NSDictionary *)dict;
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        F_RELEASE(dicCategory);
        dicCategory = [dict retain];
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
    F_RELEASE(arrSource);
    //get new source here
    arrSource = [[NSMutableArray alloc]init];
    
    
    currentMinId = 999999999;
    
    [self callLoadmore];
    
    /*
     for (int i = 0; i < kNoItemsPerPage; i++) {
     [arrSource addObject:[NSString stringWithFormat:@"cell: %d", i]];
     }
     
     [mainTableView reloadData];
     
     */
}


#pragma Loadmore
- (void)callLoadmore;
{
    if (isLoading) {
        return;
    }
    
    isLoading = TRUE;
    
    //call service here
    NSInteger catId = [[dicCategory objectForKey:@"id"] intValue];
    
    NSString *urlServer = [NSString stringWithFormat:SERVER_API_GETITEMBYCAT, catId, currentMinId, kNoItemsPerPage];
    NSLog(@"urlServer: %@", urlServer);
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlServer]];
    request.delegate = self;
    [request setTimeOutSeconds:kTimeoutGetRingtone];
    
    [request setDidFinishSelector:@selector(doneLoadmore:)];
    [request setDidFailSelector:@selector(failLoadmore:)];

    
    [request startAsynchronous];
    
//    NSLog(@"status code: %@", [request responseHeaders]);
//    if ([request error] == nil) {
//        [self doneLoadmore:request];
//    } else {
//        [self failLoadmore:request];
//    }
//    
    
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
    
}

- (void)failLoadmore:(ASIHTTPRequest *)request;
{
    isLoading = FALSE;
    
    //handle fail
    NSLog(@"error: %@", [[request error]localizedDescription]);
}


#pragma Tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger sourceCount = [arrSource count];
    if (sourceCount == 0) {
        return sourceCount + 1; //loadmore cell
    }
    
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
    
    return cell;}

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
    NSLog(@"onUpgradeClicked cateDetail");
}

#pragma -Purchase delegate from App Delegate
- (void)purchaseDidFinish {
    NSLog(@"purchaseDidFinish category detail");
}

- (void)purchaseDidFail {
    NSLog(@"purchaseDidFail category detail");
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [dicCategory objectForKey:@"title"];
    
    
    [self performSelector:@selector(reloadDataSource) withObject:nil afterDelay:1.0f];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    
    NSLog(@"dealloc cate Detail");
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //remove player/preview
    UIView *preview = [self.view viewWithTag:TAG_PREVIEW];
    if (preview != nil) {
        [delegate.ringtonePreview stopPreviewingAndRemoveFromSuperView];
    }
    
    UIView *player = [self.view viewWithTag:TAG_PLAYER];
    if (player) {
       [delegate.ringtonePlayer stopPlayingRingtoneAndRemoveFromSuperView];
    }
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    return YES;
}


@end
