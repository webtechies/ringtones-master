//
//  SettingPageUI.m
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/3/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import "SettingPageUI.h"
#import "FileManager.h"
#import "SPTableViewCell.h"
#import "IAdViewController.h"
#import "InfoViewController.h"
#import "REActivityViewController.h"
#import "REActivity.h"
#import "NewsLetterViewController.h"


#import "SHKMail.h"
#import "SHKTextMessage.h"
#import "SHKFacebook.h"
#import "SHKTwitter.h"
#import "SHKInstagram.h"
#import "SHKTumblr.h"

#import "IAdViewController.h"
#import "RageIAPHelper.h"


#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

#import "MorePageViewController.h"


const NSString *ConstantKeyAlertView = @"UIAlertView";



static  NSString *moreapps = @"moreapps";
static  NSString *ads = @"ads";
static  NSString *info = @"infor";
static  NSString *gift = @"gift";
static  NSString *share = @"share";
static  NSString *ratingandreview = @"rate";
static  NSString *newsletter = @"newsletter";


@implementation SKStoreProductViewController (OrientationName)

-(BOOL) shouldAutorotate
{
    return YES;
}

// Applications should use supportedInterfaceOrientations and/or shouldAutorotate..
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end


@interface SettingPageUI ()
@property (nonatomic, retain) NSArray *listData;
@property (nonatomic, retain) NSArray *products;
@property (nonatomic, assign) BOOL isSharingTumbl;
@end


@implementation SettingPageUI

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id) initWithPlistFile:(NSString *) nameFilePlist
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        __block NSArray *data = nil;
        
         [FileManager readFileName:nameFilePlist isMakeObject:NO completionBlock:^(NSArray *dataRead){
            data = dataRead;
        }];
        
        self.listData = data;
        
    }
    
    return self;
}


+ (id) initWithPlistFile:(NSString *) nameFilePlist
{
    return [[[self alloc] initWithPlistFile:nameFilePlist] autorelease];
}


- (id) initWithPlistFile:(NSString *) nameFilePlist withImageBg:(UIImage *) imageBackground
{
    self = [self initWithPlistFile:nameFilePlist];
    if (self)
    {
        self.imageBackground =  imageBackground;
    }
    
    return self;
}

+ (id) initWithPlistFile:(NSString *) nameFilePlist  withImageBg:(UIImage *) imageBackground {
    return [[[self alloc] initWithPlistFile:nameFilePlist withImageBg:imageBackground] autorelease];
}


#pragma mark - News letter


-(void) newsletterPressed:(UIBUttonSP *) button
{
    // Set up the cell...
    NSIndexPath *indexPath = button.indexPath;
    NSDictionary *dictionary = nil;
    
    if (self.isGroup)
        dictionary = (NSDictionary *) [[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    else
        dictionary = (NSDictionary *) [self.listData objectAtIndex:indexPath.row];
    
    [self processNewsLetter:dictionary];
}


-(void) processNewsLetter:(NSDictionary *) dictionay
{
    NewsLetterViewController *newsletter = [[NewsLetterViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:newsletter animated:YES];
    
}



#pragma mark - Rating



- (void)showWithLabel {
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.dimBackground = YES;
	

	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
	[HUD show:YES];
}


- (void)myTask {
	// Do something usefull in here instead of sleeping ...
	sleep(3);
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
    
}



-(void) ratingPressed:(UIBUttonSP *) button
{
    [self showWithLabel];
    
    // Set up the cell...
    NSIndexPath *indexPath = button.indexPath;
    NSDictionary *dictionary = nil;
    
    if (self.isGroup)
        dictionary = (NSDictionary *) [[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    else
        dictionary = (NSDictionary *) [self.listData objectAtIndex:indexPath.row];

    
    [self rating:dictionary];
}
    
    
-(void) rating:(NSDictionary *) dictionary
{
    
    NSString *appid = [dictionary valueForKey:@"apprate_id"];
    

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
                
                [[[UIAlertView alloc] initWithTitle:@"Uh oh!" message:@"There was a problem displaying the app" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                
            }
        }];
        
        
    } else { // Before iOS 6, we can only open the URL
        
        NSString *fulllink = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appid];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: fulllink]];
        
        
    }

    
    
    
}

#pragma mark - Sharing


- (void)buttonPressed:(UIBUttonSP *) button
{
    // Set up the cell...
    NSIndexPath *indexPath = button.indexPath;
   

    [self processShare:nil withIndexPath:indexPath];
}


