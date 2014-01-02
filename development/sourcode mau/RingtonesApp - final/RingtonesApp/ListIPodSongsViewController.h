//
//  ListIPodSongsViewController.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
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
