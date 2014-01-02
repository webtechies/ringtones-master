//
//  DownloadingViewController.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadingCell.h"

@interface DownloadingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *mainTableView;
    
    
    NSMutableArray *arrSource;
    
    NSTimer *timerDownloading;
    
    DownloadingCell *downloadingCell;
    
    BOOL isDeleting;
}

- (void)clearData;


@end
