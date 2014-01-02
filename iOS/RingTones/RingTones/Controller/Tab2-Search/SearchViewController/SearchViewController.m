//
//  SearchViewController.m
//  RingTones
//
//  Created by Vuong Nguyen on 12/12/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import "SearchViewController.h"

#define kDownloadingImageName @"Download.png"
#define kDownloadedImageName @"Download_completed.png"


NSString *const SERVER_ROOT = @"http://ideashouse.co"; //--root link request
NSString *const GATEWAY = @"http://ideashouse.co/subproj/snootyservice/gateway.php"; //--gateway to receive request
NSString *const APP = @"Snooty"; //--name app
NSString *const DEBUG_SERVICES = @"1"; //0 hidden NSLog


@interface SearchViewController ()
{
    NSArray *listRingtones;
    NSArray *searchKeyHistory;
    NSMutableArray *searchResult;
    BOOL isSearchOn;
    RemoteService *service;
    
    NSString *urlOfRingtone;




}
@property (nonatomic,strong) NSIndexPath *indexPathOld;
@property (nonatomic,strong ) RemoteService *service;
@end

@implementation SearchViewController
@synthesize service;
@synthesize indexPathOld = _indexPathOld;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
#pragma mark  - ViewDidLoad


/** Register notification center for view controller */
-(void) registerNotification
{
    
}


/** Set data when view did load.
 ** Be there. You can set up some variables, data, or any thing that have reletive to data type*/
-(void) setDataWhenViewDidLoad
{
    
    searchResult = [[NSMutableArray alloc] init];
    [self loadSearchHistory];
    [self setUpAnimationLoading];
}


-(void)loadSearchHistory
{
    SearchHistoryModel *searchHistoryModel = [SearchHistoryModel new];
    searchKeyHistory = [searchHistoryModel getTop5RowsInTableSearchHistory];
    searchHistoryModel = nil;
    isSearchOn = NO;
    [tableView_RingtoneSearch reloadData];

}


//-------------------------------------------------------
//
-(void)loadViewForDevice
{
    NSString *nibNameString = [Common checkDevice:@"SearchViewController"];
    [[NSBundle mainBundle] loadNibNamed:nibNameString owner:self options:nil];
}



/** Set view when view did load
 ** Be there. You can change the layout, view, button,..*/
-(void) setViewWhenViewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES];

    searchBar_RingtoneSearch.delegate = self;
    tableView_RingtoneSearch.delegate = self;
    tableView_RingtoneSearch.dataSource = self;
    
    float iosVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (iosVer < 7.0)
    {
        [self customizeSearchBar];
    }
    
    
}

-(void)customizeSearchBar
{

    if (IS_IPAD)
    {
        [searchBar_RingtoneSearch setSearchFieldBackgroundImage:[UIImage imageNamed:@"Search_bar_ipad_bg.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [searchBar_RingtoneSearch setSearchFieldBackgroundImage:[UIImage imageNamed:@"Search_bar_bg.png"] forState:UIControlStateNormal];

    }
    
//    UITextField *searchField;
//    NSUInteger numViews = [searchBar_RingtoneSearch.subviews count];
//    for(int i = 0; i < numViews; i++)
//    {
//        if([[searchBar_RingtoneSearch.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
//            searchField = [searchBar_RingtoneSearch.subviews objectAtIndex:i];
//        }
//    }
//    if(!(searchField == nil))
//    {
//
//        
//        [searchField.leftView setFrame:CGRectMake(searchField.frame.size.width / 2, searchField.leftView.frame.origin.y, searchField.leftView.frame.size.width, searchField.leftView.frame.size.height)];
//    }
//    
    
    for (UIView *searchbuttons in searchBar_RingtoneSearch.subviews)
    {
        if ([searchbuttons isKindOfClass:[UIButton class]])
        {
            
            UIButton *cancelButton = (UIButton*)searchbuttons;
            cancelButton.enabled = YES;
            [cancelButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
           [cancelButton setBackgroundImage:[UIImage new] forState:UIControlStateHighlighted];

            
            UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cancelButton.frame.size.width, cancelButton.frame.size.height)];
            [overlay setBackgroundColor:[UIColor whiteColor]];
            [overlay setUserInteractionEnabled:NO]; // This is important for the cancel button to work
            [cancelButton addSubview:overlay];
            
            UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(-3, 0, cancelButton.frame.size.width, cancelButton.frame.size.height)];
            [newLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
            [newLabel setTextColor:[UIColor grayColor]];
            // Text "Cancel" should be localized for other languages
            [newLabel setText:@"Cancel"];
            [newLabel setTextAlignment:NSTextAlignmentCenter];
            // This is important for the cancel button to work
            [newLabel setUserInteractionEnabled:NO];
            [overlay addSubview:newLabel];

            
            break;
        }
    }
    
    [searchBar_RingtoneSearch setBackgroundImage:[UIImage new]];
    
}


/** Begin view controller */
- (void)viewDidLoad
{
    [self registerNotification];
    [self setDataWhenViewDidLoad];
    [self setViewWhenViewDidLoad];
    [self setUpAnimationLoading];
    [super viewDidLoad];
    
}


/** Set data when view Will Appear. */
-(void) setDataWhenWillAppear
{
    
}


/** Begin view WillAppear */
-(void) viewWillAppear:(BOOL)animated
{
    [self setDataWhenWillAppear];
}

//-------------------------------------------------------
//
-(void)viewWillDisappear:(BOOL)animated
{
    [self destroyStreamer];
}

//-------------------------------------------------------
//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
#pragma mark -
#pragma mark UISearchbar Delegate
/******************************************************************************/

//-------------------------------------------------------
//
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self showDimBackground];
}


