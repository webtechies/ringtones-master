//
//  SettingsViewController.m
//  RingTones
//
//  Created by Vuong Nguyen on 12/13/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingCustomCell.h"
#import "HelpViewController.h"

#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "localhostAddresses.h"

@interface SettingsViewController ()

{
    
}
@property (nonatomic,assign) BOOL isOnWifi;
@property (nonatomic,strong) NSString *portStr;
@property (nonatomic,strong) NSArray *arrayKey;
@property (nonatomic,strong) NSMutableDictionary *dictionaryData;
@end
@implementation SettingsViewController
@synthesize loading;
@synthesize dictionaryData = _dictionaryData;
@synthesize arrayKey = _arrayKey;
@synthesize isOnWifi = _isOnWifi;
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
    _isOnWifi = NO;
    [self addHTTPWifiTransfer];
    [self setDataDictionary];
    [self setFrameTableView];
    [tableData reloadData];
}



/** Set view when view did load
 ** Be there. You can change the layout, view, button,..*/
-(void) setViewWhenViewDidLoad
{
    
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


-(void) addHTTPWifiTransfer
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsPath = [[searchPaths objectAtIndex: 0] stringByAppendingString:@"/Downloaded"];
    
	httpServer = [HTTPServer new];
	[httpServer setType:@"_http._tcp."];
	[httpServer setConnectionClass:[MyHTTPConnection class]];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:documentsPath]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayInfoUpdate:) name:@"LocalhostAdressesResolved" object:nil];
	[localhostAddresses performSelectorInBackground:@selector(list) withObject:nil];

}

/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */

-(void) setDataDictionary
{
    NSArray *arrayS1 = [NSArray arrayWithObjects:@"Upgrade",@"Info",nil];
    NSArray *arrayS2 = [NSArray arrayWithObjects:@"Dropbox",@"Wifi sharing",nil];
    NSArray *arrayS3 = [NSArray arrayWithObjects:@"Rate this apps",@"Gift this apps",@"Share this apps",nil];
    NSArray *arrayS4 = [NSArray arrayWithObjects:@"Premium",@"Free Ads",@"Free Pro",nil];
    self.arrayKey = [NSArray arrayWithObjects:@"APPS INFO",@"CONNECTION",@"SOCIAL",@"VERSION",nil];
    _dictionaryData = [NSMutableDictionary dictionary];
    [_dictionaryData setObject:arrayS1 forKey:@"APPS INFO"];
    [_dictionaryData setObject:arrayS2 forKey:@"CONNECTION"];
    [_dictionaryData setObject:arrayS3 forKey:@"SOCIAL"];
    [_dictionaryData setObject:arrayS4 forKey:@"VERSION"];
}


-(void) setFrameTableView
{
    
    tableData.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    
    
}


/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
#pragma mark  - Tableview



-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isOnWifi) {
        if (indexPath.row == 1 && indexPath.section == 1) {
            return 82;
        }
    }
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 55;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([isDebugApp isEqualToString:@"1"])
    {
        return self.arrayKey.count;
    }
    return self.arrayKey.count - 1;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSMutableArray * rows = [self.dictionaryData objectForKey:[self.arrayKey objectAtIndex:section]];
    return rows.count;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    int heightViewFolder = 50;
  
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, heightViewFolder)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.view.frame.size.width, heightViewFolder)];
    
    label.text = [self.arrayKey objectAtIndex:section];
    label.font = [UIFont helveticaNeueLightFontSize:17];
    
    label.textAlignment = NSTextAlignmentLeft;
    [label setTextColor:[UIColor colorWithRed:148/255.0f green:148/255.0f blue:148/255.0f alpha:1.0]];
    [label setBackgroundColor:[UIColor clearColor]];
    [view setBackgroundColor:[UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [view addSubview:label];

    return view;
    
}



-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"";
    if (IS_IPAD)
    {
        cellIndentifier = @"IpadSettingCustomCell";
    }
    else  //iphone
    {
        cellIndentifier = @"SettingCustomCell";
    }
    
    SettingCustomCell *cell = (SettingCustomCell *)[tableData dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (cell == nil)
    {
        //--load nibs name
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIndentifier owner:self options:nil];
        if (cell == nil) {
            
            
            cell = (SettingCustomCell *) [nib objectAtIndex:0];
            
            
        }
    }
    cell = [self setDataForCell:cell withIndexPath:indexPath];
    
    return cell;
    
}


