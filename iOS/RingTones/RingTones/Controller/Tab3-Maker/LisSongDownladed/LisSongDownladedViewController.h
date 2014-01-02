//
//  LisSongDownladedViewController.h
//  RingTones
//
//  Created by VinhTran on 12/24/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LisSongDownladedViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *mainTableView;
    
    NSMutableArray *searchResults;
    NSString *savedSearchTerm;
    
    NSMutableArray *arrSource;
    NSMutableArray *arIndices;
    NSMutableArray *arContent;
}


@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic, retain) NSMutableArray *arContent;
@property (nonatomic, retain) NSMutableArray *arrSource;

- (void)handleSearchForTerm:(NSString *)searchTerm;


@end
