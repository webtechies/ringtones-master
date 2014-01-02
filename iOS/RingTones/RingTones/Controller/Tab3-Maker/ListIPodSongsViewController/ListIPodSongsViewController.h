//
//  ListIPodSongsViewController.h
//  RingTones
//
//  Created by VinhTran on 12/17/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListIPodSongsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *mainTableView;
    
    NSMutableArray *searchResults;
    NSString *savedSearchTerm;
    
    NSArray *arrSource;
    NSMutableArray *arIndices;
    NSMutableArray *arContent;
}


@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, copy) NSString *savedSearchTerm;

- (void)handleSearchForTerm:(NSString *)searchTerm;


@end