//-------------------------------------------------------
//
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    
    if ([self isRingtoneDownloading])
    {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Ringtone" message:@"Download is proccessing! Terminate and download later?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        [alertview show];
    }
    else
    {
        if ([Common checkNetWork])
        {
            [self destroyStreamer];
            [self hideDimBackground];
            [self searchRingtonesWithSearchText:searchBar.text];
            
        }
        else
        {
            [self showMessageWithTitleWithMessage:kMessageDownloadFaild];
        }
    }

}



-(BOOL)isRingtoneDownloading
{
    BOOL isDownloading = NO;
    //check if any ringtone is download
    for (int i = 0 ; i < searchResult.count; i++)
    {
        ASIHTTPRequest *request = [self getRequestByTag:i];
        if (request)
        {
            isDownloading = YES;
            break;
        }
    }

    return isDownloading;
}


//-------------------------------------------------------
//
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        //yes
        if ([Common checkNetWork])
        {
            [self destroyStreamer];
            [self hideDimBackground];
            [self searchRingtonesWithSearchText:searchBar_RingtoneSearch.text];
            
        }
        else
        {
            [self showMessageWithTitleWithMessage:kMessageDownloadFaild];
        }

    }

}


//-------------------------------------------------------
//
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self hideDimBackground];
    
    //if no result show search history again
    //else keep showing search result
    if (![self isRingtoneDownloading])
    {
        [self destroyStreamer];
        [self loadSearchHistory];

    }
    
}



//-------------------------------------------------------
//
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self searchBarCancelButtonClicked:searchBar];
}



#pragma mark ------ Methods for Searchbar

//-------------------------------------------------------
//
-(void)searchRingtonesWithSearchText: (NSString *)searchText
{
    
    [self showLoading];
    [searchResult removeAllObjects];
    [self loadServicesSearchRingtoneWithKeyWord:searchText];
    
    BOOL isAlreadyHistory = NO;
    for(NSString *searchHistoryKey in searchKeyHistory)
    {
        if ([searchText isEqualToString:searchHistoryKey])
        {
            isAlreadyHistory = YES;
            break;
        }
    }
    
    
    if (!isAlreadyHistory)
    {
        //update search key into history
        SearchHistoryModel *searchHistoryModel = [SearchHistoryModel new];
        SearchHistoryField *searchHistoryField = [SearchHistoryField new];
        searchHistoryField.searchKey = searchText;
        [searchHistoryModel createRowInTableSearchHistory:searchHistoryField];
        searchHistoryModel = nil;
    }
    
}



//-------------------------------------------------------
//dim when searchbar active
-(void)showDimBackground
{
    UIView *dimBackground = [[UIView alloc] initWithFrame:tableView_RingtoneSearch.frame];
    dimBackground.tag = 1000;
    dimBackground.backgroundColor = [UIColor blackColor];
    dimBackground.alpha = 0.5;
    [self.view addSubview:dimBackground];
	
    [UIView beginAnimations:@"FadeIn" context:nil];
    [UIView setAnimationDuration:0.5];
    dimBackground.alpha = 0.5;
    [UIView commitAnimations];
}




