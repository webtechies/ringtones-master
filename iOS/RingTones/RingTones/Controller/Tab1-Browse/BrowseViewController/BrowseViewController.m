//
//  BrowseViewController.m
//  RingTones
//
//  Created by Vuong Nguyen on 12/12/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import "BrowseViewController.h"
#import "Common.h"
#import "SearcTableCell.h"
#import "CalegoriesCell.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "LoadRequest.h"
#import "DetailCategoryViewController.h"

#define kDownloadingImageName @"Download.png"
#define kDownloadedImageName @"Download_completed.png"


//NSString *const SERVER_ROOT = @"http://ideashouse.co"; //--root link request
//NSString *const GATEWAY = @"http://ideashouse.co/subproj/snootyservice/gateway.php"; //--gateway to receive request
//NSString *const APP = @"Snooty"; //--name app
//NSString *const DEBUG_SERVICES = @"1"; //0 hidden NSLog


@interface BrowseViewController ()
{
    RemoteService *service;
    NSString *urlOfRingtone;
    ASINetworkQueue  *networkQueuePopular;

}
@property (nonatomic,assign) float audioDurationSeconds;
@property (nonatomic,strong) LoadRequest *loadRequest;

@property (nonatomic,strong) ASINetworkQueue *networkQueuePopular;
@property (nonatomic,strong) RemoteService *service;
@property (nonatomic,strong) NSMutableArray *listPopular;
@property (nonatomic,strong) NSMutableArray *listCategories;

@property (nonatomic,strong) NSString *urlNextPopular;
@property (nonatomic,strong) NSIndexPath *indexPathOldPopular;

@end

@implementation BrowseViewController

@synthesize service;
@synthesize networkQueuePopular;

@synthesize urlNextPopular = _urlNextPopular;
@synthesize loadRequest = _loadRequest;
@synthesize indexPathOldPopular = _indexPathOldPopular;
@synthesize audioDurationSeconds = _audioDurationSeconds;
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
    
    
}



/** Set view when view did load
 ** Be there. You can change the layout, view, button,..*/
-(void) setViewWhenViewDidLoad
{
  
    isPopular = YES;
 
    [self performSelectorInBackground:@selector(setUpAnimationLoading) withObject:nil];
    [self getDataRemoteServicesPopular];
    [self addTableViewMorePopular];
    [self setFrameTableView];
}

/** Begin view controller */
- (void)viewDidLoad
{
    [self registerNotification];
    [self setDataWhenViewDidLoad];
    [self setViewWhenViewDidLoad];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) setFrameTableView
{
    if (isPopular) {
        tablePopular.hidden = NO;
        tableCategories.hidden = YES;
    }
    else
    {
        tableCategories.hidden = NO;
        tablePopular.hidden = YES;
    }
    
    int height = 44;
    viewSegment.hidden = NO;
    int heightSroll = 0;
    
    if (isPopular == NO)
    {
        heightSroll = 49;
    }
    tablePopular.frame = CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height  - 44 - heightSroll );
    tableCategories.frame = CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height - 44 - heightSroll );
 
}



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


/********************************************************************************/
#pragma mark - Remote Services



-(void) getDataRemoteServicesPopular
{
    //[self showLoading];
    NSString *servicesName = @"Tone"; //--services name
    NSString *action = @"getPopularAndCategories"; //--action name
    NSArray *params = [NSArray arrayWithObjects: nil]; //
    
    service = [[RemoteService alloc] initWithName:servicesName];
  
    [service setDelegate:self];
    [service invokeMethod:action params:params];
}


- (void) getPopularAndCategoriesFinished:(NSString *) data
{
   
    //NSLog(@"data %@",data);
    self.listCategories = [data valueForKey:@"cats"];
    NSMutableArray *array = [data valueForKey:@"tos"];
    self.listPopular = [NSMutableArray arrayWithArray:array];
    self.urlNextPopular = [data valueForKey:@"next_popular"];
    urlOfRingtone = [data valueForKey:@"url"];
    [tablePopular reloadData];
    //[tableCategories reloadData];
    //[self dismissLoading];
  
    
  
}


//--call back function when server reponse data. Name function = name_action + "Failed"
- (void) getPopularAndCategoriesFailed:(id) data
{
    //[self dismissLoading];
    [self showMessageWithTitleWithMessage:kMessageDownloadFaild];
    NSLog(@"Failed get search ringtone result");
}

/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */


/********************************************************************************/
#pragma mark - Load More Popular


