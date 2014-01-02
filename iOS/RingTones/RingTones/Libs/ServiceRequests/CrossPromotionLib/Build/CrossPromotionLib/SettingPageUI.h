//
//  SettingPageUI.h
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/3/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD.h"



extern const NSString *ConstantKeyAlertView;

typedef void (^DismissViewCompletion)();


@interface SettingPageUI : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, SKStoreProductViewControllerDelegate, UIAlertViewDelegate, MBProgressHUDDelegate>
{
    	MBProgressHUD *HUD;
}


/**
 This is a property that allows you set up background view for your view
 @spBackgroundView is an UIImageView
 **/
@property (nonatomic, retain) UIImageView *spBackgroundView;

/**
 @mpTableView. This is a open view. We will introduce it later
 **/
@property (retain, nonatomic) UITableView *mpTableView;

/**
 @isGroup. The tableview will arrange group
*/
@property (assign, nonatomic) BOOL isGroup;

/**
 @textCellColor. The property that allows you change color text in each cell Page Setting. 
 You can set up blackColor, redColor, or anything you want. Default is blackColor
*/
@property (copy, nonatomic) UIColor *textCellColor;

/**
 @heightForRow. The height for row of the tableview. 
 **/
@property (assign, nonatomic) CGFloat heightForRow;


/**
 @fontSizeTitle. The propety allows you set font size title.
 **/
@property (assign, nonatomic) CGFloat fontSizeTitle;

/**
 @imageBackground. Image background view
 **/
@property (nonatomic, retain) UIImage *imageBackground;


/**
 @imageBg. Image set background
 **/
@property (nonatomic, retain) UIImage *imageBg;

/**
 @imageAds. Image use to show why i need to remove ads
 **/
@property (nonatomic, retain) UIImage *imageAds;


@property (nonatomic, retain) UIPopoverController *popoverControllerAc;


/**
 @post id. Post of about page 
 **/
@property (nonatomic, retain) NSString *posid;


/**
 @kAdmobID. Id account back-end
 **/
@property (nonatomic, retain) NSString *adUnitId;


/**
 @msgShare. This is a message sharing
 **/
@property (nonatomic, retain) NSString *msgShare;


/**
 @blockCompletion block dismiss view
 **/
@property (nonatomic, copy) DismissViewCompletion blockCompletion;


/**
 @image sharing. When you click on share row in the tableview, the image get to share.
 **/
@property (nonatomic, copy) NSString *imageSharing;


/**
 @allow display restore or
 **/
@property (nonatomic, assign) BOOL isDisplayRestoreButton;



/**
 The mothod init setting view. You should pass name file plist into it. This is file needs to configure your view
 */
- (id) initWithPlistFile:(NSString *) nameFilePlist;
+ (id) initWithPlistFile:(NSString *) nameFilePlist;


- (id) initWithPlistFile:(NSString *) nameFilePlist withImageBg:(UIImage *) imageBackground ;
+ (id) initWithPlistFile:(NSString *) nameFilePlist withImageBg:(UIImage *) imageBackground ;


- (void) dimissCompletion:(DismissViewCompletion) blockCompletion;


@end