//-------------------------------------------------------
//light when searchbar inactive
-(void)hideDimBackground
{
    for(UIView *subView in self.view.subviews)
        if (subView.tag == 1000)
        {
            [UIView beginAnimations:@"FadeOut" context:nil];
            [UIView setAnimationDuration:0.5];
            subView.alpha = 0.0;
            [UIView commitAnimations];
            
            [subView removeFromSuperview];
        }
    
    [searchBar_RingtoneSearch resignFirstResponder];
}

/******************************************************************************/







#pragma mark -
#pragma mark Audio Streaming
/******************************************************************************/
//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
		[playbackTimer invalidate];
		playbackTimer = nil;
		
		[streamer stop];

		streamer = nil;
	}
}



//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamerWithURL: (NSURL *)url
{
	if (streamer)
	{
		return;
	}
    
	[self destroyStreamer];
	
	streamer = [[AudioStreamer alloc] initWithURL:url];
	streamer.shouldDisplayAlertOnError = YES;
	playbackTimer =
    [NSTimer
     scheduledTimerWithTimeInterval:0.1
     target:self
     selector:@selector(updateProgress:)
     userInfo:nil
     repeats:YES];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:streamer];
}



//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
    NSIndexPath *indexPath = [tableView_RingtoneSearch indexPathForSelectedRow];
    SearcTableCell *cell = (SearcTableCell *)[tableView_RingtoneSearch cellForRowAtIndexPath:indexPath];
    
    cell.btn_Download.hidden = NO;
    cell.imageView_Download.hidden = NO;
    
	if ([streamer isWaiting])
	{
		//-cell.label_playerTimer.hidden = YES;
        cell.imageView_Loading.hidden = NO;
        
        [animationImageView startAnimating];
	}
	else if ([streamer isPlaying])
	{
        cell.label_playerTimer.hidden = NO;
        cell.imageView_Loading.hidden = YES;
        
        [animationImageView stopAnimating];
	}
	else if ([streamer isIdle])
	{
        if ([self checkIsDownload:indexPath.row])
        {
            cell.btn_Download.enabled = YES;
            cell.imageView_Download.hidden = NO;
        }
        else {
            cell.btn_Download.hidden = YES;
            cell.imageView_Download.hidden = YES;
        }
        cell.imageView_Loading.hidden = YES;
        cell.label_playerTimer.hidden = YES;
        [animationImageView stopAnimating];
        
		[self destroyStreamer];
        
	}

}

//
// updateProgress:
//
// Invoked when the AudioStreamer
// reports that its playback progress has changed.
//
- (void)updateProgress:(NSTimer *)updatedTimer
{
    NSIndexPath *indexPath = [tableView_RingtoneSearch indexPathForSelectedRow];
    SearcTableCell *cell = (SearcTableCell *)[tableView_RingtoneSearch cellForRowAtIndexPath:indexPath];
	if (streamer.bitRate != 0.0)
	{
      
		float progress = streamer.progress;
		float duration = streamer.duration;

		if (duration > 0)
		{
            cell.label_playerTimer.text =  [Common returnMusicTimeFormatWithValue:duration - progress];
		}
        else
		{
		    cell.label_playerTimer.hidden = YES;
		}
        cell.btn_Download.hidden = NO;
        cell.imageView_Download.hidden = NO;
    }
    else
	{
        if ([self checkIsDownload:indexPath.row])
        {
            cell.btn_Download.enabled = YES;
            cell.imageView_Download.hidden = NO;
        }
        /*
        else {
            cell.btn_Download.hidden = YES;
            cell.imageView_Download.hidden = YES;
        }
        
        cell.label_playerTimer.hidden = YES;
        
        cell.imageView_Loading.hidden = YES;
        [animationImageView stopAnimating];
         */
	}

}

//-------------------------------------------------------
//
-(BOOL) checkIsDownload:(int) tag
{
    NSArray *queueArray = [networkQueue operations];
    
    if (queueArray.count == 0) {
        return NO;
    }
    
    for (ASIHTTPRequest *request in queueArray)
    {
        
        if (request.tag == tag)
        {
            
            return YES;
        }
    }
    return NO;
}