-(void) processShare:(NSDictionary *) dictionary withIndexPath:(NSIndexPath *) indexPath
{
    // Create some custom activity
    //
    NSString *msgShare = @"My Awesome Image!!!";
    NSString *imgShare = (self.imageSharing)?self.imageSharing: @"Icon-shared.png";
    
    
    if (msgShare)
    {
        msgShare = self.msgShare;
    }
    
    REActivity *customActivity = [[REActivity alloc] initWithTitle:@"Email"
                                                             image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Mail.png"]
                                                       actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                                                           [activityViewController dismissViewControllerAnimated:YES completion:^{
                                                               
                                                               
                                                               UIImage *myImg = [activityViewController.userInfo valueForKey:@"image"];
                                                               NSString *stringdescriptionshre = [activityViewController.userInfo valueForKey:@"text"];
                                                               
                                                               SHKItem *item = [SHKItem image:myImg title:@""];
                                                               item.text =  stringdescriptionshre;
                                                               [SHKMail shareItem:item];
                                                               
                                                           }];
                                                       }];
    
    REActivity *customActivityMessage = [[REActivity alloc] initWithTitle:@"Message"
                                                                    image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Message.png"]
                                                              actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                                                                  [activityViewController dismissViewControllerAnimated:YES completion:^{
                                                                      
                                                                      UIImage *myImg = [activityViewController.userInfo valueForKey:@"image"];
                                                                      NSString *stringdescriptionshre = [activityViewController.userInfo valueForKey:@"text"];
                                                                      
                                                                      SHKItem *item = [SHKItem image:myImg title:msgShare];
                                                                      item.text =  stringdescriptionshre;
                                                                      [SHKTextMessage shareItem:item];
                                                                      
                                                                      
                                                                  }];
                                                              }];
    
    
    
    REActivity *customActivityMessageFacebook = [[REActivity alloc] initWithTitle:@"Facebook"
                                                                            image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Facebook.png"]
                                                                      actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                                                                          [activityViewController dismissViewControllerAnimated:YES completion:^{
                                                                              
                                                                              
                                                                              UIImage *myImg = [activityViewController.userInfo valueForKey:@"image"];
                                                                              NSString *stringdescriptionshre = [activityViewController.userInfo valueForKey:@"text"];
                                                                              
                                                                              SHKItem *item = [SHKItem image:myImg title:msgShare];
                                                                              item.text =  stringdescriptionshre;
                                                                              [SHKFacebook shareItem:item];
                                                                              
                                                                              
                                                                              
                                                                          }];
                                                                      }];
    
    
    REActivity *customActivityMessageTwitter = [[REActivity alloc] initWithTitle:@"Twitter"
                                                                           image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Twitter.png"]
                                                                     actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                                                                         [activityViewController dismissViewControllerAnimated:YES completion:^{
                                                                             
                                                                             UIImage *myImg = [activityViewController.userInfo valueForKey:@"image"];
                                                                             NSString *stringdescriptionshre = [activityViewController.userInfo valueForKey:@"text"];
                                                                             
                                                                             SHKItem *item = [SHKItem image:myImg title:msgShare];
                                                                             item.text =  stringdescriptionshre;
                                                                             [SHKTwitter shareItem:item];
                                                                             
                                                                             
                                                                         }];
                                                                     }];
    
    
    
    
    REActivity *customActivityMessageInstagram = [[REActivity alloc] initWithTitle:@"Instalgram"
                                                                             image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Instagram.png"]
                                                                       actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                                                                           [activityViewController dismissViewControllerAnimated:YES completion:^{
                                                                               
                                                                               UIImage *myImg = [activityViewController.userInfo valueForKey:@"image"];
                                                                               NSString *stringdescriptionshre = [activityViewController.userInfo valueForKey:@"text"];
                                                                               
                                                                               NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
                                                                               CGRect frame = [self.mpTableView rectForRowAtIndexPath:indexPath];
                                                                               CGPoint yOffset = self.mpTableView.contentOffset;
                                                                               CGRect frameRect = CGRectMake(frame.origin.x, (frame.origin.y + 95 - yOffset.y), frame.size.width, frame.size.height);
                                                                               
                                                                               
                                                                               SHKItem *item = [SHKItem image:myImg title:msgShare];
                                                                               item.text =  stringdescriptionshre;
                                                                               item.popOverSourceRect = frameRect;
                                                                               [SHKInstagram shareItem:item];
                                                                               
                                                                      
                                                                               
                                                                               ;
                                                                           }];
                                                                       }];
    
    
    REActivity *customActivityMessageTumblr = [[REActivity alloc] initWithTitle:@"Tumblr"
                                                                          image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Tumblr.png"]
                                                                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                                                                        [activityViewController dismissViewControllerAnimated:YES completion:^{
                                                                            
                                                                            
                                                                            self.isSharingTumbl =  YES;
                                                                            
                                                                            UIImage *myImg = [activityViewController.userInfo valueForKey:@"image"];
                                                                            NSString *stringdescriptionshre = [activityViewController.userInfo valueForKey:@"text"];
                                                                            
                                                                            SHKItem *item = [SHKItem image:myImg title:msgShare];
                                                                            item.text =  stringdescriptionshre;
                                                                            [SHKTumblr shareItem:item];
                                                                            
                                                                            
                                                                        }];
                                                                    }];
    
    
    // Compile activities into an array, we will pass that array to
    // REActivityViewController on the next step
    //
    NSArray *activities = @[customActivity, customActivityMessage, customActivityMessageFacebook, customActivityMessageTwitter, customActivityMessageInstagram, customActivityMessageTumblr];
    
    // Create REActivityViewController controller and assign data source
    //
    REActivityViewController *activityViewController = [[REActivityViewController alloc] initWithViewController:self activities:activities];
    activityViewController.userInfo = @{
                                        @"image": [UIImage imageNamed:imgShare],
                                        @"text": msgShare,
                                        @"url": [NSURL URLWithString:@"https://github.com/romaonthego/REActivityViewController"],
                                        @"coordinate": @{@"latitude": @(37.751586275), @"longitude": @(-122.447721511)}
                                        };
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        
        [activityViewController presentFromViewController:self];
    
    else{
        CGRect rectOfCellInTableView = [self.mpTableView rectForRowAtIndexPath:indexPath];
        CGRect rectOfCellInSuperview = [self.mpTableView convertRect:rectOfCellInTableView toView:[self.mpTableView superview]];
        
        _popoverControllerAc = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        activityViewController.presentingPopoverController = self.popoverControllerAc;
        [self.popoverControllerAc presentPopoverFromRect:rectOfCellInSuperview inView:[self.mpTableView superview]   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
}



#pragma mark - Git this app


-(void)giftButtonPressed:(UIBUttonSP *) button
{
    // Set up the cell...
    NSIndexPath *indexPath = button.indexPath;
    NSDictionary *dictionary = nil;
    
    if (self.isGroup)
        dictionary = (NSDictionary *) [[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    else
        dictionary = (NSDictionary *) [self.listData objectAtIndex:indexPath.row];
    

    [self processGiftApp:dictionary];
}

-(void) processGiftApp:(NSDictionary *) dictionary
{

    NSString *appid = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"appgift_id"]];
    NSString *fullURL =  [NSString stringWithFormat:@"https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/giftSongsWizard?gift=1&salableAdamId=%@&productType=C&pricingParameter=STDQ&mt=8", appid];
        
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fullURL]];
    
}


