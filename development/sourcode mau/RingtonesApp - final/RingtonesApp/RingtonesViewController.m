//
//  RingtonesViewController.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RingtonesViewController.h"
#import "Constants.h"
#import "CommonUtils.h"
#import "MessageComposerViewController.h"
#import "ListIPodSongsViewController.h"
#import "RingtoneHelpers.h"


#define TAG_ACTIONSHEET_SEND_EMAIL 1231

@implementation RingtonesViewController

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

#pragma Control events
- (void)barItemClearClicked:(id)sender;
{
    [downloadingVC clearData];
}

- (void)barItemAddClicked:(id)sender;
{
    //check if reach max limit of download
    NSArray *array = [[RingtoneHelpers defaultHelper]getListRingtoneFromDocument];
    //            NSNumber *countDownloaded = [[NSUserDefaults standardUserDefaults]objectForKey:kDownloadedCount];
    NSInteger count = (array != nil) ? [array count] : 0;
    BOOL willCreate = TRUE;
    BOOL willPurchase = TRUE;
#ifdef kLiteVersion
    willPurchase = FALSE;
    if (count >= kMaxRingtoneFree) {
        willCreate = FALSE;
    }
#else
    #ifdef kFreeVersion
        BOOL purchased = [[[NSUserDefaults standardUserDefaults]objectForKey:kPurchaseKey] boolValue];
        if (!purchased && count >= kMaxRingtoneFree) {
            willCreate = FALSE;
        }
    #else
        willCreate = TRUE;
    #endif
#endif
    
    if (willCreate) {
        ListIPodSongsViewController *creator = [[ListIPodSongsViewController alloc]initWithNibName:@"ListIPodSongsViewController" bundle:nil];
        
        [self.navigationController pushViewController:creator animated:YES];
        
        [creator release];
    } else {
        if (willPurchase) {
            [delegate showAlertUpgradeOnView:self upgradeMethod:@selector(onUpgradeClicked)];
        } else {
            [delegate showAlertLinkToFull:self];
        }
        
    }
    
}


- (IBAction)segControlValueChanged:(id)sender;
{
    NSInteger selectedIndex = segDownloadManager.selectedSegmentIndex;
    
    if (selectedIndex == 0) {
        [self.view bringSubviewToFront:downloadingVC.view];
        [self.view sendSubviewToBack:downloadedVC.view];
        
        UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(barItemClearClicked:)] autorelease];
        
        self.navigationItem.leftBarButtonItem = leftItem;
        
    } else {
        [self.view bringSubviewToFront:downloadedVC.view];        
        [self.view sendSubviewToBack:downloadingVC.view];
        
        UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(barItemAddClicked:)]                  
                                     autorelease];
        
        self.navigationItem.leftBarButtonItem = leftItem;
        
        
        [downloadedVC reloadDataSource];
    }
}

#pragma Notification handler
- (void)doneDownloading:(NSNotification *)notif;
{
    NSLog(@"Receive notification DONE in Downloaded");
    if (notif != nil) {
        
    }
    
//    [segDownloadManager setSelectedSegmentIndex:1];
//    [self segControlValueChanged:segDownloadManager];
//    
    [downloadedVC reloadDataSource];
    //goto downloaded view
    
}


- (void)didChooseSendEmail:(NSNotification *)notif;
{
    NSLog(@"Receive didChooseSendEmail");
    if (notif != nil && [notif object] != nil) {
        F_RELEASE(dictToSendEmail);
        
        dictToSendEmail = [(NSDictionary *)[notif object] retain];
        
        NSString *title = [dictToSendEmail objectForKey:@"title"];
        //show actionsheet to send mail
        UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:title 
                                                                delegate:self 
                                                       cancelButtonTitle:BUTTON_ACTIONSHEET_CANCEL 
                                                  destructiveButtonTitle:nil 
                                                       otherButtonTitles:BUTTON_ACTIONSHEET_SEND_EMAIL, nil];
        actionsheet.tag = TAG_ACTIONSHEET_SEND_EMAIL;
        [actionsheet showInView:self.tabBarController.tabBar];
        [actionsheet release];
    }
    
    
}



#pragma Actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet tag] == TAG_ACTIONSHEET_SEND_EMAIL) {
        if (buttonIndex != [actionSheet cancelButtonIndex]) {            

            NSString *title = [dictToSendEmail objectForKey:@"title"];
            
            //send email with ringtone as attachment
            MessageComposerViewController *mess = [[MessageComposerViewController alloc]initwithAttachFileName:title];
            
            
            
            [self.navigationController pushViewController:mess animated:YES];
    //            [mess setAttachFilename:title];
            [mess release];
        }
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = TITLE_VIEW_RINGTONE;
    
    self.navigationItem.titleView = segDownloadManager;
    
    //init downloaded and downloading view
    downloadedVC = [[DownloadedViewController alloc]initWithNibName:@"DownloadedViewController" bundle:nil];
    
    downloadingVC = [[DownloadingViewController alloc]initWithNibName:@"DownloadingViewController" bundle:nil];
    
    CGRect frame = self.view.frame;
    CGRect newFrame = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
    
    downloadingVC.view.frame = newFrame;
    downloadedVC.view.frame = newFrame;

    
    [self.view addSubview:downloadingVC.view];
    [self.view addSubview:downloadedVC.view];
    
//    [downloadedVC updateOffset];
    
        
    //grab delegate
    delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
//    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStyleBordered target:self action:@selector(barItemAddClicked:)] autorelease];

    
    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(barItemAddClicked:)]
                                 
                                 //                                      initWithTitle:@"+" style:UIBarButtonItemStyleBordered target:self action:@selector(barItemAddClicked:)] 
                                 //                                     
                                 autorelease];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doneDownloading:) name:kNotificationDoneDownloadRingtone object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChooseSendEmail:) name:kNotificationDidChooseSendEmail object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (segDownloadManager.selectedSegmentIndex == 1) { //downloaded
//        [downloadedVC viewWillAppear:YES];
        [downloadedVC reloadDataSource];
    }
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