-(SettingCustomCell *) setDataForCell:(SettingCustomCell *) cell withIndexPath:(NSIndexPath *) indexPath

{
    NSMutableArray * rows = [[self.dictionaryData objectForKey:[self.arrayKey objectAtIndex:indexPath.section]] mutableCopy];
    cell.lbCell.text = [rows objectAtIndex:indexPath.row];
    if (indexPath.section == 1 || indexPath.section == 3)
    {
        cell.btSwitch.hidden = NO;
        cell.imgDetail.hidden = YES;
       
      
        
    }
    else{
        cell.btSwitch.hidden = YES;
        cell.imgDetail.hidden = NO;
    }
    
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0) //--dropbox
        {
            if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"isdropbox"] isEqualToString:@"1"]) {
                [cell.btSwitch setOn:YES];
            }
            else {
                [cell.btSwitch setOn:NO];
            }
            [cell.btSwitch addTarget:self action:@selector(processDropbox:) forControlEvents:(UIControlEventValueChanged)];
        }
        
        if (indexPath.row == 1)
        {
            if (_portStr.length > 0)
            {
                cell.lbAddress.text = _portStr;
            }
            [cell.btSwitch addTarget:self action:@selector(processWifi:) forControlEvents:(UIControlEventValueChanged)];
        }
        
    }
    
    
    if (indexPath.row == 0)
    {
        cell.imgLine1.hidden = NO;
    }
    else{
       cell.imgLine1.hidden = YES;
    }
    
    if (indexPath.row == rows.count - 1)
    {
        cell.imgLine2.frame = CGRectMake(0, cell.imgLine2.frame.origin.y, cell.imgLine2.frame.size.width, 1);
        if (_isOnWifi)
        {
            if (indexPath.section == 1)
            {
                cell.imgLine2.frame = CGRectMake(0, 81, cell.imgLine2.frame.size.width, 1);
            }
        }
        else {
           cell.imgLine2.frame = CGRectMake(0, 43, cell.imgLine2.frame.size.width, 1);
        }
   
     
     
    }
    else{
        cell.imgLine2.frame = CGRectMake(15, cell.imgLine2.frame.origin.y, cell.imgLine2.frame.size.width, 1);
    }
    
    return cell;
}


//-------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        //Section 1
        [self processAppsInfo:indexPath];
    }
    if (indexPath.section == 1)
    {
        //Section 2
        //[self processConnection:indexPath];
    }
    
    if (indexPath.section == 2)
    {
        //Section 3
        [self processSocial:indexPath];
    }
    if (indexPath.section == 2)
    {
        //Section 4
        [self processVersion:indexPath];
    }
    
  
    
  
}


/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
#pragma mark  - Apps Info


-(void) processAppsInfo:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        HelpViewController *helpView = [HelpViewController new];
        helpView.isHelp = NO;
        [self.navigationController pushViewController:helpView animated:YES];
    }
}



/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
#pragma mark  - Connection



-(void) processDropbox:(id) sender
{
    UISwitch *FirstSwitch = (UISwitch *)sender;
    // saving data
    if (FirstSwitch.on == YES) {
        NSUserDefaults *defaul = [NSUserDefaults standardUserDefaults];
        [defaul setObject:@"1" forKey:@"isdropbox"];
        [defaul synchronize];
    }
    else {
        NSUserDefaults *defaul = [NSUserDefaults standardUserDefaults];
        [defaul setObject:@"0" forKey:@"isdropbox"];
        [defaul synchronize];
    }
}


-(void) processWifi:(id) sender
{
    UISwitch *FirstSwitch = (UISwitch *)sender;
    // saving data
    if (FirstSwitch.on == YES)
    {
       	NSError *error;
		if(![httpServer start:&error])
		{
			NSLog(@"Error starting HTTP Server: %@", error);
		}
        _isOnWifi = YES;
		[self displayInfoUpdate:nil];
    }
    else
    {
        _isOnWifi = NO;
        _portStr = @"";
        [httpServer stop];
        [tableData reloadData];
    }
}


