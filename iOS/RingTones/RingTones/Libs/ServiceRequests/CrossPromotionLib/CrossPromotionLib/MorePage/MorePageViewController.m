//
//  MorePageViewController.m
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/2/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import "MorePageViewController.h"
#import "FileManager.h"
#import "MPTableViewCell.h"
#import "AppRecord.h"
#import "IconDownloader.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIFormDataRequest.h"
#import "SBJsonParser.h"


@interface MorePageViewController ()
@property (nonatomic, retain) NSArray *listData;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) ASIFormDataRequest *request;

@end




@implementation MorePageViewController

static CGFloat heighForRow = 44;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void) loadView
{
    if (self.nibBundle != nil){
        [super loadView];
    }else{
        
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        
        CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
        CGRect screenBoundsHasNavigatationBar = CGRectMake(0, 0, applicationFrame.size.width, applicationFrame.size.height - 44);
        
        CGRect frame = self.wantsFullScreenLayout? screenBounds:screenBoundsHasNavigatationBar;
        self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
        self.view.autoresizesSubviews =  YES;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
        
    }
    
    
    [self addTitle];
    [self initTableView];
}


/**
 For each rows, we need to set height for this, if NO, we will set defaults is 44px.
 **/
- (id) initWithHeightForRows:(CGFloat) height withData:(NSString *) nameFileData withIconUnActive:(UIImage *) imageUnactive
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        heighForRow = height;
        self.mpImageUnActive =  imageUnactive; //--add more
        
      
        
      
    }
    
    return self;
}


+ (id) initWithHeightForRows:(CGFloat) height withData:(NSString *) nameFileData  withIconUnActive:imageUnactive
{
    return [[[self alloc] initWithHeightForRows:height withData:nameFileData withIconUnActive:imageUnactive] autorelease];
}


- (id) initWithWithData:(NSString *) nameFileData withIconUnActive:imageUnactive
{
    
    self =  [self initWithHeightForRows:heighForRow withData:nameFileData withIconUnActive:imageUnactive];
    
    if (self)
    {
       
    }
    
    return self;
}


+ (id) initWithWithData:(NSString *) nameFileData withIconUnActive:(UIImage *)imageUnactive
{
    return [[[self alloc] initWithWithData:nameFileData withIconUnActive:imageUnactive] autorelease];
}



#pragma mark -  ASIHTTP request


-(void) loadRequest
{
    NSURL *url  = [NSURL URLWithString:@"http://192.241.128.84/service/getlistapp"];
    
    self.request = [[ASIFormDataRequest alloc] initWithURL:url];
    [_request setTimeOutSeconds:180];
    
    if (self.adUnitId)
    {
#ifdef DEBUG
        NSLog(@"adUnitId more page: %@", self.adUnitId);
#endif
         [self.request setPostValue:self.adUnitId forKey:@"accountid"];
    }
    
    //NSLog(@":self.adUnitId: %@", self.adUnitId);
    
    [self.request setCompletionBlock:^{
       
        // Use when fetching text data
        NSString *responseString = [[self.request responseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"respinse string: %@", responseString);
        
        SBJsonParser *jsonParse = [[SBJsonParser alloc] init];
        NSDictionary *dictionary = [jsonParse objectWithString:responseString];
        [jsonParse release];
        
        BOOL status = [[dictionary valueForKey:@"status"] boolValue];
     
        
        if (status)
        {
            //NSLog(@"dic: %@", dictionary);
            NSArray *listArray = (NSArray *)[dictionary valueForKey:@"data"];
            NSMutableArray *listApps = [NSMutableArray array];
            
            if (listArray.count > 0) {
                
                [listArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                   
                    NSDictionary *dic = (NSDictionary *) obj;
                  
                    
                    NSString *appname = [dic valueForKey:@"appname"];
                    NSString *description = [dic valueForKey:@"body"];
                    NSString *image  = [dic valueForKey:@"image"];
                    NSString *url = [dic valueForKey:@"url"];
                    
                    AppRecord *appRecord = [[AppRecord alloc] init];
                    [appRecord setAppName:appname];
                    [appRecord setDescription:description];
                    [appRecord setAppURLString:image];
                    [appRecord setAppURLAppStoreString:url];
                    
                    [listApps addObject:appRecord];
                    [appRecord release];
                    
                    
                }];
                
                
                self.listData =  listApps;
    
                [self.mpTableView reloadData];
            }
            
        }
        
    }];
    
    [self.request setFailedBlock:^{
        
    }];
    
    [self.request startAsynchronous];
    
}



