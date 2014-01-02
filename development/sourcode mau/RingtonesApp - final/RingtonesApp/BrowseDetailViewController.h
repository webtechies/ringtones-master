//
//  BrowseDetailViewController.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "RingtoneCell.h"
#import "LoadmoreCell.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"

@interface BrowseDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, PurchaseDelegate, ASIHTTPRequestDelegate> {

    IBOutlet UITableView *mainTableView;
    
    DataSourceType sourceType;
    
    RingtoneCell *customCell;
    LoadmoreCell *loadmoreCell;
    
    NSMutableArray *arrSource;
    
    NSMutableArray *arrLoadmore;
    
    NSInteger currentMinId;
    NSInteger selectedIndex;
    
    BOOL isLoading;
    BOOL isFirstLoad;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dataSourceType:(DataSourceType) type;


@end