/******************************************************************************/







#pragma mark -
#pragma mark Animate Loading Buffering
/******************************************************************************/

//-------------------------------------------------------
//
-(UIImageView *)setUpAnimationLoading
{
    // Load images
    NSArray *imageNames = @[@"ProgressGear1_Gray_small.png",
                            @"ProgressGear2_Gray_small.png",
                            @"ProgressGear3_Gray_small.png",
                            @"ProgressGear4_Gray_small.png",
                            @"ProgressGear5_Gray_small.png",
                            @"ProgressGear6_Gray_small.png",
                            @"ProgressGear7_Gray_small.png",
                            @"ProgressGear8_Gray_small.png",
                            @"ProgressGear9_Gray_small.png",
                            @"ProgressGear10_Gray_small.png",
                            @"ProgressGear11_Gray_small.png",
                            @"ProgressGear12_Gray_small.png",
                            @"ProgressGear13_Gray_small.png",
                            @"ProgressGear14_Gray_small.png",
                            @"ProgressGear15_Gray_small.png",
                            @"ProgressGear16_Gray_small.png"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    // Normal Animation
    animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 15)];
    animationImageView.animationImages = images;
    animationImageView.animationDuration = 0.5;
    
    return animationImageView;
    
}



/******************************************************************************/






#pragma mark - Table view

/********************************************************************************/
#pragma mark - Table view data source

//-------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


//-------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if (isSearchOn)
    {
        return searchResult.count;
    }
    
    return searchKeyHistory.count;
    
    
}