#pragma mark -
#pragma mark SKStoreProductViewControllerDelegate

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self hideHUDMB];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark  - Info


-(IBAction)infoButtonPressed:(UIBUttonSP *) button
{
    // Set up the cell...
    NSIndexPath *indexPath = button.indexPath;
    NSDictionary *dictionary = nil;
    
    if (self.isGroup)
        dictionary = (NSDictionary *) [[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    else
        dictionary = (NSDictionary *) [self.listData objectAtIndex:indexPath.row];
    
    
    [self processInfo:dictionary];
    
}

-(void) processInfo:(NSDictionary *) dictionary
{
        InfoViewController *inforVC = [[InfoViewController alloc] initWithNibName:nil bundle:nil wihPostID:self.posid];
    
        [self.navigationController pushViewController:inforVC animated:YES];
        [inforVC release];
    
}




#pragma mark  - Ads


//--khi click vao row
-(void) processAds:(NSDictionary *) dictionary
{
   /* //-- neu version pro. thi ko can lam gi ca. hoac da remove ads thi k lma gi ca
    BOOL isProV = [[dictionary valueForKey:@"is_pro_version"] boolValue];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL removedAds = [defaults boolForKey:@"removeads"];
    
    if (isProV == YES){
        return;
    }
    
    if (removedAds == YES){
        return;
    }

    
    
    //-- neu la isIAP= YES. bat iap
    BOOL isAPA = [[dictionary valueForKey:@"ipa"] boolValue];
    if (isAPA == YES)
    {
       
        
    }else{ //-- link to pro version

        NSString *link_pro_version = [dictionary valueForKey:@"link_proversion"];
        [self openMoreApps:link_pro_version];
        
    }
    */
}


-(void) callAds:(UIBUttonSP *) button
{
    // Set up the cell...
    NSIndexPath *indexPath = button.indexPath;
    NSDictionary *dictionary = nil;
    
    if (self.isGroup)
        dictionary = (NSDictionary *) [[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    else
        dictionary = (NSDictionary *) [self.listData objectAtIndex:indexPath.row];

    [self processAds:dictionary];
    
}


-(void) buttonAdsSwitch:(SPSwitch *) button
{
    // Set up the cell...
    NSIndexPath *indexPath = button.indexPath;
    NSDictionary *dictionary = nil;
    
    if (self.isGroup)
        dictionary = (NSDictionary *) [[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    else
        dictionary = (NSDictionary *) [self.listData objectAtIndex:indexPath.row];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL versionApp = [defaults boolForKey:@"nothinginapp"];
    //NSLog(@"Switch");
    
    if (versionApp){ // ban pro
        
        NSString *linkSetting = [defaults valueForKey:@"LinkAppPro"];
    
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:kTitleAlertLinkProversion message:kDetailAlertLinkProversion delegate:self cancelButtonTitle:@"May be later" otherButtonTitles:@"Sure!", nil];
        [alertview  show];
        [alertview setTag:197];
        [alertview show];
        
        objc_setAssociatedObject(alertview, &ConstantKeyAlertView, linkSetting, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        return;
    }
    
    
    //-- neu version pro. thi ko can lam gi ca. hoac da remove ads thi k lma gi ca
    BOOL removedAds = [defaults boolForKey:@"removeads"];
    //--da remove ads
    if (removedAds == YES)
    {
        //-- neu la off thi set show ads bang off, mặc dù mua rùi
        if (button.on == YES){
            
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:kTitleShowAdsAgain message:kDetailShowAdsAgain delegate:self cancelButtonTitle:@"Ignore" otherButtonTitles:@"Turn on", nil];
            [alertview  show];
            [alertview setTag:195];
            [alertview show];
        
            objc_setAssociatedObject(alertview, &ConstantKeyAlertView, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
        }else{
            
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:kTitleTurnOffAdsAgain message:kDetailTurnOffAdsAgain delegate:self cancelButtonTitle:@"Ignore" otherButtonTitles:@"Turn Off", nil];
            [alertview  show];
            [alertview setTag:195];
            [alertview show];
            
            objc_setAssociatedObject(alertview, &ConstantKeyAlertView, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
        }
        
        return;
    }
    
    
    
    //--nguoc lai thi set
    if (button.on == NO)
    {
                        
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:kTitleAlertRemoveAds message:kDetailAlertRemoveAds delegate:self cancelButtonTitle:@"Remove" otherButtonTitles:@"Not now", nil];
        [alertview  show];
        [alertview setTag:1];
        [alertview show];
        
         objc_setAssociatedObject(alertview, &ConstantKeyAlertView, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag =  alertView.tag;
    NSString *associatedString = @"";
    UISwitch *button = nil;
    
    switch (tag) {
        case 1:
            
            if (buttonIndex == 0){
                
                //--buy
                [self performSelector:@selector(buyButtonTapped)];
                
            }else{
                
                [self.mpTableView reloadData];
                
            }
            
            break;
        case 2:
        case 3:
            
            [self reload];
            [self.mpTableView reloadData];
            
            break;
            
        case 197:
            
            if (buttonIndex == 1)
            {
                associatedString = objc_getAssociatedObject(alertView, &ConstantKeyAlertView);
                [self openMoreApps:associatedString];
               
            }else{
                [self.mpTableView reloadData];
                
            }
            
            break;
            
        case 195:
            
            
            if (buttonIndex == 1)
            {
                button = objc_getAssociatedObject(alertView, &ConstantKeyAlertView);
              
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                if (button.on == NO)
                {
                    [defaults setBool:NO forKey:@"showads"];
                    
                }else{
  
                    [defaults setBool:YES forKey:@"showads"];
                }
                
                [defaults synchronize]; 

            }else{
                
                [self.mpTableView reloadData];
                
            }
            
            break;
        default:
            break;
    }
}



#pragma mark - IAP


- (void)showWithLabelHUD {
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.dimBackground = YES;
	
    
    HUD.labelText = kTitleLoading;
    HUD.detailsLabelText = kDetailTextLoading;
    
    
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
	[HUD show:YES];
}


-(void) hideHUDMB
{
    [HUD hide:YES];
    
}


- (void)buyButtonTapped {
    
    if (self.products.count > 0){
        
        [self showWithLabelHUD];
        [self  performSelector:@selector(hideHUDMB) withObject:nil afterDelay:180];
        
         SKProduct *product = self.products[0];
        [[RageIAPHelper sharedInstance] buyProduct:product];
        
        
    }else{
        
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Loading data" message:@"Please wait for a minute while loading data from Apple"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alertview.tag = 3;
        [alertview show];
        [alertview release];
    }
    
}

- (void)restoreTapped:(id)sender {
    
    [self showWithLabel];
    [self  performSelector:@selector(hideHUDMB) withObject:nil afterDelay:180];
    
    [[RageIAPHelper sharedInstance] restoreCompletedTransactions];
}

/*
-(void) restoreCompleted:(NSNotification *) notification
{
    NSDictionary *infor = [notification userInfo];
    SKPaymentQueue *queue = [infor valueForKey:@"infoRestore"];
    
    [self hideHUDMB];
    
    if (queue.transactions.count > 0)
    {
        NSMutableArray *stringInfentifiers = [NSMutableArray array];
        for (SKPaymentTransaction *transaction in queue.transactions)
        {
            NSLog(@"received restored transactions: %@",  transaction.payment.productIdentifier);
            NSString *productID = transaction.payment.productIdentifier;
            [stringInfentifiers  addObject:productID];
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:stringInfentifiers forKey:@"dataRestore"];
        [defaults synchronize];
        
        //--check complete
        if (self.products.count > 0 )
        {
              SKProduct *product = self.products[0];
            if ([stringInfentifiers containsObject:product.productIdentifier])
            {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setBool:YES forKey:@"removeads"];
                [defaults setBool:NO forKey:@"showads"];
                [defaults synchronize];
                
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Restore Completed" message:@"Removing ads has been successed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alertview.tag = 2;
                [alertview show];
                [alertview release];

            }
        }
        
    }else{
        
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Restore message" message:@"You don't have any purchased packages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertview show];
        [alertview release];

        
    }
}
*/



- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productBuyFailed:) name:IAPHelperProductFailedNotification object:nil];
    
    self.navigationController.navigationBarHidden =  YES;
    
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
    
}

- (void)productPurchased:(NSNotification *)notification {
    
    [self hideHUDMB];
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"removeads"];
            [defaults setBool:NO forKey:@"showads"];
            [defaults synchronize];
            
            *stop = YES;
            
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Remove Ads" message:@"Removing ads has been successed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alertview.tag = 2;
            [alertview show];
            [alertview release];
        }
    }];
    
}

