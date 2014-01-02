//
//  MoreViewController.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MoreViewController.h"
#import "Constants.h"
#import "CommonUtils.h"
#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "localhostAddresses.h"
#import "HelpViewController.h"
#import "MessageComposerViewController.h"


@interface MoreViewController(privateMethods)


@end


@implementation MoreViewController


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
- (void)gotoHelpScreen;
{
    HelpViewController *help = [[HelpViewController alloc]initWithNibName:@"HelpViewController" bundle:nil];
    
    [self.navigationController pushViewController:help animated:YES];
    [help release];
}

- (void)setupWifiSharing;
{
    NSString *root = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   // NSString *documentDir = [paths objectAtIndex:0];
    //NSString *root = [documentDir stringByAppendingPathComponent:@"aa"];
    
    NSLog(@"root %@",root);
	httpServer = [HTTPServer new];
	[httpServer setType:@"_http._tcp."];
	[httpServer setConnectionClass:[MyHTTPConnection class]];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:root]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayInfoUpdate:) name:@"LocalhostAdressesResolved" object:nil];
	[localhostAddresses performSelectorInBackground:@selector(list) withObject:nil];
    

}

#pragma Control events
- (void)displayInfoUpdate:(NSNotification *) notification
{
	NSLog(@"displayInfoUpdate:");
    
	if(notification)
	{
		[addresses release];
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
    
	if (!localIP) {
		info = @"Wifi: No Connection!\n";
    } else {
//		info = [NSString stringWithFormat:@"http://iphone.local:%d		http://%@:%d\n", port, localIP, port];
        
        info = [NSString stringWithFormat:@"http://%@:%d\n", localIP, port];
    }
    
//	NSString *wwwIP = [addresses objectForKey:@"www"];
//    
//	if (wwwIP)
//		info = [info stringByAppendingFormat:@"Web: %@:%d\n", wwwIP, port];
//	else
//		info = [info stringByAppendingString:@"Web: Unable to determine external IP\n"];
    
    F_RELEASE(strWifiSharing);
    strWifiSharing = [info copy];
	//update text to table
    [mainTableView reloadData];
}


- (IBAction)startStopServer:(id)sender
{
	if ([swiWifiSharing isOn])
	{
		// You may OPTIONALLY set a port for the server to run on.
		// 
		// If you don't set a port, the HTTP server will allow the OS to automatically pick an available port,
		// which avoids the potential problem of port conflicts. Allowing the OS server to automatically pick
		// an available port is probably the best way to do it if using Bonjour, since with Bonjour you can
		// automatically discover services, and the ports they are running on.
        //	[httpServer setPort:8080];
		
		NSError *error;
		if(![httpServer start:&error])
		{
			NSLog(@"Error starting HTTP Server: %@", error);
		}
        
		[self displayInfoUpdate:nil];
	}
	else
	{
		[httpServer stop];
        
        strWifiSharing = @"";
        [mainTableView reloadData];
	}
}


#pragma Tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger noRows = 0;
    if (section == 0) {
#ifdef kFreeVersion // lite: no upgrade, Free: upgradable,
        if (purchased) {
            noRows = 1;
        } else {
            noRows = 2;
        }
//#elif kLiteVersion
//        noRows = 2;
#else
        noRows = 1;
#endif
    } else if (section == 1) {
        noRows = 1;
    } else {
        noRows = 3;
    }
    
    return noRows;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    }
    
    [cell.imageView.layer setCornerRadius:CELL_IMAGE_CONRNER_RADIUS];
    
    NSString *title = @"";
    
    NSString *imageName;
    
    if (indexPath.section == 0) {
#ifdef kFreeVersion 
        if (purchased) {
            title = @"Help";
            imageName = @"icon_help.png";
        } else {
            switch (indexPath.row) {
                case 0:
                    title = @"Upgrade";
                    imageName = @"icon_upgrade.png";
                    break;
                case 1:
                    title = @"Help";
                    imageName = @"icon_help.png";
                    break;                
                default:
                    break;
            }

        }
//#elif kLiteVersion
//        switch (indexPath.row) {
//            case 0:
//                title = @"Upgrade";
//                break;
//            case 1:
//                title = @"Help";
//                break;                
//            default:
//                break;
//        }
#else
        title = @"Help";
        imageName = @"icon_help.png";
#endif
        
        cell.accessoryView = nil;
        
    } else if (indexPath.section == 1) {
        title = @"Wifi Sharing";  
        imageName = @"icon_wifisharing.png";
        cell.accessoryView = swiWifiSharing;
        if (swiWifiSharing.on) {
            cell.detailTextLabel.text = strWifiSharing;
            cell.detailTextLabel.numberOfLines = 0;
        } else {
            cell.detailTextLabel.text = @"";
        }
    } else {
        cell.accessoryView = nil;
        switch (indexPath.row) {
            case 0:
                title = @"Tell a friend";
                imageName = @"icon_tellFriend.png";
                break;
            case 1:
                title = @"Give us ";
                imageName = @"icon_rateUs.png";
                break;                
            case 2:
                title = @"More Apps";
                imageName = @"icon_moreApp.png";
                break;                
            default:
                break;
        }
    }
    
    

    
    UIImage *image = [UIImage imageNamed:imageName];
    cell.imageView.image = image;
    
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    
    cell.textLabel.text = title;
    
    return cell;
}