-(void) addTableViewMorePopular
{
   
    [tablePopular addInfiniteScrollingWithActionHandler:^{
     
        if (isPopular)
        {
            if (self.urlNextPopular)
            {
                [self requestGetLoadMore];
            }
            else{
       
            }
        }
        
    }];
    [tablePopular triggerPullToRefresh]; 
    // trigger the refresh manually at the end of viewDidLoad
 
    
    
  
}


-(void) requestGetLoadMore
{
    if (!_loadRequest) {
        _loadRequest = [[LoadRequest alloc] init];
    }
    //[self showLoading];
    [_loadRequest requestGetLoadMorePopular:self.urlNextPopular];
    [_loadRequest setDelegate:self];
    
}


-(void) finished_requestGetLoadMorePopular:(NSDictionary *) data
{
   
    if (isPopular) {
        [tablePopular.infiniteScrollingView stopAnimating];
        NSMutableArray *array = [[data valueForKey:@"data"] valueForKey:@"tones"];
        [self.listPopular addObjectsFromArray:array];
        [tablePopular reloadData];
        self.urlNextPopular = [data valueForKey:@"next_popular"];
    }
    else{
        
    }
    
    //[self dismissLoading];
}


-(void) failed_requestGetLoadMorePopular
{
      if (isPopular) {
         [tablePopular.infiniteScrollingView stopAnimating];
      }
      else{
          
      }
    //[self dismissLoading];
    [self showMessageWithTitleWithMessage:kMessageDownloadFaild];
}



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
    if (isPopular)
    {
        return self.listPopular.count;
    }

    
    return self.listCategories.count;
    
    
}


//-------------------------------------------------------
//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}



//-------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == tablePopular)
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
        SearcTableCell *cell = (SearcTableCell *) [tablePopular dequeueReusableCellWithIdentifier:CellIdentifier];
        
        //-- create new cell if no reusable cell is available --
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        if (cell == nil) {
            
            
           cell = (SearcTableCell *) [nib objectAtIndex:0];
            
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell = [self setDataForCell:cell withIndexPath:indexPath];
        return cell;
 
    }
  
    static NSString *CellIdentifier = @"";
    
    if (IS_IPAD)
    {
        CellIdentifier = @"IpadCalegoriesCell";
    }
    else
    {
        CellIdentifier = @"CalegoriesCell";
    }
  
    //-- try to get a reusable cell --
    CalegoriesCell *cell = (CalegoriesCell *) [tableCategories dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //-- create new cell if no reusable cell is available --
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
    if (cell == nil) {
        
        
        cell = (CalegoriesCell *) [nib objectAtIndex:0];
    
        
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell = [self setDataForCellCategories:cell withIndexPath:indexPath];
    return cell;
    
}



-(SearcTableCell *) setDataForCell:(SearcTableCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
   
 
    cell.label_RingtoneName.font = [UIFont helveticaNeueRegularFontSize:17];
    NSDictionary *resultDict  = [self.listPopular objectAtIndex:indexPath.row];
 
    cell.label_RingtoneName.text = [self returnFileNameWithoutTheExtension: [resultDict valueForKey:@"n"]];
    
    cell.imageView_Download.image = [UIImage imageNamed:kDownloadingImageName];
    
    [cell.btn_Download addTarget:self action:@selector(downloadRingtone:) forControlEvents:UIControlEventTouchUpInside];
    
    int starNumber = [[resultDict valueForKey:@"nr"] intValue];
    
    [self setUpRatingStarForRingtoneWithStarAmount:cell andStarNumber:starNumber];
    cell.imageView_Loading.hidden = YES;
    cell.label_playerTimer.hidden = YES;
    cell.imageView_Download.hidden = YES;
    cell.btn_Download.hidden = YES;
    [cell.imageView_Loading addSubview:animationImageView];
   
    return cell;
}


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




-(CalegoriesCell *) setDataForCellCategories:(CalegoriesCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    NSDictionary *resultDict  = (NSDictionary*) [self.listCategories objectAtIndex:indexPath.row];
    cell.lblCategoryName.text = [resultDict objectForKey:@"cn"];
    cell.lblCategoryName.font = [UIFont helveticaNeueRegularFontSize:17];
    cell.lblAmountRingtone.text = [resultDict objectForKey:@"noft"];
    cell.lblAmountRingtone.font = [UIFont helveticaNeueRegularFontSize:13];
    return cell;
}


#pragma mark - Table view delegate

//-------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearcTableCell *cell = nil;
    if (isPopular)
    {
        cell = (SearcTableCell *) [tablePopular cellForRowAtIndexPath:indexPath];
    }
    else
    {
        cell = (SearcTableCell *) [tableCategories cellForRowAtIndexPath:indexPath];
    }
    
    if (isPopular)
    {
         [self setSeclectCellisRingtone:cell andIndex:indexPath];  
    
    }
    else{
         [self setSeclectCellIsCategory:cell andIndex:indexPath];
    }
   

}


