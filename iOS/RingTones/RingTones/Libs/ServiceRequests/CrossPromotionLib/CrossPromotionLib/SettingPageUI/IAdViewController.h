//
//  ViewController.h
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/5/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IAdViewController : UIViewController<UIAlertViewDelegate>


/**
 @imageBg. Image set background
 **/
@property (nonatomic, retain) UIImage *imageBg;

/**
 @imageAds. Image use to show why i need to remove ads
 **/
@property (nonatomic, retain) UIImage *imageAds;

/**
 @imageButtonRemoveAds. Image use to set button remove ads
 **/
@property (nonatomic, retain) UIImage *imageButtonRemoveAds;

/**
 @buttonUpgrade. Button uprade
 **/
@property (nonatomic, retain) UIButton *buttonUpgrade;



@end
