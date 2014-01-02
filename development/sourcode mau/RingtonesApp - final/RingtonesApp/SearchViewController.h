//
//  SearchViewController.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingtoneCell.h"
#import "LoadmoreCell.h"
#import "BannerViewController.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"

@interface SearchViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIActionSheetDelegate, PurchaseDelegate, ASIHTTPRequestDelegate> {
    IBOutlet UITableView *mainTableView;
    IBOutlet UIView *viewBannerPlaceHolder;
    
    BannerViewController *banner;
    
    RingtoneCell *customCell;
    LoadmoreCell *loadmoreCell;

    NSMutableArray *arrSource;
    
    NSString *savedSearchTerm;
    
    NSMutableArray *arrLoadmore;
    
    NSInteger currentMinId;
    
    NSInteger selectedIndex;
    
    BOOL isLoading;
}

@property (nonatomic, copy) NSString *savedSearchTerm;

- (void)handleSearchForTerm:(NSString *)searchTerm;


@end