#pragma mark -  Layzy Loader


// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        [iconDownloader setCompletionHandler:^{
            
            MPTableViewCell *cell = (MPTableViewCell *)[self.mpTableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.mpIconApp.image = appRecord.appIcon;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}


- (void)loadImagesForOnscreenRows
{
    if ([self.listData count] > 0)
    {
        NSArray *visiblePaths = [self.mpTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            AppRecord *appRecord = [self.listData objectAtIndex:indexPath.row];
            
            if (!appRecord.appIcon)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
}




#pragma mark -  UITableView


-(void) initTableView
{
    if (!_mpTableView)
    {
        CGRect rect = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44);
        
        _mpTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        [self.mpTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight];
        [_mpTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [self.mpTableView setDelegate:self];
        [self.mpTableView setDataSource:self];
        
        [self.view addSubview:self.mpTableView];

    }
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MPTableViewCell123";
    
    MPTableViewCell *cell = (MPTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[MPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    if (self.listData.count > 0){

        // Set up the cell...
        AppRecord *appRecord = [self.listData objectAtIndex:indexPath.row];

        NSString *text = appRecord.appName;
        NSString *description_app = appRecord.description;
        
        cell.mpTitle.text = text;
        cell.mpDescription.text =  description_app;
        
        //--gian noi dung cua no ra
        [self setUILabelTextWithVerticalAlignTop:text withCGRect:cell.mpTitle.frame withLabel:cell.mpTitle];
        [self setUILabelTextWithVerticalAlignTop:description_app withCGRect:cell.mpDescription.frame withLabel:cell.mpDescription];
        

        //--set toa do description dua vao title
        CGRect frame = cell.mpDescription.frame;
       cell.mpDescription.frame = CGRectMake(frame.origin.x, cell.mpTitle.frame.origin.y + cell.mpTitle.frame.size.height, frame.size.width, frame.size.height);
 
        
        // Only load cached images; defer new downloads until scrolling ends
        if (!appRecord.appIcon)
        {
            if (self.mpTableView.dragging == NO && self.mpTableView.decelerating == NO)
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.mpIconApp.image = self.mpImageUnActive;
        }
        else
        {
           cell.mpIconApp.image = appRecord.appIcon;
        }
    }
    
    cell.backgroundViewCell.tag =  indexPath.row;
    [cell.backgroundViewCell addTarget:self action:@selector(redirectLink:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void) redirectLink:(id) sender
{
    NSInteger buttonTag = [(UIButton *) sender tag];
    
    AppRecord *appRecord = [self.listData objectAtIndex:buttonTag];
    NSString *urlLink = appRecord.appURLAppStoreString;
    
    if (!urlLink || urlLink.length <=0)
    {
        
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Invalid link to AppStore. Please check your plist file!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertview show];
        [alertview release];
        
    }else{
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:urlLink]];
    }
    

    
}


- (void)setUILabelTextWithVerticalAlignTop:(NSString *)theText withCGRect:(CGRect) frame withLabel:(UILabel *) targetLabel{
    
    CGSize labelSize = CGSizeMake(frame.size.width, MAXFLOAT);
    
    CGSize theStringSize = [theText sizeWithFont:targetLabel.font constrainedToSize:labelSize lineBreakMode:targetLabel.lineBreakMode];
    
    CGRect rectLabelTitle = CGRectMake(targetLabel.frame.origin.x, targetLabel.frame.origin.y, frame.size.width, theStringSize.height);
    targetLabel.frame = rectLabelTitle;
}



- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.listData.count>0){
        
         MPTableViewCell *cell =  (MPTableViewCell *)[self tableView: self.mpTableView cellForRowAtIndexPath: indexPath];
    
        // Set up the cell...
        AppRecord *appRecord = [self.listData objectAtIndex:indexPath.row];
        
        NSString *text = appRecord.appName;
        NSString *description_app = appRecord.description;

        
        CGSize labelSize = CGSizeMake(cell.mpTitle.frame.size.width, MAXFLOAT);
        
        CGSize titleAppSize = [text sizeWithFont:cell.mpTitle.font constrainedToSize:labelSize lineBreakMode:cell.mpTitle.lineBreakMode];
        CGSize descriptionAppSize = [description_app sizeWithFont:cell.mpDescription.font constrainedToSize:labelSize lineBreakMode:cell.mpDescription.lineBreakMode];
    
        CGFloat  sizeHeight = titleAppSize.height + descriptionAppSize.height + 12;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            return (sizeHeight <= 72)? 72 : sizeHeight;
        else
            return (sizeHeight <= 80)? 80 : sizeHeight;
        
        

    }
    
    return 72;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}


#pragma mark UITableViewDelegate


- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell * )cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    MPTableViewCell *cellMp =  (MPTableViewCell *)cell;
    
