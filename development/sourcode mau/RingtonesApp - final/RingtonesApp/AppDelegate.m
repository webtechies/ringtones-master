//
//  AppDelegate.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonUtils.h"
#import "Constants.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabbarController = _tabbarController;
@synthesize ringtonePlayer;
@synthesize ringtonePreview;
@synthesize isConverting;
@synthesize isAudioSessionInitiated;


@synthesize observer = observer_;

SKProductsRequest *request;

- (void)dealloc
{
    [_window release];
    [_tabbarController release];
    [ringtonePlayer release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //delete tmp folder
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    if ([fileMgr fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:kTempFolderPreview] isDirectory:nil]) {
        
        NSArray *arrContent = [fileMgr contentsOfDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent:kTempFolderPreview] error:nil];
        if (arrContent && [arrContent count] > 0) {
            for (int i = 0; i < [arrContent count]; i++) {
                NSString *filePath = [arrContent objectAtIndex:i];
                filePath = [CommonUtils pathForSourceFile:filePath inDirectory:kTempFolderPreview];
                [fileMgr removeItemAtPath:filePath error:nil];
            }            
        } 
    }

    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        ringtonePlayer = [[RingtonePlayerViewController alloc]initWithNibName:@"RingtonePlayerViewController~iPad" bundle:nil];    
    } else {
        ringtonePlayer = [[RingtonePlayerViewController alloc]initWithNibName:@"RingtonePlayerViewController" bundle:nil];
    }
    
//    ringtonePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    
    ringtonePreview = [[RingtonePreviewViewController alloc]initWithNibName:@"RingtonePreviewViewController" bundle:nil];
//    ringtonePreview.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;

    
    purchased = [[[NSUserDefaults standardUserDefaults]objectForKey:kPurchaseKey] boolValue];
    
    if (!purchased) {
        //register in app purchase
        // Override point for customization after application launch
        observer_ = [[MyStoreObserver alloc] init];
        
        observer_.delegate = self;
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self.observer];
        //    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    }
    
    self.window.rootViewController = self.tabbarController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)playRingtone:(NSString *)name onViewController:(UIViewController *)viewController {
    [self.ringtonePlayer playRingtone:name onViewController:viewController];
}

- (void)previewRingtone:(NSDictionary *)dict onViewController:(UIViewController *)viewController {
    [self.ringtonePreview loadPreviewWithDict:dict onViewController:viewController];
}

- (void)showAlertUpgradeOnView:(UIViewController *)viewController upgradeMethod:(SEL)method;
{
    vcHostPurchase = viewController;
    methodPurchase = method;
    //show alert reach max limit download
    [CommonUtils showAlertViewWithTag:TAG_MAX_DOWNLOAD_LIMIT 
                             delegate:self 
                            withTitle:@"" 
                              message:MSG_MAX_DOWNLOAD_LIMIT 
                    cancelButtonTitle:BUTTON_CLOSE 
                    otherButtonTitles:BUTTON_UPGRADE, nil];
}

- (void)showAlertLinkToFull:(UIViewController *)viewController;
{
    //show alert reach max limit download
    [CommonUtils showAlertViewWithTag:TAG_ALERT_LINK_FULL_VER
                             delegate:self 
                            withTitle:@"" 
                              message:MSG_LINK_FULL_VER 
                    cancelButtonTitle:BUTTON_CLOSE 
                    otherButtonTitles:BUTTON_GO_TO_FULL_VER, nil];
}

#pragma -
#pragma alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == TAG_MAX_DOWNLOAD_LIMIT) {
        if ([alertView cancelButtonIndex] != buttonIndex) { //button purchase
//            [vcHostPurchase performSelector:methodPurchase];
            
            [self processPurchase];
        }
    }
    
    if ([alertView tag] == TAG_ALERT_LINK_FULL_VER) {
        if ([alertView cancelButtonIndex] != buttonIndex) { //button go to full ver
            [CommonUtils openURLExternalHandlerForLink:kLinkAppFull];        
        }
    }
}


- (void) processPurchase;
{
    if ([SKPaymentQueue canMakePayments])
    {
        selectedProductId = kProductIAP;
        
        //display loading view
        [self startLoadingView];
        
        // Display a store to the user.
        [self requestProductData];
    }
    else
    {
        // Warn the user that purchases are disabled.
        [CommonUtils showAlertViewWithTitle:NSLocalizedString(ALERT_ALARM_TITLE, @"")  
                                    message:NSLocalizedString(ALERT_CONTENT_CANNOT_IAP, @"") 
                          cancelButtonTitle:NSLocalizedString(BUTTON_CLOSE, @"") ];
        //NSLog(@"ALERT_CONTENT_CANNOT_IAP");
    }
}


