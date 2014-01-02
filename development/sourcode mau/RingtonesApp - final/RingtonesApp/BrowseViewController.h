//
//  BrowseViewController.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerViewController.h"
#import "AppDelegate.h"

@interface BrowseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, PurchaseDelegate> {
    IBOutlet UITableView *mainTableView;
    IBOutlet UIView *viewBannerPlaceHolder;
    
    NSMutableArray *arrSource;
    BannerViewController *banner;
}

@end