-(void) productBuyFailed:(NSNotification *) ns
{
    [self hideHUDMB];
    [self.mpTableView reloadData];
}


- (void)reload {
    
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            
            NSLog(@"products sucess: %@", products);
            self.products = products;
        }
    }];
}


#pragma mark - More App


-(void) openMoreApps:(NSString *) linkSetting
{
    linkSetting = [linkSetting stringByReplacingOccurrencesOfString:@"https://" withString:@"itms-apps://"];
    NSLog(@"link setting: %@", linkSetting);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkSetting]];
}


-(void) callMoreApp:(UIBUttonSP *) button
{
    [self processMoreApp:button.indexPath];
    
}


-(void) processMoreApp:(NSIndexPath *) indexPath
{

    // Set up the cell...
    NSDictionary *dictionary = nil;
    
    if (self.isGroup)
        dictionary = (NSDictionary *) [[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    else
        dictionary = (NSDictionary *) [self.listData objectAtIndex:indexPath.row];
    
 
    NSString *nameFilePlist = @""; // name plist file, not include @"plist" extension
    UIImage *imageData = [UIImage imageNamed:@"icon_gray.png"]; //-- when you have been not loaded real icon
    
    MorePageViewController *pageViewController = [MorePageViewController initWithWithData:nameFilePlist withIconUnActive:imageData];
    pageViewController.titleStr = [dictionary valueForKey:@"name_setting"]; //name screen
    pageViewController.adUnitId = self.adUnitId;
    
    pageViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:pageViewController animated:YES completion:^{
        
        
    }];
    
    //--free memory
    [pageViewController release];

    
}


#pragma mark - Title


-(void) addTitle
{
    //--uiimage background
    UIImage *image = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?[UIImage imageNamed:@"SettingBar_no.png"]: [UIImage imageNamed:@"SettingBar-iPad_no.png"];
    
    UIImageView *backgroundviewNavigation = [[UIImageView alloc] initWithImage:image];
    CGRect frameNavigation = CGRectZero;
    frameNavigation.origin = CGPointZero;
    frameNavigation.size =  image.size;
    
    
    UILabel *titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-70 , 12.0f, 140, 21.0f)];
    
    titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    titleLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    titleLabel.layer.shadowRadius = 1.0;
    titleLabel.layer.shadowOpacity = 1.0;
    titleLabel.layer.masksToBounds = NO;
    
    
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText: @"Settings"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [backgroundviewNavigation addSubview:titleLabel];
    [titleLabel release];
    [self.view addSubview:backgroundviewNavigation];

    
    //--button black
    UIButton *buttonBlack = [UIButton buttonWithType:UIButtonTypeCustom];
   
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        [buttonBlack setImage:[UIImage imageNamed:@"navbar_icon_back.png"] forState:UIControlStateNormal];
        buttonBlack.frame = CGRectMake(0, 0, 46, 44);
        buttonBlack.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        
        [buttonBlack setImage:[UIImage imageNamed:@"navbar_icon_back.png"] forState:UIControlStateNormal];
        buttonBlack.frame = CGRectMake(0, 0, 46, 44);
        buttonBlack.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [buttonBlack addTarget:self action:@selector(buttonBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBlack];
    
    
    //--restore
    if (self.isDisplayRestoreButton == YES){
        
        UIButton *buttonRestore = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonRestore setImage:[UIImage imageNamed:@"restore_icon.png"] forState:UIControlStateNormal];
        buttonRestore.frame = CGRectMake(self.view.frame.size.width-44, 0, 44, 44);
        buttonRestore.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [buttonRestore addTarget:self action:@selector(restoreTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:buttonRestore];
    }
    
}