//-------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"";
    
    if (IS_IPAD)
    {
        CellIdentifier = @"SearchiPadCell";
    }
    else
    {
        CellIdentifier = @"SearchTableCell";
    }
    
    
    //-- try to get a reusable cell --
    SearcTableCell *cell = (SearcTableCell *) [tableView_RingtoneSearch dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //-- create new cell if no reusable cell is available --
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
    if (cell == nil)
    {
         cell = (SearcTableCell *) [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.label_RingtoneName.font = [UIFont helveticaNeueRegularFontSize:17];
    
    if (isSearchOn)
    {
       
        NSDictionary *resultDict = [searchResult objectAtIndex:indexPath.row];
        cell.label_RingtoneName.text = [Common returnFileNameWithoutTheExtension: [resultDict valueForKey:@"n"]];
        
        cell.imageView_Download.image = [UIImage imageNamed:kDownloadingImageName];
        
        [cell.btn_Download addTarget:self action:@selector(downloadRingtone:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Download.tag = indexPath.row;
        int starNumber = [[resultDict valueForKey:@"nr"] intValue];
        
        
        [self setUpRatingStarForRingtoneWithStarAmount:cell andStarNumber:starNumber];
    
        
    }
    else
    {
        SearchHistoryField *searchHistoryField = (SearchHistoryField *)[searchKeyHistory objectAtIndex:indexPath.row];
        cell.label_RingtoneName.text = searchHistoryField.searchKey;
    }
    
    
    cell.imageView_Loading.hidden = YES;
    cell.label_playerTimer.hidden = YES;
    cell.imageView_Download.hidden = YES;
    cell.btn_Download.hidden = YES;
    [cell.imageView_Loading addSubview:animationImageView];
    
    return cell;
    
    
}


//-------------------------------------------------------
//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}





#pragma mark - Table view delegate

//-------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearcTableCell *cell = (SearcTableCell *) [tableView_RingtoneSearch cellForRowAtIndexPath:indexPath];
    if (isSearchOn)
    {
        [self setHiddenSelecttOld];
        cell.label_playerTimer.hidden = YES;
        
        cell.imageView_Loading.hidden = NO;
        //[cell.imageView_Loading addSubview:animationImageView];
        [animationImageView startAnimating];
        
        cell.imageView_Download.hidden = NO;
        cell.btn_Download.hidden = NO;
        
        NSURL *url = [self returnUrlOfRingtoneIndex:indexPath];
        [streamer stop];
        [self createStreamerWithURL:url];
        [streamer start];
        self.indexPathOld = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    }
    else
    {
        [self searchRingtonesWithSearchText:cell.label_RingtoneName.text];
    }
}



//-------------------------------------------------------
//
-(void) setHiddenSelecttOld
{
    
    SearcTableCell *cell = nil;
    if (self.indexPathOld)
    {
        cell = (SearcTableCell *) [tableView_RingtoneSearch cellForRowAtIndexPath:self.indexPathOld];
        [self hiddenCell:cell];
    }
    
    
}



//-------------------------------------------------------
//
-(void) hiddenCell:(SearcTableCell *) cell
{
    if ([self checkIsDownload:self.indexPathOld.row])
    {
        cell.btn_Download.enabled = YES;
        cell.imageView_Download.hidden = NO;
    }
    else {
        cell.btn_Download.hidden = YES;
        cell.imageView_Download.hidden = YES;
    }
    cell.imageView_Loading.hidden = YES;
    cell.label_playerTimer.hidden = YES;
    [animationImageView stopAnimating];
}




//-------------------------------------------------------
//
-(void)didDoubleTapOnCell:(SearcTableCell *)cell
{
    cell.imageView_Download.hidden = NO;
    cell.btn_Download.hidden = NO;
}
/********************************************************************************/





#pragma mark -  Load Services

#pragma mark -  Service Search Ringtone

/********************************************************************************/

//-------------------------------------------------------
//
- (void)loadServicesSearchRingtoneWithKeyWord:(NSString *)keyWord {
    

    //--full link url: http://ideashouse.co/subproj/snootyservice/gateway.php?app=Snooty&service=Tone&action=getRingtonesByKeyword&json=true&json_arguments=["Beautiful"]&time=time()
    
    //-- We need to get category by id.
    NSString *servicesName = @"Tone"; //--services name
    NSString *action = @"getRingtonesByKeyword"; //--action name
    NSArray *params = [NSArray arrayWithObjects:keyWord, nil]; //
    
     service = [[RemoteService alloc] initWithName:servicesName];
    
    [service setDelegate:self];
    [service invokeMethod:action params:params];
}





//--call back function when server reponse data. Name function = name_action + "Finished"
- (void) getRingtonesByKeywordFinished:(NSString *) data
{

//n: chính là name tone chưa có extension m4r
//    
//isf: là featured hay không. Mang giá trị đúng, sai
//    
//nr: số rating của một tone
//    
//cm: số lượt download
//    
//cid: tone này đang nằm trong category_id
//    
//kt: từ khoá để tìm ra tones này.
    
    
 /*
    {
        tones =     (
                     {
                         cid = 82;
                         cm = 703;
                         isf = 1;
                         kt = "Classic,Symphony,sunshine";
                         n = "Beautiful Arabic.m4r";
                         nr = 5;
                     },
                     {
                         cid = 63;
                         cm = 740;
                         isf = 0;
                         kt = "birds,special,animals,unique,great";
                         n = "Birds Beautifull.m4r";
                         nr = 4;
                     },
                     {
                         cid = 83;
                         cm = 843;
                         isf = 0;
                         kt = "rington,unique,Country";
                         n = "Beautiful Azan.m4r";
                         nr = 5;
                     }
                     );
        url = "http://ideashouse.co/subproj/snootyservice/Applications/Snooty/Images/";
    }
    
    */
    
    [self dismissLoading];
    //NSLog(@"data return: %@", data);
    searchResult = [(NSDictionary *)data valueForKey:@"tones"];
   // NSLog(@"listRingtones: %@", searchResult);
    urlOfRingtone = [(NSDictionary *)data valueForKey:@"url"];
    
    if(searchResult.count != 0)
    {
         isSearchOn = YES;
        [tableView_RingtoneSearch reloadData];
    }
    else
    {
        [self loadSearchHistory];
        [self showMessageWithTitleWithMessage:@"No ringtone match"];
    }
    
}



//-------------------------------------------------------
//
//--call back function when server reponse data. Name function = name_action + "Failed"
- (void) getRingtonesByKeywordFailed:(id) data
{
    [self dismissLoading];
    NSLog(@"Failed get search ringtone result");
}



/********************************************************************************/




#pragma mark -
#pragma mark Show hide loading

/********************************************************************************/
//-----------------------------------------------------------------
//show loading

-(void) showLoading
{
    //--show loadding
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.dimBackground = YES;
    progressHUD.labelText = @"Please wait...";

}



//-----------------------------------------------------------------
//hidden loading
-(void) dismissLoading
{
    //--hide loading when finished all step
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


/********************************************************************************/





#pragma mark -
#pragma mark Dowload
/******************************************************************************/

//-------------------------------------------------------
//
-(void)downloadRingtone:(UIButton *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSURL *url = [self returnUrlOfRingtoneIndex:indexPath];
    
    [self downloadWithMultipleCell:url WithRingtoneInfo:[NSDictionary dictionaryWithObject:indexPath forKey:@"RingtoneIndex"]];
    

}


//-------------------------------------------------------
//
-(void)downloadWithMultipleCell: (NSURL *)url WithRingtoneInfo: (NSDictionary *)ringtoneIndex
{

	if (!networkQueue) {
		networkQueue = [[ASINetworkQueue alloc] init];
	}

	//[networkQueue reset];

	[networkQueue setRequestDidFinishSelector:@selector(requestDone:)];
	[networkQueue setRequestDidFailSelector:@selector(requestWentWrong:)];
    [networkQueue setShowAccurateProgress:YES];
    [networkQueue setShouldCancelAllRequestsOnFailure:NO];
	[networkQueue setDelegate:self];
	
	ASIHTTPRequest *request;
	request = [ASIHTTPRequest requestWithURL:url];
    
    
    //Index
    [request setUserInfo:ringtoneIndex];
    
    
    NSIndexPath *downloadIndex = (NSIndexPath *)[ringtoneIndex valueForKey:@"RingtoneIndex"];
    NSDictionary *ringtoneInfo = (NSDictionary *)[searchResult objectAtIndex:downloadIndex.row];
    
    SearcTableCell *cell = (SearcTableCell *)[tableView_RingtoneSearch cellForRowAtIndexPath:downloadIndex];
    
    
    //set DAProgress
    cell.dimOverLayProgress = [[DAProgressOverlayView alloc] initWithFrame:cell.imageView_Download.bounds];
    [cell.imageView_Download addSubview: cell.dimOverLayProgress];
    [cell.dimOverLayProgress displayOperationWillTriggerAnimation];
    [request setDownloadProgressDelegate:cell.dimOverLayProgress];
    
    cell.btn_Download.enabled = NO;
    
    
    
    //set download path

    NSString *ringtoneFilePath = [Common savePathForDownloadedRingtonesWithRingtoneName:[ringtoneInfo valueForKey:@"n"]];
	[request setDownloadDestinationPath:ringtoneFilePath];
    
    [request setTag:downloadIndex.row];
    
	[networkQueue addOperation:request];
	[networkQueue go];
   
}




//-------------------------------------------------------
//
-(void)requestDone: (ASIHTTPRequest *)request
{
    NSIndexPath *index = (NSIndexPath *)[request.userInfo valueForKey:@"RingtoneIndex"];
    SearcTableCell *cell = (SearcTableCell *)[tableView_RingtoneSearch cellForRowAtIndexPath:index];
    
    cell.imageView_Download.image = [UIImage imageNamed:kDownloadedImageName];
    cell.btn_Download.enabled = NO;
    [self performSelector:@selector(hidenDownloadImage:) withObject:index afterDelay:1.0f];
    
    [self storeInDatabaseWithIndex:index];

}


-(void)storeInDatabaseWithIndex: (NSIndexPath *)index
{
    NSDictionary *ringtoneInfo = (NSDictionary *)[searchResult objectAtIndex:index.row];
    SongModel *songModel = [SongModel new];
    SongField *songField = [SongField new];
    songField.name = [Common returnFileNameWithoutTheExtension: [ringtoneInfo valueForKey:@"n"]];
    songField.date = [Common formatStringFromDate:[NSDate date]];
    
    //songField.path = [Common savePathForDownloadedRingtonesWithRingtoneName:[ringtoneInfo valueForKey:@"n"]];
    songField.type = @"0";
    
    
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:[self returnUrlOfRingtoneIndex: index] options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    songField.duration = [NSString stringWithFormat:@"%f", audioDurationSeconds];
    songField.url = [NSString stringWithFormat:@"%@", [self returnUrlOfRingtoneIndex:index]];
    
    [songModel createRowInSongTable:songField];
    songModel = nil;
}

//-------------------------------------------------------
//
-(void)requestWentWrong: (ASIHTTPRequest *)request
{
    
    NSIndexPath *index = (NSIndexPath *)[request.userInfo valueForKey:@"RingtoneIndex"];
    SearcTableCell *cell = (SearcTableCell *)[tableView_RingtoneSearch cellForRowAtIndexPath:index];
    
    cell.imageView_Download.image = [UIImage imageNamed:kDownloadingImageName];
    [cell.dimOverLayProgress removeFromSuperview];
    cell.dimOverLayProgress = nil;

    [self showMessageWithTitleWithMessage:@"Lost connection! Please check your connection"];
}



//-------------------------------------------------------
//
-(void)hidenDownloadImage: (NSIndexPath *)index
{
    SearcTableCell *cell = (SearcTableCell *)[tableView_RingtoneSearch cellForRowAtIndexPath:index];
    cell.imageView_Download.hidden = YES;
    
}
/******************************************************************************/






#pragma mark -
#pragma mark ScrollView Delegate
/******************************************************************************/

//-------------------------------------------------------
//
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setProgressCellTableDownload];
    
}


//-------------------------------------------------------
//
-(void) setProgressCellTableDownload
{
    NSArray *queueArray = [networkQueue operations];
    for (ASIHTTPRequest *request in queueArray)
    {
        if (request)
        {
            SearcTableCell  *cell  =(SearcTableCell *) [tableView_RingtoneSearch cellForRowAtIndexPath:[NSIndexPath indexPathForRow:request.tag inSection:0]];
            
            cell.imageView_Download.hidden = NO;
            cell.dimOverLayProgress = [[DAProgressOverlayView alloc] initWithFrame:cell.imageView_Download.bounds];
            [cell.imageView_Download addSubview: cell.dimOverLayProgress];
            [cell.dimOverLayProgress displayOperationWillTriggerAnimation];
            [request setDownloadProgressDelegate:cell.dimOverLayProgress];
            
        }
        
    }
}




//-------------------------------------------------------
//
-(ASIHTTPRequest *) getRequestByTag:(int) tag
{
    NSArray *queueArray = [networkQueue operations];
    if (queueArray.count == 0) {
        return nil;
    }
    
    for (ASIHTTPRequest *request in queueArray)
    {
       
        if (request.tag == tag)
        {
         
            return request;
        }
    }
    return nil;
}

/******************************************************************************/




#pragma mark -
#pragma mark Ultility Methods
/******************************************************************************/
//-------------------------------------------------------
//set up rating star
-(void)setUpRatingStarForRingtoneWithStarAmount: (SearcTableCell *)cell andStarNumber: (int)starNumber
{
    UIImage *imageStarFilled = [UIImage imageNamed:@"Star_filled.png"];
    UIImage *imageStarUnFilled = [UIImage imageNamed:@"Star_unfilled.png"];

    
    for (int i = 0 ; i < 5; i++)
    {
        if (i <= starNumber - 1)
        {
            UIImageView *imageViewFilled = [[UIImageView alloc] initWithFrame:CGRectMake((imageStarFilled.size.width/2 + 2)* i, 0, imageStarFilled.size.width/2, imageStarFilled.size.height/2)];
            imageViewFilled.image = imageStarFilled;
            [cell.imageView_Rating addSubview:imageViewFilled];
        }
        else
        {
            UIImageView *imageViewUnFilled = [[UIImageView alloc] initWithFrame:CGRectMake((imageStarUnFilled.size.width/2 + 2) * i, 0, imageStarUnFilled.size.width/2, imageStarUnFilled.size.height/2)];
            imageViewUnFilled.image = imageStarUnFilled;
            [cell.imageView_Rating addSubview:imageViewUnFilled];
            
        }
    }
}


//-------------------------------------------------------
//
-(NSURL *)returnUrlOfRingtoneIndex: (NSIndexPath *)indexPath
{
    NSDictionary *ringtoneInfoDict = [searchResult objectAtIndex:indexPath.row];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", urlOfRingtone,[ringtoneInfoDict valueForKey:@"n"]];
    NSString* webStringURL = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
    
    return url;
}





//-------------------------------------------------------

-(void) showMessageWithTitleWithMessage:(NSString *) message
{
    UIAlertView *alertview = nil;
    alertview = [[UIAlertView alloc] initWithTitle:@"Ringtone" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];

    [alertview show];
    
}

/******************************************************************************/


@end