#pragma tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 60.0f;
    }
    
    return 44.0f;
    
}

- (void)handleTapCellForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
#ifdef kFreeVersion
        if (purchased) {
            [self gotoHelpScreen];
        } else {
            switch (indexPath.row) {
                case 0: //in app purchase
                {
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [delegate showAlertUpgradeOnView:self upgradeMethod:@selector(onUpgradeClicked)];
                }
                    break;
                case 1:
                    [self gotoHelpScreen];
                    break;                
                default:
                    break;
            }
        }
        
//#elif kLiteVersion
//        switch (indexPath.row) {
//            case 0: //show link to full app
//            {
//                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                [delegate showAlertLinkToFull:self];
//            }
//                break;
//            case 1:
//                [self gotoHelpScreen];
//                break;                
//            default:
//                break;
//        }
#else
        [self gotoHelpScreen];
#endif
        
    } else if (indexPath.section == 1) {
        //on/off wifi sharing
        swiWifiSharing.on = !swiWifiSharing.on;
        [self startStopServer:swiWifiSharing];
    } else {
        switch (indexPath.row) {
            case 0:
                //share via email
            {
                //send email with ringtone as attachment
                MessageComposerViewController *mess = [[MessageComposerViewController alloc]init];
                
                mess.mailBody = kEmailBodyShareFriend;
                mess.mailSubject = kEmailSubjectShareFriend;
                mess.attachFilename = nil;
                
                [self.navigationController pushViewController:mess animated:YES];

                [mess release];
            }
                break;
            case 1:
            {
                NSString *rateLink = kLinkAppReviewFree;
#ifdef kLiteVersion
                NSLog(@"kLinkAppReviewLite");
                rateLink = kLinkAppReviewLite;
#elif kFreeVersion
                NSLog(@"kLinkAppReviewFree");
                rateLink = kLinkAppReviewFree;
#else
                NSLog(@"kLinkAppReviewFull");
                rateLink = kLinkAppReviewFull;
#endif
                
                [CommonUtils openURLExternalHandlerForLink:rateLink];
            }
                break;                
            case 2:
                //Open More App
                [CommonUtils openURLExternalHandlerForLink:kLinkMoreApp];
                break;                
            default:
                break;
        }
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self handleTapCellForIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    [self handleTapCellForIndexPath:indexPath];
}



#pragma -Purchase delegate from App Delegate
- (void)purchaseDidFinish {
    NSLog(@"purchaseDidFinish search ");
    purchased = [[[NSUserDefaults standardUserDefaults]objectForKey:kPurchaseKey] boolValue];
    
    purchased = YES;
    
    [mainTableView reloadData];
}

- (void)purchaseDidFail {
    NSLog(@"purchaseDidFail search ");
}

- (void)didPurchased:(NSNotification *)notif
{
    NSLog(@"did purchased on More, remove Upgrade");
    [self purchaseDidFinish];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = TITLE_VIEW_MORE;
    
    [self setupWifiSharing];
    
    purchased = [[[NSUserDefaults standardUserDefaults]objectForKey:kPurchaseKey] boolValue];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didPurchased:) name:kPurchaseKey object:nil];
        
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
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