//--block completion
- (void) dimissCompletion:(DismissViewCompletion) blockCompletion
{
    self.blockCompletion =  blockCompletion;
}


-(void)buttonBack
{
    if (self.isSharingTumbl){
#ifdef DEBUG
        NSLog(@"Connecting thumbl...");
#endif
        
        return;
    }
    
    self.blockCompletion();
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - Background view

/**
 Init background view
 **/
-(void) initBackgroundView
{
    if (!_spBackgroundView)
    {
        _spBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _spBackgroundView.autoresizesSubviews =  YES;
        _spBackgroundView.autoresizingMask =  UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        if (self.imageBackground)
            [self.spBackgroundView setImage:self.imageBackground];
        else
            self.view.backgroundColor = [UIColor whiteColor];
        
        
        [self.view addSubview:_spBackgroundView];
        
        
        
        //--add background group
        UIImage *image = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?[UIImage imageNamed:@"CellBg.png"]: [UIImage imageNamed:@"CellBg-iPad.png"];
        UIImageView *imageViewGroup1 = [[UIImageView alloc] initWithImage:image];
        CGRect frameGroup =  CGRectZero;
        frameGroup.origin.x =  ceil(self.view.frame.size.width - image.size.width )/2;
        frameGroup.origin.y = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?86:116;
        frameGroup.size =  CGSizeMake(ceil(image.size.width), ceil(image.size.height));
        imageViewGroup1.frame =  frameGroup;
        [_spBackgroundView addSubview:imageViewGroup1];
        [imageViewGroup1 release];
        
        
        
        //--add background group2
        NSArray *rows = [self.listData objectAtIndex:1];
        UIImage *image2 = image;
        UIImageView *imageViewGroup2 = [[UIImageView alloc] initWithImage:image2];
  
        if (rows.count == 4){
            image2 = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?[UIImage imageNamed:@"CellBg4rows.png"]: [UIImage imageNamed:@"CellBg-iPad4rows.png"];
            imageViewGroup2.image = image2;
        }
        CGRect frameGroup2 =  CGRectZero;
        frameGroup2.origin.x =  ceil(self.view.frame.size.width - image.size.width )/2;
        frameGroup2.origin.y = frameGroup.origin.y + image.size.height + 44;
        frameGroup2.size =  CGSizeMake(ceil(image2.size.width), ceil(image2.size.height));
        
        imageViewGroup2.frame =  frameGroup2;
        [_spBackgroundView addSubview:imageViewGroup2];
        
        /*NSLog(@"Size1: %@", NSStringFromCGRect(imageViewGroup1.frame));
        NSLog(@"Size2: %@", NSStringFromCGRect(imageViewGroup2.frame));*/
    }
    
}


#pragma mark -  UITableView



-(void) initTableView
{
    if (!_mpTableView)
    {
        CGRect rect = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-44);
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            rect.size.width = 546;
            rect.origin.x = ceil((self.view.frame.size.width - rect.size.width)/2);
            rect.origin.y = 62;
        }
        UITableViewStyle style = UITableViewStylePlain;
        if (self.isGroup)
            style = UITableViewStyleGrouped;
        
        _mpTableView = [[UITableView alloc] initWithFrame:rect style:style];
        [self.mpTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight];
        
        self.mpTableView.backgroundColor = [UIColor clearColor];
        self.mpTableView.backgroundView = nil;
        self.mpTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [self.mpTableView setDelegate:self];
        [self.mpTableView setDataSource:self];
        
        self.mpTableView.scrollEnabled =  NO;
        
        [self.view addSubview:self.mpTableView];
        
    }
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isGroup)
       return self.listData.count;
    
    return 0;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isGroup)
        return  [[self.listData objectAtIndex:section] count];
    
    return self.listData.count;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.heightForRow != 0.0f)
        return self.heightForRow;
    
    CGFloat sizePlatform = 44.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        sizePlatform = 71.0f;
    
    return sizePlatform;
}



