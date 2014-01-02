//
//  AppDelegate.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingtonePlayerViewController.h"
#import "DownloaderManager.h"
#import "RingtonePreviewViewController.h"

#import <StoreKit/StoreKit.h>
#import <StoreKit/SKProduct.h>
#import "MyStoreObserver.h"

@protocol PurchaseDelegate <NSObject>


- (void)purchaseDidFinish;
- (void)purchaseDidFail;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UIAlertViewDelegate, SKProductsRequestDelegate, SKProductsRequestDelegate, SKRequestDelegate, MyStoreObserverDelegate> {
    RingtonePlayerViewController *ringtonePlayer;
    
    RingtonePreviewViewController *ringtonePreview;
    
    BOOL isConverting;
    
    UIViewController *vcHostPurchase;
    SEL methodPurchase;
    
    BOOL isAudioSessionInitiated;
    
@private
    BOOL				purchased;	
    
    MyStoreObserver *observer_;
    
    NSString* selectedProductId;
    
}

@property (retain, nonatomic) IBOutlet UIWindow *window;
@property (retain, nonatomic) IBOutlet UITabBarController *tabbarController;
@property (retain, nonatomic) RingtonePlayerViewController *ringtonePlayer;
@property (retain, nonatomic) RingtonePreviewViewController *ringtonePreview;

@property (assign) BOOL isConverting;
@property (assign) BOOL isAudioSessionInitiated;

@property (nonatomic, retain) MyStoreObserver *observer;

- (void)startLoadingView;
- (void)stopLoadingView;
- (void) processPurchase;

#pragma In app purchase
- (void)requestProductData;
- (void)completeTransaction: (SKPaymentTransaction *)transaction;
- (void)failedTransaction:   (SKPaymentTransaction *)transaction;
- (void)restoreTransaction:  (SKPaymentTransaction *)transaction;

- (void)playRingtone:(NSString *)name onViewController:(UIViewController *)viewController;
- (void)previewRingtone:(NSDictionary *)dict onViewController:(UIViewController *)viewController;
- (void)showAlertUpgradeOnView:(UIViewController *)viewController upgradeMethod:(SEL)method;
- (void)showAlertLinkToFull:(UIViewController *)viewController;


@end
