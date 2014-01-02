//
//  MorePageViewController.h
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/2/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MorePageViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


/**
 Navigation bar, you can change title for view, instead of "More pages", you can change "My Apps", or anything you want
 Also allow you change to title for button "Done". The way is same title.
 Also allow you change color navigation bar, instead of drak color, you can change to white, orange...you want
 **/
@property (retain, nonatomic) UIToolbar *mpNavigationBar;

/**
 @mpBackgroundView allows you change background for your view. you can set image into it 
 */
@property (retain, nonatomic) UIImageView *mpBackgroundView;

/**
 @mpTableView. This is a open view. We will introduce it later
 **/
@property (retain, nonatomic) UITableView *mpTableView;

/**
 @imageUnActive. When your icon app has been not loaded yet. we use this image to display
 */
@property (nonatomic, copy) UIImage *mpImageUnActive;
 

@property (nonatomic, retain) NSString *titleStr;



/** 
 For each rows, we need to set height for this, if NO, we will set defaults is 44px. 
 **/
- (id) initWithHeightForRows:(CGFloat) height withData:(NSString *) fileData  withIconUnActive:(UIImage *) imageUnactive;
+ (id) initWithHeightForRows:(CGFloat) height withData:(NSString *) fileData  withIconUnActive:(UIImage *) imageUnactive;


- (id) initWithWithData:(NSString *) nameFileData withIconUnActive:(UIImage *) imageUnactive;
+ (id) initWithWithData:(NSString *) nameFileData withIconUnActive:(UIImage *) imageUnactive;






@end