//    cellMp.backgroundColor = indexPath.row % 2 ? [UIColor colorWithRed: 225.0f/256.0f green: 237.0f/256.0f blue: 245.0f/256.0f alpha: 1.0]:  [UIColor colorWithRed: 225.0f/256.0f green: 232.0f/256.0f blue: 232.0f/256.0f alpha: 1.0];
    cellMp.mpDescription.backgroundColor = [UIColor clearColor];
    cellMp.mpTitle.backgroundColor = [UIColor clearColor];
  
    
    CGFloat sizeHeight  = [self tableView:tableView heightForRowAtIndexPath:indexPath];

    CGRect frameIcon =  cellMp.mpIconApp.frame;
    frameIcon.origin.y = ceil((sizeHeight - frameIcon.size.height)/2);
    cellMp.mpIconApp.frame = frameIcon;
  
    
    
    
    // Draw top border only on first cell
   /* if (indexPath.row == 0) {
        
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1.0f)];
        topLineView.backgroundColor = [UIColor colorWithRed:163.0f/256.0f green:205.0f/256.0f blue:219.0f/256.0f alpha:1.0];
        [cell.contentView addSubview:topLineView];
        [topLineView release];
        
    }*/
    
    
    cellMp.backgroundViewCell.frame = CGRectMake(0, 0, cellMp.frame.size.width, cellMp.frame.size.height);
    
    if (indexPath.row % 2 == 1 ){
        
        UIImage *image = [UIImage imageNamed:@"Cell 2.png"];
        [cellMp.backgroundViewCell setBackgroundImage:image forState:UIControlStateNormal];
                
        UIImage *imageHighLigh = [UIImage imageNamed:@"Cell 1.png"];
        [cellMp.backgroundViewCell setBackgroundImage:imageHighLigh forState:UIControlStateHighlighted];
        

    }else{
        
        UIImage *imageHighLigh = [UIImage imageNamed:@"Cell 2.png"];
        [cellMp.backgroundViewCell setBackgroundImage:imageHighLigh forState:UIControlStateHighlighted];
       /* UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellMp.frame.size.width, cellMp.frame.size.height)];
        av.backgroundColor = [UIColor redColor];
        av.opaque = NO;
        av.image = [UIImage imageNamed:@"Cell 2.png"];
        cellMp.backgroundView = av;
        [av release];
        */
    }
    
    

    cellMp.bottomLineView.frame =CGRectMake(0, sizeHeight-2, self.view.bounds.size.width, 2);
}




#pragma mark -
#pragma mark Orientation


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}


