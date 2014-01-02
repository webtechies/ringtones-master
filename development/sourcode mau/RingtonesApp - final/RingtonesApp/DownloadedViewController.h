//
//  DownloadedViewController.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DownloadedCell.h"

@interface DownloadedViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UIActionSheetDelegate> {
    IBOutlet UITableView *mainTableView;
    
    DownloadedCell *customCell;
    
    NSMutableArray *arrSource;
    
    NSMutableArray *searchResults;
    NSString *savedSearchTerm;
    
    AppDelegate *delegate;
    
    NSInteger indexToEmail;
}

@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, copy) NSString *savedSearchTerm;

- (void)handleSearchForTerm:(NSString *)searchTerm;

- (void)updateOffset;

- (void)reloadDataSource;

@end