-(void) setSeclectCellIsCategory:(SearcTableCell *) cell andIndex:(NSIndexPath *)indexPath
{
    [self setHiddenSelecttOld];
    [streamer stop];
   	[self destroyStreamer];
    
    DetailCategoryViewController *detailCategoryViewController = [[DetailCategoryViewController alloc] initWithNibName:[Common checkDevice:@"DetailCategoryViewController"] bundle:nil];
    NSDictionary *resultDict  = (NSDictionary*) [self.listCategories objectAtIndex:indexPath.row];
    detailCategoryViewController.idCategory = [resultDict objectForKey:@"cid"];
    detailCategoryViewController.titleStr = [resultDict objectForKey:@"cn"];
    
    [self.navigationController pushViewController:detailCategoryViewController animated:YES];
    
}

-(void) setSeclectCellisRingtone:(SearcTableCell *) cell andIndex:(NSIndexPath *)indexPath

{
    [self setHiddenSelecttOld];
    cell.label_playerTimer.hidden = YES;
    
    cell.imageView_Loading.hidden = NO;
    [cell.imageView_Loading addSubview:animationImageView];
    [animationImageView startAnimating];
    
    cell.imageView_Download.hidden = NO;
    cell.btn_Download.hidden = NO;
    
    NSURL *url = [self returnUrlOfRingtoneIndex:indexPath];
    [streamer stop];
    [self destroyStreamer];
    [self createStreamerWithURL:url];
    [streamer start];
    
    if (isPopular) {
        self.indexPathOldPopular = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    }
    
     //AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    // CMTime audioDuration = audioAsset.duration;
     //self.audioDurationSeconds = CMTimeGetSeconds(audioDuration);
   
    
}


-(void) setHiddenSelecttOld
{
  
    SearcTableCell *cell = nil;
    if (self.indexPathOldPopular)
    {
        cell = (SearcTableCell *) [tablePopular cellForRowAtIndexPath:self.indexPathOldPopular];
        [self hiddenCell:cell];
    }


}

-(void) hiddenCell:(SearcTableCell *) cell
{
    if ([self checkIsDownload:self.indexPathOldPopular.row])
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


-(NSURL *)returnUrlOfRingtoneIndex: (NSIndexPath *)indexPath
{
    NSDictionary * ringtoneInfoDict = [self.listPopular objectAtIndex:indexPath.row];
  

    NSString *urlStr = [NSString stringWithFormat:@"%@%@", urlOfRingtone,[ringtoneInfoDict valueForKey:@"n"]];
    NSString* webStringURL = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
    
    return url;
}


/********************************************************************************/



#pragma mark -
#pragma mark ScrollView Delegate
/******************************************************************************/

//-------------------------------------------------------

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setProgressCellTableDownload];
    
}


//-------------------------------------------------------
//
-(void) setProgressCellTableDownload
{
    if (isPopular)
    {
        NSArray *queueArray = [networkQueuePopular operations];
        for (ASIHTTPRequest *request in queueArray)
        {
            if (request)
            {
                SearcTableCell  *cell  =(SearcTableCell *) [tablePopular cellForRowAtIndexPath:[NSIndexPath indexPathForRow:request.tag inSection:0]];
                
                cell.imageView_Download.hidden = NO;
                cell.dimOverLayProgress = [[DAProgressOverlayView alloc] initWithFrame:cell.imageView_Download.bounds];
                [cell.imageView_Download addSubview: cell.dimOverLayProgress];
                [cell.dimOverLayProgress displayOperationWillTriggerAnimation];
                [request setDownloadProgressDelegate:cell.dimOverLayProgress];
                
            }
            
        }
    }
 

}




