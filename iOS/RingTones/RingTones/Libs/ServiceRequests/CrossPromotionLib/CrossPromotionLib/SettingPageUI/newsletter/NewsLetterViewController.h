//
//  NewsLetterViewController.h
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/11/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsLetterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>


@property (nonatomic, retain) UITextField *email;
@property (nonatomic, retain) UIImage *imageBg;

@property (nonatomic, retain) UITableView *nlTableView;

@end
