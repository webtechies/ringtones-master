//
//  CategoryViewController.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "RingtoneHelpers.h"

#import "BannerViewController.h"
#import "AppDelegate.h"


@interface CategoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate, PurchaseDelegate> {
    IBOutlet UITableView *mainTableView;
    IBOutlet UIView *viewBannerPlaceHolder;
    
    NSMutableArray *arrSource;
    
    BOOL isDownloading;
    
    BannerViewController *banner;
}

@end