//-------------------------------------------------------
//
-(ASIHTTPRequest *) getRequestByTag:(int) tag
{
    NSArray *queueArray = [networkQueuePopular operations];

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




#pragma mark -
#pragma mark Dowload
/******************************************************************************/

//-------------------------------------------------------
//
-(void)downloadRingtone:(id)sender
{
    NSIndexPath *indexPath = nil;
    if (isPopular)
    {
        indexPath = [tablePopular indexPathForSelectedRow];
    }
    else {
        indexPath = [tableCategories indexPathForSelectedRow];
    }
   
    NSURL *url = [self returnUrlOfRingtoneIndex:indexPath];
    
    [self downloadWithMultipleCell:url WithRingtoneInfo:[NSDictionary dictionaryWithObject:indexPath forKey:@"RingtoneIndex"]];
    
    
}


//-------------------------------------------------------
//
-(void)downloadWithMultipleCell: (NSURL *)url WithRingtoneInfo: (NSDictionary *)ringtoneIndex
{
    ASINetworkQueue *networkQueue = nil;
 
    if (!networkQueuePopular) {
        networkQueuePopular = [[ASINetworkQueue alloc] init];
    }
    networkQueue = self.networkQueuePopular;
 
	
   
	//[networkQueue reset];
    
	[networkQueue setRequestDidFinishSelector:@selector(requestDone:)];
	[networkQueue setRequestDidFailSelector:@selector(requestWentWrong:)];
    [networkQueue setShowAccurateProgress:YES];
    [networkQueue setShouldCancelAllRequestsOnFailure:NO];
	[networkQueue setDelegate:self];
	
	ASIHTTPRequest *request;
	request = [ASIHTTPRequest requestWithURL:url];
    
    

    //Index
    //[request setUserInfo:[NSDictionary dictionaryWithObject:isPopularStr forKey:@"Popular"]];
    
 
    
    
    NSIndexPath *downloadIndex = (NSIndexPath *)[ringtoneIndex valueForKey:@"RingtoneIndex"];
    
    NSDictionary *ringtoneInfo =  nil;
    SearcTableCell *cell = nil;
    ringtoneInfo = (NSDictionary *)[self.listPopular objectAtIndex:downloadIndex.row];
    cell = (SearcTableCell *)[tablePopular cellForRowAtIndexPath:downloadIndex];
  
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
    NSIndexPath *index = [NSIndexPath indexPathForRow:request.tag inSection:0];
   // NSString *isPopularStr = (NSString *)[request.userInfo  valueForKey:@"Popular"];
    //NSLog(@"isPopularStr %@",isPopularStr);
   // NSIndexPath *index = (NSIndexPath *)[request.userInfo valueForKey:@"RingtoneIndex"];
    SearcTableCell * cell = (SearcTableCell *)[tablePopular cellForRowAtIndexPath:index];

    cell.imageView_Download.image = [UIImage imageNamed:kDownloadedImageName];
    cell.btn_Download.enabled = NO;
    [self performSelector:@selector(hidenDownloadImage:) withObject:index afterDelay:1.0f];
    
    [self storeInDatabaseWithIndex:index];
    [self requestUpdateCountingIndex:index];
    
}


-(void)requestUpdateCountingIndex:(NSIndexPath *) index
{
  
}


-(void)storeInDatabaseWithIndex: (NSIndexPath *)index
{
    NSDictionary *ringtoneInfo = (NSDictionary *)[self.listPopular objectAtIndex:index.row];
 

    SongModel *songModel = [SongModel new];
    SongField *songField = [SongField new];
    songField.name = [ringtoneInfo valueForKey:@"n"];
    songField.date = [Common formatStringFromDate:[NSDate date]];
    songField.path = [Common savePathForDownloadedRingtonesWithRingtoneName:[ringtoneInfo valueForKey:@"n"]];
    songField.type = @"0";
    [songModel createRowInSongTable:songField];
    songModel = nil;
}

//-------------------------------------------------------
//
-(void)requestWentWrong: (ASIHTTPRequest *)request
{
    
    NSIndexPath *index = (NSIndexPath *)[request.userInfo valueForKey:@"RingtoneIndex"];
    SearcTableCell *cell =  nil;
    if (isPopular)
    {
        cell = (SearcTableCell *)[tablePopular cellForRowAtIndexPath:index];
    }

    
    cell.imageView_Download.hidden = YES;
    cell.imageView_Download.image = [UIImage imageNamed:kDownloadingImageName];
    [cell.dimOverLayProgress removeFromSuperview];
    cell.dimOverLayProgress = nil;
    cell.btn_Download.enabled = YES;
    [self showMessageWithTitleWithMessage:kMessageDownloadFaild];
}



//-------------------------------------------------------
//
-(void)hidenDownloadImage: (NSIndexPath *)index
{
    SearcTableCell *cell =  nil;
    if (isPopular)
    {
        cell = (SearcTableCell *)[tablePopular cellForRowAtIndexPath:index];
    }
    else{
        cell = (SearcTableCell *)[tableCategories cellForRowAtIndexPath:index];
        
    }
    cell.imageView_Download.hidden = YES;
    cell.imageView_Download.image = [UIImage imageNamed:kDownloadingImageName];
    [cell.dimOverLayProgress removeFromSuperview];
    cell.dimOverLayProgress = nil;
    cell.btn_Download.enabled = YES;
}
/******************************************************************************/




/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
#pragma mark  - IBAction


- (IBAction)btPopular_Pressed:(id)sender {
    
    isPopular = YES;
    [self setImageSegment];
    [self setFrameTableView];
    //[tablePopular setShowsInfiniteScrolling:YES];
    [tablePopular reloadData];
}


- (IBAction)btCategories_Pressed:(id)sender
{
    isPopular = NO;
    [self setImageSegment];
    [self setFrameTableView];
    if (isPopular == NO)
    {
        [tableCategories reloadData];
        //[tablePopular setShowsInfiniteScrolling:NO];
        [tableCategories setShowsInfiniteScrolling:NO];
   
    }
}

-(void) setImageSegment
{
    if (isPopular)
    {
        bgSegment.image = [UIImage imageNamed:@"Top_cell1.png"];
        [btPopular setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btCategories setTitleColor:[UIColor colorWithRed:253/255.0f green:43/255.0f blue:83/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    }
    else {
        bgSegment.image = [UIImage imageNamed:@"Top_cell2.png"];
        
        [btCategories setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btPopular setTitleColor:[UIColor colorWithRed:253/255.0f green:43/255.0f blue:83/255.0f alpha:1.0] forState:UIControlStateNormal];

    }
}



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
     selector:@selector(updateProgressPopular:)
     userInfo:nil
     repeats:YES];
    
 	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChangedPopular:)
     name:ASStatusChangedNotification
     object:streamer];

}