-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SPTableViewCell";
    
    SPTableViewCell *cell = (SPTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[SPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    
    if (self.listData.count > 0){
        
        // Set up the cell...
        NSDictionary *dictionary = nil;
        
        if (self.isGroup)
            dictionary = (NSDictionary *) [[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        else
            dictionary = (NSDictionary *) [self.listData objectAtIndex:indexPath.row];
        
        
        
        if (dictionary){
        
            NSString *nameSetting  = [dictionary valueForKey:@"name_setting"];
            NSString *iconSetting  = [dictionary valueForKey:@"icon_setting"];
            NSString *typeSetting  = [dictionary valueForKey:@"type_setting"];
        
            [cell.spTitle setTitle:nameSetting forState:UIControlStateNormal];
            cell.spTitle.indexPath =  indexPath;
          
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                iconSetting = [iconSetting stringByReplacingOccurrencesOfString:@".png" withString:@"-ipad.png"];
            
            UIImage *iconImage = [UIImage imageNamed:iconSetting];
            cell.mpIconApp.image = iconImage;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if ([typeSetting isEqualToString:moreapps])
            {
                [cell.spTitle addTarget:self action:@selector(callMoreApp:) forControlEvents:UIControlEventTouchUpInside];
                
            }else if ([typeSetting isEqualToString:ads]){
                
                cell.buttonAds.hidden = NO;
                cell.buttonAds.indexPath = indexPath;
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                    
                [cell.buttonAds addTarget:self action:@selector(buttonAdsSwitch:) forControlEvents:UIControlEventValueChanged];
                
                [cell.spTitle addTarget:self action:@selector(callAds:) forControlEvents:UIControlEventTouchUpInside];
                
                
                //--show on
                BOOL isDisplayAds = [self isDisplayAds];
                if (isDisplayAds)
                    [cell.buttonAds setOn:YES];
                else
                    [cell.buttonAds setOn:NO];
                
                
            }else if ([typeSetting isEqualToString:share]) {
                
                [cell.spTitle addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

            }else if ([typeSetting isEqualToString:ratingandreview]) {
                
               
                [cell.spTitle addTarget:self action:@selector(ratingPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                
            }else if ([typeSetting isEqualToString:gift]){
                
                [cell.spTitle addTarget:self action:@selector(giftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                
            }else if([typeSetting isEqualToString:info]){
                
                 [cell.spTitle addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                
            }else if ([typeSetting isEqualToString:newsletter]){
                
                 [cell.spTitle addTarget:self action:@selector(newsletterPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    return cell;
}

-(BOOL) isDisplayAds
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL versionApp = [defaults boolForKey:@"nothinginapp"];
    
    if (versionApp){ // ban pro version
        return YES;
    }
    
    //--check mua chua, neu chua thi YES, nguoc lai thi toi show ads
    BOOL removedAds = [defaults boolForKey:@"removeads"];
    if (removedAds)
    {
        
        BOOL showads = [defaults boolForKey:@"showads"];
        return showads;
        
    }else{
        
        return YES;

    }
    
    return YES;
}
        

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPTableViewCell *cellSP= (SPTableViewCell *) cell;
    
    CGFloat heightCell = [self tableView:tableView heightForRowAtIndexPath:indexPath];

    CGRect iconFrame =  cellSP.mpIconApp.frame;
    iconFrame.origin.y = ceil((heightCell - iconFrame.size.height)/2);
    cellSP.mpIconApp.frame =  iconFrame;
    
    CGRect titleFrame = cellSP.spTitle.frame;
    titleFrame.origin.y = ceil((heightCell-titleFrame.size.height)/2);
    
    if (self.fontSizeTitle){
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            cellSP.spTitle.titleLabel.font = [UIFont boldSystemFontOfSize:self.fontSizeTitle];
             titleFrame.origin.x =  60;
            cellSP.spTitle.frame =  titleFrame;
           
        }else{
            cellSP.spTitle.titleLabel.font = [UIFont boldSystemFontOfSize:self.fontSizeTitle + 4.0f ];
            titleFrame.origin.x =  100;
            cellSP.spTitle.frame =  titleFrame;
        }
    }
    
    if (self.textCellColor)
        [cellSP.spTitle setTitleColor:self.textCellColor forState:UIControlStateNormal];
    
    cellSP.backgroundColor = [UIColor clearColor];
    
    CGRect frameAdsLeft = cellSP.buttonAds.frame;
    frameAdsLeft.origin.y = ceil((heightCell - frameAdsLeft.size.height)/2);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        frameAdsLeft.origin.x = (cellSP.frame.origin.x +  cellSP.frame.size.width)- frameAdsLeft.size.width - 10;
    }else{
         frameAdsLeft.origin.x = (cellSP.frame.origin.x +  cellSP.frame.size.width)- frameAdsLeft.size.width - 40;
    }
    cellSP.buttonAds.frame =  frameAdsLeft;
    
    
    
    cellSP.backgroundViewCell.hidden =  YES;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"APP INFO";
    }
    else if(section == 1)
    {
        return @"SOCIAL";
    }
    
    return @"";
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.isGroup && section == 1)
    return 300;
    
    return 0;
}


/*

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.isGroup && section == 1)
    {
        CGRect frameTableview = tableView.frame;
        frameTableview.origin.x = 50;
        frameTableview.origin.y = 0;
        frameTableview.size.height = 300;
        
        UIView *view = [[[UIView alloc] initWithFrame:frameTableview] autorelease];
        
        UILabel *label = nil;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, tableView.frame.size.width, 37)];
        else
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, tableView.frame.size.width, 37)];
        
        [label setText:@"iDelete™"];
        [label setTextColor:[UIColor colorWithRed:71.0f/256.0f green:71.0f/256.0f blue:71.0f/256.0f alpha:1.0]];
        [label setBackgroundColor:[UIColor clearColor]];
        label.numberOfLines =  0;
        label.font = [UIFont boldSystemFontOfSize:18.0f];
        label.textAlignment =  NSTextAlignmentCenter;
        
        UILabel *labelDes = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.origin.y + label.frame.size.height, tableView.frame.size.width, 200)];
        [labelDes setText:@"Version 1.0.0\n\n Copyright by ProtectStar Inc.\nAll rights reserved.\n\n"];
        [labelDes setTextColor:[UIColor colorWithRed:71.0f/256.0f green:71.0f/256.0f blue:71.0f/256.0f alpha:1.0]];
        [labelDes setBackgroundColor:[UIColor clearColor]];
        labelDes.numberOfLines =  0;
        labelDes.font = [UIFont systemFontOfSize:16.0f];
        labelDes.textAlignment =  NSTextAlignmentCenter;
        [labelDes sizeToFit];
        labelDes.frame = CGRectMake(labelDes.frame.origin.x, labelDes.frame.origin.y, tableView.frame.size.width, labelDes.frame.size.height);
        
        CGFloat sizeWesiteOriginY = labelDes.frame.origin.y + labelDes.frame.size.height;
        UILabel *websiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeWesiteOriginY , tableView.frame.size.width, 200)];
        [websiteLabel setText:@"wwww.protectstar.com"];
        [websiteLabel setTextColor:[UIColor colorWithRed:71.0f/256.0f green:71.0f/256.0f blue:71.0f/256.0f alpha:1.0]];
        [websiteLabel setBackgroundColor:[UIColor clearColor]];
        websiteLabel.numberOfLines =  0;
        websiteLabel.font = [UIFont systemFontOfSize:16.0f];
        websiteLabel.textAlignment =  NSTextAlignmentCenter;
        [websiteLabel sizeToFit];
        websiteLabel.frame = CGRectMake(websiteLabel.frame.origin.x, websiteLabel.frame.origin.y, tableView.frame.size.width, websiteLabel.frame.size.height);

        [self setLabelUnderline:websiteLabel];
        
        
        [view addSubview:label];
        [view addSubview:labelDes];
        [view addSubview:websiteLabel];
        
        [label release];
        [labelDes release];
        [websiteLabel release];
        
        return view;
    }
    
    
    return nil;
}*/



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set up the cell...
    NSDictionary *dictionary = nil;
    
    if (self.isGroup)
        dictionary = (NSDictionary *) [[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    else
        dictionary = (NSDictionary *) [self.listData objectAtIndex:indexPath.row];
    
    
    
    NSString *typeApp = [dictionary valueForKey:@"type_setting"];
    
    //--more app
    if ([typeApp isEqualToString:moreapps])
    {
        [self processMoreApp:indexPath];
        
    }else  if ([typeApp isEqualToString:ads]) //--ads
    {
        [self processAds:dictionary];
        
    }else if ([typeApp isEqualToString:info]){
        
        [self processInfo:dictionary];
        
    }else if ([typeApp isEqualToString:gift]){
        
        [self processGiftApp:dictionary];
        
    }else  if ([typeApp isEqualToString:share]){
        
        [self processShare:nil withIndexPath:indexPath];
    
    }else if ([typeApp isEqualToString:ratingandreview]) {
        
        [self rating:dictionary];
        
    }else if ([typeApp isEqualToString:newsletter]){
        
        [self processNewsLetter:dictionary];
        
    }

}




-(UILabel *)setLabelUnderline:(UILabel *)label{
    
    CGSize expectedLabelSize = [label.text sizeWithFont:label.font constrainedToSize:label.frame.size lineBreakMode:label.lineBreakMode];
    UIView *viewUnderline=[[UIView alloc] init];
    CGFloat xOrigin=0;
    switch (label.textAlignment) {
        case NSTextAlignmentCenter:
            xOrigin=(label.frame.size.width - expectedLabelSize.width)/2;
            break;
        case NSTextAlignmentLeft:
            xOrigin=0;
            break;
        case NSTextAlignmentRight:
            xOrigin=label.frame.size.width - expectedLabelSize.width;
            break;
        default:
            break;
    }
    viewUnderline.frame=CGRectMake(xOrigin,
                                   expectedLabelSize.height-1,
                                   expectedLabelSize.width,
                                   1);
    viewUnderline.backgroundColor=label.textColor;
    [label addSubview:viewUnderline];
    [viewUnderline release];
    
    return label;
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


#pragma mark -  CycleViewController


-(void) viewDidDisappear:(BOOL)animated
{
    self.isSharingTumbl =  NO;
    [super viewDidDisappear:animated];
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
    
   
    [self initBackgroundView];
    [self initTableView];
    [self addTitle];
    
}


/** Register notification center for view controller */
-(void) registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(defaultsChanged:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
}


-(void) defaultsChanged:(NSNotification *) ns
{
    [self.mpTableView reloadData];
}


/** Set data when view did load.
 ** Be there. You can set up some variables, data, or any thing that have reletive to data type*/
-(void) setDataWhenViewDidLoad
{
     [self reload];
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
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_popoverControllerAc release];
    [_spBackgroundView release];
    [_listData release];
    [_mpTableView release];
    [_textCellColor release];
    [_imageBackground release];
    
    [_imageBg release];
    [_imageAds release];
    
    [_products release];
    
    [_posid release];
    
    [_adUnitId release];
    
    [_msgShare release];
    
    [_blockCompletion release];
    
    [_imageSharing release];
    
    [super dealloc];
}
@end