- (void)displayInfoUpdate:(NSNotification *) notification
{
	NSLog(@"displayInfoUpdate:");
    
    
	if(notification)
	{
		addresses = nil;
		addresses = [[notification object] copy];
		NSLog(@"addresses: %@", addresses);
	}
    
	if(addresses == nil)
	{
		return;
	}
	
	NSString *info;
	UInt16 port = [httpServer port];
	
	NSString *localIP = nil;
	
	localIP = [addresses objectForKey:@"en0"];
	
	if (!localIP)
	{
		localIP = [addresses objectForKey:@"en1"];
	}
    
	if (!localIP)
		info = @"Wifi: No Connection!\n";
	else
		info = [NSString stringWithFormat:@"http://iphone.local:%d		http://%@:%d\n", port, localIP, port];
         //NSLog(@"info1: %@",info);
	NSString *wwwIP = [addresses objectForKey:@"www"];
    
	if (wwwIP)
		info = [info stringByAppendingFormat:@"Web: %@:%d\n", wwwIP, port];
	else
		info = [info stringByAppendingString:@"Web: Unable to determine external IP\n"];
    
    _portStr = [NSString stringWithFormat:@"http://%@:%d",localIP,port];

    [tableData reloadData];

    NSLog(@"_portStr: %@",_portStr);

}



/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
#pragma mark  - Social


-(void) processSocial:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) //--rate
    {
        [self rateApp];
    }
    
    if (indexPath.row == 1) //-- gift
    {
        [self giftApp];
    }
    
    if (indexPath.row == 2) //--share
    {
        
        [self shareSocial:indexPath];
       
    }
}


-(void) rateApp
{
    NSString *appid = [NSString stringWithFormat:@"%d",kAppleID];
    
    if (self.loading == nil) {
        self.loading = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    loading.labelText = @"Wating...";
    
    if(NSClassFromString(@"SKStoreProductViewController")) { // Checks for iOS 6 feature.
        
        SKStoreProductViewController *storeController = [[SKStoreProductViewController alloc] init];
        
        storeController.delegate = self; // productViewControllerDidFinish
        storeController.view.frame =  self.view.frame;
        
        // Example app_store_id (e.g. for Words With Friends)
        //[NSNumber numberWithInt:322852954];
        
        NSDictionary *productParameters = @{ SKStoreProductParameterITunesItemIdentifier : appid };
        
        
        [storeController loadProductWithParameters:productParameters completionBlock:^(BOOL result, NSError *error) {
            
            if (result) {
                
                
                [self presentViewController:storeController animated:YES completion:nil];
            } else {
                
                [self timeout:nil];
                [[[UIAlertView alloc] initWithTitle:@"Uh oh!" message:@"There was a problem displaying the app" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                
            }
        }];
        
        
    } else { // Before iOS 6, we can only open the URL
        
        NSString *fulllink = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appid];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: fulllink]];
        
        
    }

}



-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self timeout:nil];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)timeout:(id)arg
{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.loading = nil;
    
}


-(void) giftApp
{
    NSString *appid = [NSString stringWithFormat:@"%d",kAppleID];
    NSString *fullURL =  [NSString stringWithFormat:@"https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/giftSongsWizard?gift=1&salableAdamId=%@&productType=C&pricingParameter=STDQ&mt=8", appid];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fullURL]];
    
}


-(void) processGiftApp:(NSDictionary *) dictionary
{
    

}


-(void) shareSocial:(NSIndexPath *)indexPath
{
    NSString *sharingString = kShareApp;
    
    
    sharingString = [NSString stringWithFormat:@"%@ %@",kShareApp,LinkAppPro];
    UIImage *image = [UIImage imageNamed:kImageShare];
    NSArray *objectsToShare = @[sharingString,image];
    NSArray *activities = nil;
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:activities];
    
    // Exclude some default activity types to keep this demo clean and simple.
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact,
                                                     UIActivityTypeCopyToPasteboard,
                                                     UIActivityTypeMessage,
                                                     UIActivityTypePostToWeibo,
                                                     UIActivityTypePrint,UIActivityTypeSaveToCameraRoll];
    
    
    
    //show sharing menu
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        if (activityPopoverController.isPopoverVisible)
        {
            // If the popover's visible, hide it
            [activityPopoverController dismissPopoverAnimated:YES];
        }
        else
        {
            if (activityPopoverController == nil) {
                activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
            }
            else
            {
                activityPopoverController.contentViewController = activityViewController;
            }
            
            // Set a completion handler to dismiss the popover
            [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed){
                [activityPopoverController dismissPopoverAnimated:YES];
            }];
            CGRect rectInTableView = [tableData rectForRowAtIndexPath:indexPath];
            [activityPopoverController presentPopoverFromRect:rectInTableView inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    }
    else
    {
        
        
        [self presentViewController:activityViewController animated:YES completion:NULL];
    }
    

}


/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
#pragma mark  - Version


-(void) processVersion:(NSIndexPath *)indexPath
{
    
}



@end