//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChangedPopular:(NSNotification *)aNotification
{
  
    
    NSIndexPath *indexPath = nil;
    SearcTableCell *cell = nil;
    indexPath = [tablePopular indexPathForSelectedRow];
    cell = (SearcTableCell *)[tablePopular cellForRowAtIndexPath:indexPath];
    [self processStreamer:cell andIndex:indexPath];


}


-(void) processStreamer:(SearcTableCell *) cell andIndex:(NSIndexPath *) indexPath
{

    if ([streamer isPaused]) {
        NSLog(@"pause");
    }
    cell.btn_Download.hidden = NO;
    cell.imageView_Download.hidden = NO;
	if ([streamer isWaiting])
	{
		cell.label_playerTimer.hidden = NO;
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
- (void)updateProgressPopular:(NSTimer *)updatedTimer
{
    NSIndexPath *indexPath = nil;
    SearcTableCell *cell = nil;
    indexPath = [tablePopular indexPathForSelectedRow];
    cell = (SearcTableCell *)[tablePopular cellForRowAtIndexPath:indexPath];
    
	if (streamer.bitRate != 0.0)
	{


        
		float progress = streamer.progress;
		float duration = streamer.duration;
       // NSLog(@"progress %f",progress);
         //NSLog(@"duration %f",duration);
		if (duration > 0)
		{
            cell.label_playerTimer.hidden = NO;
            NSString *str =  [self returnMusicTimeFormatWithValue:duration - progress];
            if (progress >= 0.2)
            {
                cell.label_playerTimer.text =  [NSString stringWithFormat:@"-%@",str];
            }
            else {
                cell.label_playerTimer.text =  str;
            }
          
            //--NSLog(@" cell.label_playerTimer.text  %@", cell.label_playerTimer.text );
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


-(BOOL) checkIsDownload:(int) tag
{
    NSArray *queueArray = [networkQueuePopular operations];
    
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



//-------------------------------------------------------
//
-(NSString *)returnMusicTimeFormatWithValue: (float)value
{
    if (value < 0) {
        value = 0.0f;
    }
    NSDate* d = [NSDate dateWithTimeIntervalSince1970:value];
    //Then specify output format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"m:ss"];
    
    NSString *timeLeft = [dateFormatter stringFromDate:d];
    
    return timeLeft;
    
}



//-------------------------------------------------------
//
-(NSString *) returnFileNameWithoutTheExtension:(NSString *)fileName
{
    NSString *fileName_extension = [fileName pathExtension];
    NSInteger fileNameExtensionLength = [fileName_extension length];
    NSInteger fileName_length = [fileName length];
    fileName_length = fileName_length - (1 + fileNameExtensionLength);
    return [ fileName substringWithRange:NSMakeRange(0, fileName_length) ];
}


/******************************************************************************/



-(void) showMessageWithTitleWithMessage:(NSString *) message
{
    UIAlertView *alertview = nil;
    alertview = [[UIAlertView alloc] initWithTitle:@"Announce" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alertview show];
    
}


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

@end