- (BOOL)shouldAutorotate
{
    return YES;
    //return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return (orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark -  UINavigationBar



-(void) addTitle
{
    //--uiimage background
    UIImage *image = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?[UIImage imageNamed:@"SettingBar_no.png"]: [UIImage imageNamed:@"SettingBar-iPad_no.png"];
    
    UIImageView *backgroundviewNavigation = [[UIImageView alloc] initWithImage:image];
    CGRect frameNavigation = CGRectZero;
    frameNavigation.origin = CGPointZero;
    frameNavigation.size =  image.size;
    
    
    _titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-70 , 11.0f, 140, 21.0f)];
    [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setText:(self.titleStr)?self.titleStr: @"More Apps"];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.titleLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    self.titleLabel.layer.shadowRadius = 1.0;
    self.titleLabel.layer.shadowOpacity = 1.0;
    self.titleLabel.layer.masksToBounds = NO;
    
    [backgroundviewNavigation addSubview:self.titleLabel];
    
    
    [self.view addSubview:backgroundviewNavigation];
    [backgroundviewNavigation release];
    
    
    //--button black
    UIButton *buttonBlack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *originalImage = [UIImage imageNamed:@"BarButton.png"];
    originalImage =  [originalImage stretchableImageWithLeftCapWidth:4
                                                topCapHeight:4];
    
    UIImage *highlight = [UIImage imageNamed:@"BarButton-Pressed.png"];
    highlight =  [highlight stretchableImageWithLeftCapWidth:4
                                                    topCapHeight:4];
    
    [buttonBlack setBackgroundImage:originalImage forState:UIControlStateNormal];
    [buttonBlack setBackgroundImage:highlight forState:UIControlStateHighlighted];
    
    buttonBlack.frame = CGRectMake(self.view.frame.size.width - 64.0f, 7.0f, 56.0f, 31.0f);
    
    [buttonBlack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonBlack setTitle:@"Done" forState:UIControlStateNormal];
    [buttonBlack.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    
    [buttonBlack addTarget:self action:@selector(buttonBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBlack];
    
}

-(void)buttonBack
{
    
    if (self.request)
        [self.request cancel];

    [self dismissModalViewControllerAnimated:YES];
}



//-(void) initNavigationBar
//{
//    if (!_mpNavigationBar)
//    {
//        _mpNavigationBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//        [self.mpNavigationBar setBarStyle:UIBarStyleBlackTranslucent];
//        [self.mpNavigationBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
//        [self.mpNavigationBar setTintColor:[UIColor colorWithRed:11/256.0f green:98.0f/256.0f blue:212.0f/256.0f alpha:1.0]];
//        UIImage *image = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?[UIImage imageNamed:@"SettingBar_no.png"]: [UIImage imageNamed:@"SettingBar-iPad_no.png"];
//        
//        // Set the background image for PortraitMode
//        [self.mpNavigationBar setBackgroundImage:image
//                              forToolbarPosition:UIToolbarPositionTop barMetrics:UIBarMetricsDefault];
//        
//        
//        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered  target:self action:@selector(done)];
//
//        
//        _titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, 140, 21.0f)];
//        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
//        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
//        [self.titleLabel setTextColor:[UIColor whiteColor]];
//        //[self.titleLabel setText:(self.titleStr)?self.titleStr: @"More Apps"];
//        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
//        
//        UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:self.titleLabel];
//     
//
//        
//        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        self.mpNavigationBar.items = [NSArray arrayWithObjects:flexible, title, flexible, doneButton, nil];
//        
//        [flexible release];
//        [doneButton release];
//        [title release];
//        
//        [self.view addSubview:_mpNavigationBar];
//        
//    }
//}




#pragma mark -  CycleViewController



/** Register notification center for view controller */
-(void) registerNotification
{
   
}


/** Set data when view did load.
 ** Be there. You can set up some variables, data, or any thing that have reletive to data type*/
-(void) setDataWhenViewDidLoad
{
      self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    NSLog(@"self: %@", self.adUnitId);
    
      [self loadRequest];
}


/** Set view when view did load
 ** Be there. You can change the layout, view, button,..*/
-(void) setViewWhenViewDidLoad
{
}

- (void)viewDidLoad
{
    [self registerNotification];
    [self setDataWhenViewDidLoad];
    [self setViewWhenViewDidLoad];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning
{
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    [self.imageDownloadsInProgress removeAllObjects];

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_mpNavigationBar release];
    [_mpBackgroundView release];
    [_mpTableView release];
    
    [_listData release];
    
    [_titleLabel release];
    
    [_mpImageUnActive release];
    
    [_imageDownloadsInProgress release];
    
    [_request release];
    
    [_adUnitId release];
    
    [_titleStr release];
    
    [super dealloc];
}



@end