#pragma mark -
#pragma mark Store request

- (void) requestProductData
{
	request= [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObjects:selectedProductId, nil]];
	request.delegate = self;
	[request start];
    [self startLoadingView];
}
- (void) startPurchase {
    [self startLoadingView];
	SKMutablePayment *payment = [SKMutablePayment paymentWithProductIdentifier:selectedProductId];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    //    [self stopLoadingView];
    NSArray *myProduct = response.products;
	if (myProduct == nil || [myProduct count] == 0) 
	{
        [CommonUtils showAlertViewWithTitle:NSLocalizedString(ALERT_ALARM_TITLE,@"") 
                                    message:NSLocalizedString(ALERT_CONTENT_MISSING_PRODUCT,@"")
                          cancelButtonTitle:NSLocalizedString(BUTTON_CLOSE,@"")];
		
        NSLog(@"ALERT_CONTENT_MISSING_PRODUCT");
        [self stopLoadingView];
		return;
	}
	SKProduct *product;
	BOOL	existProduct = NO;
	for (int i = 0; i < [myProduct count]; i++) {
		product = (SKProduct*)[myProduct objectAtIndex:0];
		if ([product.productIdentifier isEqualToString:selectedProductId]) {
			existProduct = YES;
			break;
		}
	}
	if (existProduct == NO) {
        [CommonUtils  showAlertViewWithTitle:NSLocalizedString(ALERT_ALARM_TITLE,@"")  
                                     message:NSLocalizedString(ALERT_CONTENT_MISSING_PRODUCT_NO_MATCH ,@"") 
                           cancelButtonTitle:NSLocalizedString(BUTTON_CLOSE,@"") ];
        
        NSLog(@"ALERT_CONTENT_MISSING_PRODUCT_NO_MATCH");
        [self stopLoadingView];
		return;
	}
    
    [request autorelease];
	[self startPurchase];
}
#pragma mark -
#pragma mark observer delegate

- (void) completePurchase;
{
    purchased = YES;
    [[NSUserDefaults standardUserDefaults]setObject:@"TRUE" forKey:kPurchaseKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kPurchaseKey object:nil];
    
    
    if (vcHostPurchase != nil && [vcHostPurchase respondsToSelector:@selector(purchaseDidFinish)]) {
        [vcHostPurchase performSelector:@selector(purchaseDidFinish)];
    }
    
}

- (void)requestDidFinish:(SKRequest *)request {
    [self stopLoadingView];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"request fail with erorr: %@", [error localizedDescription]);
    [self stopLoadingView];
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                
                [self completePurchase];
                
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                [self completePurchase];
            default:
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
	//stop loading view
    [self stopLoadingView];
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    //stop loading view
    [self stopLoadingView];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];    
    
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    //stop loading view
    [self stopLoadingView];
    NSLog(@"failedTransaction: %d", [transaction error].code);
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // Optionally, display an error here.
		NSString *stringError = NSLocalizedString(ALERT_CONTENT_PAYMENT_CANCEL,@"");
        stringError = [NSString stringWithFormat:stringError, [[transaction error]localizedDescription]];
        [CommonUtils showAlertViewWithTitle:NSLocalizedString(ALERT_ALARM_TITLE,@"")  
                                    message:stringError 
                          cancelButtonTitle:NSLocalizedString(BUTTON_CLOSE,@"") ];
        
		
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    if (vcHostPurchase != nil && [vcHostPurchase respondsToSelector:@selector(purchaseDidFail)]) {
        [vcHostPurchase performSelector:@selector(purchaseDidFail)];
    }

    
}


- (void) startLoadingView;
{
    [CommonUtils startIndicatorDisableViewController:vcHostPurchase];
    vcHostPurchase.navigationItem.rightBarButtonItem.enabled = NO;
    vcHostPurchase.navigationItem.leftBarButtonItem.enabled = NO;
}

- (void) stopLoadingView;
{
    [CommonUtils stopIndicatorDisableViewController:vcHostPurchase];
    vcHostPurchase.navigationItem.rightBarButtonItem.enabled = YES;
    vcHostPurchase.navigationItem.leftBarButtonItem.enabled = YES;
}


- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
    [self.ringtonePlayer updateFrame];
    [self.ringtonePreview updateFrame];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UIViewController *selectedVC = [tabBarController.viewControllers objectAtIndex:tabBarController.selectedIndex];
    
    if (isConverting || selectedVC == viewController) {
        return NO;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self.observer];
}

@end
